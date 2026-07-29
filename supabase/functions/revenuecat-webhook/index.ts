// ---------------------------------------------------------------------------
// RevenueCat webhook
//
// The only writer of `users.subscription_status`. The app never sets premium
// itself: a client can be tampered with, this function cannot. RevenueCat has
// already validated the receipt with Apple or Google before calling here.
//
// Deploy:
//   supabase functions deploy revenuecat-webhook --no-verify-jwt
//
// Secrets (supabase secrets set):
//   REVENUECAT_WEBHOOK_TOKEN  shared secret, sent by RevenueCat in Authorization
//   SUPABASE_URL              injected by the platform
//   SUPABASE_SERVICE_ROLE_KEY injected by the platform
//
// `--no-verify-jwt` is required: RevenueCat has no Supabase JWT. The shared
// token below replaces it, so the check must never be skipped.
// ---------------------------------------------------------------------------

import { createClient } from 'jsr:@supabase/supabase-js@2';

/// Event types that mean "this user is entitled right now".
const GRANTING_EVENTS = new Set([
  'INITIAL_PURCHASE',
  'RENEWAL',
  'UNCANCELLATION',
  'PRODUCT_CHANGE',
  'SUBSCRIPTION_EXTENDED',
  'TEMPORARY_ENTITLEMENT_GRANT',
]);

/// Event types that end entitlement immediately.
///
/// CANCELLATION is deliberately absent: a cancelled subscription runs until its
/// expiry date, and revoking access on the spot would cut off a user who has
/// already paid for the remaining period. EXPIRATION is the event that matters.
const REVOKING_EVENTS = new Set(['EXPIRATION', 'SUBSCRIPTION_PAUSED', 'REFUND']);

Deno.serve(async (req: Request): Promise<Response> => {
  if (req.method !== 'POST') {
    return json({ error: 'method not allowed' }, 405);
  }

  const expectedToken = Deno.env.get('REVENUECAT_WEBHOOK_TOKEN');
  if (!expectedToken) {
    console.error('REVENUECAT_WEBHOOK_TOKEN is not set, refusing every call');
    return json({ error: 'server misconfigured' }, 500);
  }
  if (req.headers.get('Authorization') !== expectedToken) {
    return json({ error: 'unauthorized' }, 401);
  }

  let payload: RevenueCatPayload;
  try {
    payload = await req.json();
  } catch {
    return json({ error: 'invalid json' }, 400);
  }

  const event = payload?.event;
  if (!event?.id || !event?.type) {
    return json({ error: 'missing event' }, 400);
  }

  // RevenueCat sends test events from its dashboard. Acknowledge, do nothing.
  if (event.type === 'TEST') {
    return json({ ok: true, ignored: 'TEST' });
  }

  const userId = event.app_user_id;
  if (!userId || !isUuid(userId)) {
    // An anonymous RevenueCat id means the purchase happened before login.
    // Nothing to attach it to; 200 so RevenueCat stops retrying.
    console.warn(`event ${event.id}: unusable app_user_id "${userId}"`);
    return json({ ok: true, ignored: 'app_user_id' });
  }

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  // Idempotency guard. RevenueCat retries until it gets a 2xx, so the same
  // event can legitimately arrive several times.
  const { error: insertError } = await supabase
    .from('subscription_purchase')
    .insert({
      user_id: userId,
      event_id: event.id,
      event_type: event.type,
      product_id: event.product_id ?? null,
      store: event.store ?? null,
      environment: event.environment ?? null,
      purchased_at: toIso(event.purchased_at_ms),
      expires_at: toIso(event.expiration_at_ms),
      raw_event: payload,
    });

  if (insertError) {
    // 23505 = unique_violation on event_id: already handled, nothing to redo.
    if (insertError.code === '23505') {
      return json({ ok: true, duplicate: true });
    }
    // 23503 = foreign key: the RevenueCat id matches no row in `users`.
    if (insertError.code === '23503') {
      console.warn(`event ${event.id}: unknown user ${userId}`);
      return json({ ok: true, ignored: 'unknown user' });
    }
    console.error(`event ${event.id}: insert failed`, insertError);
    return json({ error: 'insert failed' }, 500);
  }

  const status = statusFor(event);
  if (status === null) {
    return json({ ok: true, ignored: event.type });
  }

  const { error: updateError } = await supabase
    .from('users')
    .update({
      subscription_status: status,
      subscription_expires_at:
        status === 'premium' ? toIso(event.expiration_at_ms) : null,
    })
    .eq('id_user', userId);

  if (updateError) {
    // 500 makes RevenueCat retry, which is what we want: the purchase is
    // recorded but the user is not yet premium.
    console.error(`event ${event.id}: status update failed`, updateError);
    return json({ error: 'update failed' }, 500);
  }

  return json({ ok: true, status });
});

/// Returns the status this event implies, or null when it changes nothing.
function statusFor(event: RevenueCatEvent): 'premium' | 'freemium' | null {
  if (GRANTING_EVENTS.has(event.type)) {
    // A grant whose expiry is already in the past is stale; treat it as expired.
    if (event.expiration_at_ms && event.expiration_at_ms < Date.now()) {
      return 'freemium';
    }
    return 'premium';
  }
  if (REVOKING_EVENTS.has(event.type)) return 'freemium';
  return null;
}

function toIso(ms?: number | null): string | null {
  return ms ? new Date(ms).toISOString() : null;
}

function isUuid(value: string): boolean {
  return /^[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$/i.test(
    value,
  );
}

function json(body: unknown, status = 200): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

interface RevenueCatEvent {
  id: string;
  type: string;
  app_user_id?: string;
  product_id?: string;
  store?: string;
  environment?: string;
  purchased_at_ms?: number;
  expiration_at_ms?: number;
}

interface RevenueCatPayload {
  event?: RevenueCatEvent;
}

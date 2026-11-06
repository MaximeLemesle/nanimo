// Sends one push per due article, called by pg_cron. Deploy with --no-verify-jwt:
// the cron has no user JWT, the shared token below replaces it.
// Secrets to set: PUSH_CRON_TOKEN, FIREBASE_SERVICE_ACCOUNT (the JSON key)

import { createClient, type SupabaseClient } from 'jsr:@supabase/supabase-js@2';
import { type Article, buildMessage, isDeadToken } from './message.ts';

const TOKEN_PAGE_SIZE = 1000;
const CONCURRENT_SENDS = 20;
const SCOPE = 'https://www.googleapis.com/auth/firebase.messaging';

type ServiceAccount = { project_id: string; client_email: string; private_key: string };

Deno.serve(async (req: Request): Promise<Response> => {
  const expectedToken = Deno.env.get('PUSH_CRON_TOKEN');
  const rawAccount = Deno.env.get('FIREBASE_SERVICE_ACCOUNT');

  /// Checked before claiming: a claimed article is never sent again.
  if (!expectedToken || !rawAccount) {
    console.error('PUSH_CRON_TOKEN or FIREBASE_SERVICE_ACCOUNT is not set, refusing every call');
    return json({ error: 'server misconfigured' }, 500);
  }
  if (req.headers.get('Authorization') !== expectedToken) {
    return json({ error: 'unauthorized' }, 401);
  }

  const account = JSON.parse(rawAccount) as ServiceAccount;
  const accessToken = await fetchAccessToken(account);

  const supabase = createClient(
    Deno.env.get('SUPABASE_URL')!,
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
  );

  const { data: articles, error } = await supabase.rpc('claim_due_articles');
  if (error) {
    console.error('claim_due_articles failed', error);
    return json({ error: 'claim failed' }, 500);
  }

  let sent = 0;
  let failed = 0;
  for (const article of (articles ?? []) as Article[]) {
    const result = await sendToAll(supabase, account.project_id, accessToken, article);
    sent += result.sent;
    failed += result.failed;
  }
  console.log(`articles=${articles?.length ?? 0} sent=${sent} failed=${failed}`);
  return json({ articles: articles?.length ?? 0, sent, failed }, 200);
});

async function sendToAll(
  supabase: SupabaseClient,
  projectId: string,
  accessToken: string,
  article: Article,
) {
  let sent = 0;
  let failed = 0;
  const deadTokens: string[] = [];

  for (let from = 0; ; from += TOKEN_PAGE_SIZE) {
    const { data, error } = await supabase
      .from('push_tokens')
      .select('token')
      .eq('articles_enabled', true)
      .order('token')
      .range(from, from + TOKEN_PAGE_SIZE - 1);
    if (error) {
      console.error('reading push_tokens failed', error);
      break;
    }

    const tokens = (data ?? []).map((row: { token: string }) => row.token);
    for (let i = 0; i < tokens.length; i += CONCURRENT_SENDS) {
      await Promise.all(tokens.slice(i, i + CONCURRENT_SENDS).map(async (token: string) => {
        const response = await fetch(
          `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`,
          {
            method: 'POST',
            headers: {
              'Authorization': `Bearer ${accessToken}`,
              'Content-Type': 'application/json',
            },
            body: JSON.stringify(buildMessage(token, article)),
          },
        );
        if (response.ok) {
          sent++;
          return;
        }
        failed++;
        const body = await response.text();
        if (isDeadToken(response.status, body)) {
          deadTokens.push(token);
        } else {
          console.error(`fcm ${response.status}`, body);
        }
      }));
    }
    if (tokens.length < TOKEN_PAGE_SIZE) break;
  }

  if (deadTokens.length > 0) {
    await supabase.from('push_tokens').delete().in('token', deadTokens);
  }
  return { sent, failed };
}

async function fetchAccessToken(account: ServiceAccount): Promise<string> {
  const now = Math.floor(Date.now() / 1000);
  const assertion = await signJwt(account, {
    iss: account.client_email,
    scope: SCOPE,
    aud: 'https://oauth2.googleapis.com/token',
    iat: now,
    exp: now + 3600,
  });
  const response = await fetch('https://oauth2.googleapis.com/token', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: new URLSearchParams({
      grant_type: 'urn:ietf:params:oauth:grant-type:jwt-bearer',
      assertion,
    }),
  });
  if (!response.ok) throw new Error(`google token ${response.status}: ${await response.text()}`);
  return (await response.json()).access_token;
}

async function signJwt(account: ServiceAccount, claims: Record<string, unknown>) {
  const encode = (value: object) => base64Url(new TextEncoder().encode(JSON.stringify(value)));
  const input = `${encode({ alg: 'RS256', typ: 'JWT' })}.${encode(claims)}`;

  const pem = account.private_key.replace(/-----[^-]+-----|\s/g, '');
  const key = await crypto.subtle.importKey(
    'pkcs8',
    Uint8Array.from(atob(pem), (c) => c.charCodeAt(0)),
    { name: 'RSASSA-PKCS1-v1_5', hash: 'SHA-256' },
    false,
    ['sign'],
  );
  const signature = await crypto.subtle.sign('RSASSA-PKCS1-v1_5', key, new TextEncoder().encode(input));
  return `${input}.${base64Url(new Uint8Array(signature))}`;
}

function base64Url(bytes: Uint8Array): string {
  return btoa(String.fromCharCode(...bytes)).replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
}

function json(body: unknown, status: number): Response {
  return new Response(JSON.stringify(body), {
    status,
    headers: { 'Content-Type': 'application/json' },
  });
}

-- ---------------------------------------------------------------------------
-- NAN-135 — Notification push à la publication d'un nouvel article
--
-- À jouer À LA MAIN dans le SQL editor Supabase, en une fois, sur nanimo-dev
-- d'abord. Avant, créer les deux secrets Vault de la section 5 : sans eux,
-- la tâche planifiée ne peut appeler personne.
--
--   1. push_tokens : un jeton FCM par appareil
--   2. register_push_token : un appareil repris par un autre compte change de
--      propriétaire, ce qu'une policy RLS ne saurait pas faire
--   3. articles.notified_at : garantit l'envoi unique
--   4. claim_due_articles : réserve les articles à envoyer, de façon atomique
--   5. tâche planifiée, toutes les 5 minutes, seulement si un article attend
-- ---------------------------------------------------------------------------

begin;

create extension if not exists pg_cron;
create extension if not exists pg_net;

-- 1. Jetons -----------------------------------------------------------------

create table public.push_tokens (
  token            text primary key,
  user_id          uuid not null references public.users(id_user) on delete cascade,
  platform         text not null check (platform in ('ios', 'android')),
  articles_enabled boolean not null default true,
  updated_at       timestamptz not null default now()
);

create index idx_push_tokens_user_id on public.push_tokens using btree (user_id);
create index idx_push_tokens_articles on public.push_tokens using btree (token) where articles_enabled;

alter table public.push_tokens enable row level security;

create policy "push_tokens_select_own" on public.push_tokens for select
  to authenticated using (user_id = auth.uid());

create policy "push_tokens_delete_own" on public.push_tokens for delete
  to authenticated using (user_id = auth.uid());

revoke all on public.push_tokens from anon, authenticated;
grant select, delete on public.push_tokens to authenticated;
grant all on public.push_tokens to service_role;

-- 2. Enregistrement ---------------------------------------------------------

create or replace function public.register_push_token(
  p_token text, p_platform text, p_articles_enabled boolean
) returns void
  language plpgsql security definer
  set search_path to 'public'
  as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  insert into push_tokens (token, user_id, platform, articles_enabled)
  values (p_token, auth.uid(), p_platform, p_articles_enabled)
  on conflict (token) do update set
    user_id = excluded.user_id,
    platform = excluded.platform,
    articles_enabled = excluded.articles_enabled,
    updated_at = now();
end;
$$;

revoke all on function public.register_push_token(text, text, boolean) from public, anon;
grant execute on function public.register_push_token(text, text, boolean) to authenticated;

-- 3. Suivi d'envoi ----------------------------------------------------------

alter table public.articles add column notified_at timestamptz;

comment on column public.articles.notified_at is
  'Date de réservation de l''envoi push. Non nul = plus jamais envoyé.';

-- Le fonds déjà publié ne part pas : seul un article à venir notifie.
update public.articles set notified_at = now()
where published_at is not null and published_at <= now();

create index idx_articles_due on public.articles using btree (published_at)
  where notified_at is null and published_at is not null;

-- 4. Réservation ------------------------------------------------------------
-- Réserve avant d'envoyer : un échec perd un envoi, il n'en double jamais un.

create or replace function public.claim_due_articles()
  returns table (id_article uuid, title text, paragraphs text[])
  language sql security definer
  set search_path to 'public'
  as $$
  update articles a set notified_at = now()
  where a.id_article in (
    select d.id_article from articles d
    where d.published_at <= now() and d.notified_at is null
    for update skip locked
  )
  returning a.id_article, a.title, a.paragraphs;
$$;

revoke all on function public.claim_due_articles() from public, anon, authenticated;
grant execute on function public.claim_due_articles() to service_role;

-- 5. Tâche planifiée --------------------------------------------------------
-- Secrets Vault à créer avant ce script, valeurs propres à chaque projet :
--   select vault.create_secret('https://<ref>.supabase.co/functions/v1/send-article-push', 'push_function_url');
--   select vault.create_secret('<même valeur que PUSH_CRON_TOKEN>', 'push_cron_token');

select cron.schedule('send-article-push', '*/5 * * * *', $job$
  select net.http_post(
    url := (select decrypted_secret from vault.decrypted_secrets where name = 'push_function_url'),
    headers := jsonb_build_object(
      'Authorization', (select decrypted_secret from vault.decrypted_secrets where name = 'push_cron_token')
    ),
    timeout_milliseconds := 60000
  )
  where exists (
    select 1 from public.articles
    where published_at <= now() and notified_at is null
  );
$job$);

commit;

-- ---------------------------------------------------------------------------
-- Retour arrière :
--
--   select cron.unschedule('send-article-push');
--   drop function public.claim_due_articles(), public.register_push_token(text, text, boolean);
--   drop table public.push_tokens;
--   alter table public.articles drop column notified_at;
-- ---------------------------------------------------------------------------

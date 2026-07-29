-- ---------------------------------------------------------------------------
-- 0007 — Quotas d'abonnement et traçabilité des achats
--
-- Trois objets :
--   1. Aligner le nom de la colonne de stockage sur celui que lit l'app
--   2. Fixer les quotas freemium / premium vendus par le paywall
--   3. Créer la table qui trace les achats validés par le webhook RevenueCat
-- ---------------------------------------------------------------------------

-- 1. La migration 0001 crée `max_storage_mb`, mais le code Dart
--    (SubscriptionConfigModel et SubscriptionConfigCache) lit `max_storage_in_mb`.
--    L'app fonctionne en production, donc la base réelle porte `max_storage_in_mb`
--    et c'est 0001 qui a divergé. On converge vers le nom que lit le code, sans
--    toucher au Dart : renommer dans l'autre sens casserait la prod.
--    Bloc idempotent, sans effet si la colonne porte déjà le bon nom.
do $$
begin
  if exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'subscription_config'
      and column_name = 'max_storage_mb'
  ) and not exists (
    select 1 from information_schema.columns
    where table_schema = 'public'
      and table_name = 'subscription_config'
      and column_name = 'max_storage_in_mb'
  ) then
    alter table subscription_config rename column max_storage_mb to max_storage_in_mb;
  end if;
end $$;

-- 2. Quotas vendus par le paywall.
--    Les lignes existent déjà en production, l'insert n'est là que pour garantir
--    la présence des deux plans sur une base fraîche. Le stockage est
--    volontairement laissé à sa valeur actuelle : seuls les animaux et les
--    images par événement sont arbitrés ici.
insert into subscription_config (plan_name, max_pets, max_images_per_event)
values
  ('freemium', 1, 1),
  ('premium', 10, 5)
on conflict (plan_name) do nothing;

update subscription_config set max_pets = 1,  max_images_per_event = 1 where plan_name = 'freemium';
update subscription_config set max_pets = 10, max_images_per_event = 5 where plan_name = 'premium';

-- 3. Journal des achats.
--    Alimenté uniquement par l'Edge Function `revenuecat-webhook`, qui s'exécute
--    avec la service role key. Aucun accès en écriture depuis le client : c'est
--    la garantie qu'un premium ne peut pas être posé par un simple flag applicatif.
create table if not exists subscription_purchase (
  id_subscription_purchase uuid primary key default uuid_generate_v4(),
  user_id                  uuid not null references users (id_user) on delete cascade,
  event_id                 text not null unique,
  event_type               text not null,
  product_id               text,
  store                    text,
  environment              text,
  purchased_at             timestamptz,
  expires_at               timestamptz,
  raw_event                jsonb not null,
  created_at               timestamptz not null default now()
);

-- `event_id` est l'identifiant d'événement RevenueCat. La contrainte unique rend
-- le webhook idempotent : RevenueCat réémet un événement tant qu'il n'a pas reçu
-- un 2xx, et un même achat ne doit pas être appliqué deux fois.
create index if not exists subscription_purchase_user_idx
  on subscription_purchase (user_id, created_at desc);

alter table subscription_purchase enable row level security;

-- Lecture seule pour le propriétaire, pour un futur écran d'historique.
-- Aucune policy d'insert ni d'update : la service role contourne la RLS, le
-- client n'écrit jamais ici.
drop policy if exists subscription_purchase_select_own on subscription_purchase;
create policy subscription_purchase_select_own
  on subscription_purchase
  for select
  using (auth.uid() = user_id);

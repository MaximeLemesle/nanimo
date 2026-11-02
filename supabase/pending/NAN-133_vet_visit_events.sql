-- ---------------------------------------------------------------------------
-- NAN-133 — La visite vétérinaire devient un événement relié au carnet
--
-- À jouer À LA MAIN dans le SQL editor Supabase, en une fois (transaction),
-- AVANT de publier la v1.3.0. Puis régénérer la baseline (supabase/README.md)
-- et supprimer ce fichier : la baseline redevient la seule description.
--
-- Ce que fait le script :
--   1. event_vet_details : les champs propres à une visite, un seul animal
--   2. event_documents   : les documents d'une visite (10 max, 10 Mo chacun)
--   3. bucket privé health-documents, rangé par visite : {event_id}/{fichier}
--   4. migration des vet_visits existantes en événements (même identifiant)
--   5. vet_visits devient une VUE, avec triggers INSTEAD OF : les v1.2.x
--      continuent de lire, ajouter, modifier et supprimer leurs visites
--   6. app_config.min_supported_version, lu au lancement à partir de la v1.3.0
--
-- Accès partout fondé sur users_pets (l'animal), pas sur l'auteur : le futur
-- foyer n'aura rien à réécrire ici.
--
-- Une visite n'a pas de event_type : elle se reconnaît à sa ligne dans
-- event_vet_details. Un type dédié serait apparu dans le sélecteur de souvenir
-- des v1.2.x, qui chargent tous les types sans filtre.
-- ---------------------------------------------------------------------------

begin;

-- 1. Détails d'une visite ---------------------------------------------------

create table public.event_vet_details (
  event_id    uuid primary key references public.events(id_event) on delete cascade,
  pet_id      uuid not null references public.pets(id_pet) on delete cascade,
  has_time    boolean not null default false,
  reason      text,
  report      text,
  vet_name    text,
  clinic_name text
);

create index idx_event_vet_details_pet_id on public.event_vet_details using btree (pet_id);

alter table public.event_vet_details enable row level security;

create policy "event_vet_details owned via pet" on public.event_vet_details
  to authenticated
  using (exists (
    select 1 from public.users_pets up
    where up.pet_id = event_vet_details.pet_id and up.user_id = auth.uid()))
  with check (exists (
    select 1 from public.users_pets up
    where up.pet_id = event_vet_details.pet_id and up.user_id = auth.uid()));

-- 2. Documents d'une visite -------------------------------------------------

create table public.event_documents (
  id_event_document uuid primary key default gen_random_uuid(),
  event_id          uuid not null references public.event_vet_details(event_id) on delete cascade,
  storage_path      text not null unique,
  file_name         text not null,
  mime_type         text not null check (mime_type in (
                      'image/jpeg', 'image/png', 'image/heic', 'image/webp', 'application/pdf')),
  size_bytes        integer not null check (size_bytes > 0 and size_bytes <= 10485760),
  doc_type          text not null default 'autre' check (doc_type in (
                      'ordonnance', 'facture', 'analyses', 'compte_rendu', 'autre')),
  source            text not null check (source in ('camera', 'gallery', 'file')),
  created_at        timestamptz not null default now()
);

create index idx_event_documents_event_id on public.event_documents using btree (event_id);

alter table public.event_documents enable row level security;

create policy "event_documents owned via pet" on public.event_documents
  to authenticated
  using (exists (
    select 1 from public.event_vet_details d
    join public.users_pets up on up.pet_id = d.pet_id
    where d.event_id = event_documents.event_id and up.user_id = auth.uid()))
  with check (exists (
    select 1 from public.event_vet_details d
    join public.users_pets up on up.pet_id = d.pet_id
    where d.event_id = event_documents.event_id and up.user_id = auth.uid()));

create or replace function public.enforce_max_documents() returns trigger
  language plpgsql
  set search_path to 'public'
  as $$
begin
  if (select count(*) from event_documents where event_id = new.event_id) >= 10 then
    raise exception 'document quota reached (max 10 per visit)'
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

create trigger trg_enforce_max_documents
  before insert on public.event_documents
  for each row execute function public.enforce_max_documents();

-- 3. Bucket privé des documents ---------------------------------------------

insert into storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
values ('health-documents', 'health-documents', false, 10485760,
        array['image/jpeg', 'image/png', 'image/heic', 'image/webp', 'application/pdf'])
on conflict (id) do nothing;

create policy "health-documents owned via pet" on storage.objects
  to authenticated
  using (bucket_id = 'health-documents' and exists (
    select 1 from public.event_vet_details d
    join public.users_pets up on up.pet_id = d.pet_id
    where d.event_id::text = (storage.foldername(name))[1] and up.user_id = auth.uid()))
  with check (bucket_id = 'health-documents' and exists (
    select 1 from public.event_vet_details d
    join public.users_pets up on up.pet_id = d.pet_id
    where d.event_id::text = (storage.foldername(name))[1] and up.user_id = auth.uid()));

-- 4. Migration des visites existantes ---------------------------------------
-- Même identifiant : id_vet_visit devient id_event, les rappels déjà
-- programmés par les apps gardent leur clé.

alter table public.vet_visits rename to vet_visits_legacy;

insert into public.events (id_event, title, entry_date, event_type_id)
select v.id_vet_visit, v.title, (v.visited_at::timestamp) at time zone 'Europe/Paris', null
from public.vet_visits_legacy v
on conflict (id_event) do nothing;

insert into public.pets_events (pet_id, event_id)
select v.pet_id, v.id_vet_visit from public.vet_visits_legacy v
on conflict do nothing;

insert into public.event_vet_details (event_id, pet_id, has_time, vet_name, clinic_name)
select v.id_vet_visit, v.pet_id, false, v.vet_name, v.clinic_name
from public.vet_visits_legacy v
on conflict (event_id) do nothing;

-- Gardée pour un retour arrière, fermée aux clients.
revoke all on public.vet_visits_legacy from anon, authenticated;

-- 5. Vue de compatibilité ---------------------------------------------------
-- Les six premières colonnes sont celles de l'ancienne table, lues par les
-- v1.2.x. Les suivantes ne servent qu'à partir de la v1.3.0.

create view public.vet_visits with (security_invoker = true) as
select
  d.event_id                                         as id_vet_visit,
  e.title                                            as title,
  (e.entry_date at time zone 'Europe/Paris')::date   as visited_at,
  d.vet_name                                         as vet_name,
  d.clinic_name                                      as clinic_name,
  d.pet_id                                           as pet_id,
  e.entry_date                                       as visit_at,
  d.has_time                                         as has_time,
  d.reason                                           as reason,
  d.report                                           as report,
  (select count(*)::int from public.event_documents doc
     where doc.event_id = d.event_id)                as document_count
from public.event_vet_details d
join public.events e on e.id_event = d.event_id;

create or replace function public.vet_visits_write() returns trigger
  language plpgsql security definer
  set search_path to 'public'
  as $$
declare
  v_id   uuid;
  v_at   timestamptz;
  v_time boolean;
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  if tg_op in ('UPDATE', 'DELETE') and not exists (
    select 1 from users_pets where user_id = auth.uid() and pet_id = old.pet_id
  ) then
    raise exception 'not owned' using errcode = '42501';
  end if;

  if tg_op in ('INSERT', 'UPDATE') and not exists (
    select 1 from users_pets where user_id = auth.uid() and pet_id = new.pet_id
  ) then
    raise exception 'not owned' using errcode = '42501';
  end if;

  if tg_op = 'DELETE' then
    delete from events where id_event = old.id_vet_visit;
    return old;
  end if;

  if tg_op = 'INSERT' then
    v_id   := coalesce(new.id_vet_visit, gen_random_uuid());
    v_at   := coalesce(new.visit_at, (new.visited_at::timestamp) at time zone 'Europe/Paris');
    v_time := coalesce(new.has_time, false) and new.visit_at is not null;

    insert into events (id_event, title, entry_date, event_type_id)
    values (v_id, new.title, v_at, null);
    insert into pets_events (pet_id, event_id) values (new.pet_id, v_id);
    insert into event_vet_details (event_id, pet_id, has_time, reason, report, vet_name, clinic_name)
    values (v_id, new.pet_id, v_time, new.reason, new.report, new.vet_name, new.clinic_name);

    new.id_vet_visit := v_id;
    new.visit_at := v_at;
    new.has_time := v_time;
    return new;
  end if;

  -- UPDATE. Une v1.2.x n'envoie que visited_at : une date changée par elle
  -- efface l'heure. Une v1.3.0 envoie visit_at et has_time.
  if new.visit_at is distinct from old.visit_at then
    v_at := new.visit_at;
    v_time := coalesce(new.has_time, false);
  elsif new.visited_at is distinct from old.visited_at then
    v_at := (new.visited_at::timestamp) at time zone 'Europe/Paris';
    v_time := false;
  else
    v_at := old.visit_at;
    v_time := coalesce(new.has_time, old.has_time);
  end if;

  update events set title = new.title, entry_date = v_at
  where id_event = old.id_vet_visit;

  if new.pet_id is distinct from old.pet_id then
    update pets_events set pet_id = new.pet_id
    where event_id = old.id_vet_visit and pet_id = old.pet_id;
  end if;

  update event_vet_details set
    pet_id = new.pet_id,
    has_time = v_time,
    reason = new.reason,
    report = new.report,
    vet_name = new.vet_name,
    clinic_name = new.clinic_name
  where event_id = old.id_vet_visit;

  new.visit_at := v_at;
  new.has_time := v_time;
  return new;
end;
$$;

create trigger trg_vet_visits_write
  instead of insert or update or delete on public.vet_visits
  for each row execute function public.vet_visits_write();

revoke all on public.vet_visits from anon;
grant select, insert, update, delete on public.vet_visits to authenticated;
grant select, insert, update, delete on public.event_vet_details to authenticated;
grant select, insert, update, delete on public.event_documents to authenticated;

-- 6. Version minimale -------------------------------------------------------

create table public.app_config (
  key   text primary key,
  value text not null
);

alter table public.app_config enable row level security;

create policy "app_config readable by all" on public.app_config
  for select to anon, authenticated using (true);

grant select on public.app_config to anon, authenticated;

-- Le minimum reste bas tant que des v1.2.x tournent : la vue les sert.
insert into public.app_config (key, value) values ('min_supported_version', '1.0.0')
on conflict (key) do nothing;

commit;

-- ---------------------------------------------------------------------------
-- Contrôles après exécution (doivent rendre la même valeur deux à deux)
--
--   select count(*) from public.vet_visits_legacy;
--   select count(*) from public.vet_visits;
--
--   select count(*) from public.vet_visits_legacy l
--   join public.events e on e.id_event = l.id_vet_visit;
-- ---------------------------------------------------------------------------
--
-- Retour arrière, uniquement si aucune visite n'a été créée depuis :
--
--   begin;
--   drop view public.vet_visits;
--   delete from public.events where id_event in (select event_id from public.event_vet_details);
--   drop table public.event_documents, public.event_vet_details, public.app_config;
--   drop function public.vet_visits_write(), public.enforce_max_documents();
--   alter table public.vet_visits_legacy rename to vet_visits;
--   grant select, insert, update, delete on public.vet_visits to authenticated;
--   commit;
-- ---------------------------------------------------------------------------

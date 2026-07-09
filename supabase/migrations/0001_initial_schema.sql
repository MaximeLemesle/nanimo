-- Nanimo — initial schema
-- Reflects the data model documented in CLAUDE.md §3. Column names match the
-- `toJson`/`fromJson` mappings used by the Flutter models so the app and the
-- database stay in lockstep.
--
-- This baseline is meant to be reconciled with the live Supabase project via
-- `supabase db diff` (see supabase/README.md) — it is the versioned source of
-- truth, not a throwaway snapshot.

-- ---------------------------------------------------------------------------
-- Extensions
-- ---------------------------------------------------------------------------
create extension if not exists "uuid-ossp";
create extension if not exists moddatetime schema extensions;

-- ---------------------------------------------------------------------------
-- Enums
-- ---------------------------------------------------------------------------
create type gender_enum as enum ('male', 'female', 'unknown');
create type weight_unit_enum as enum ('kg', 'g');
create type subscription_status_enum as enum ('free', 'premium');
create type notification_type_enum as enum (
  'anniversary', 'vaccine', 'vet', 'deworming', 'custom'
);

-- ---------------------------------------------------------------------------
-- Referential (public read, no per-user rows)
-- ---------------------------------------------------------------------------
create table subscription_config (
  id_subscription_config   serial primary key,
  plan_name                text not null,
  max_images_per_event     int  not null default 1,
  max_pets                 int  not null default 1,
  max_storage_mb           int  not null default 500,
  can_access_premium_icons boolean not null default false
);

create table pet_species (
  id_pet_species uuid primary key default uuid_generate_v4(),
  species_name   text not null,
  weight_unit    weight_unit_enum not null default 'kg',
  icon_key       text not null
);

create table pet_race (
  id_pet_race    uuid primary key default uuid_generate_v4(),
  pet_race_name  text not null,
  pet_species_id uuid not null references pet_species (id_pet_species) on delete cascade
);

create table event_type (
  id_event_type uuid primary key default uuid_generate_v4(),
  name          text not null,
  code          text unique,
  is_premium    boolean not null default false
);

create table recommended_vaccines (
  id_recommended_vaccine uuid primary key default uuid_generate_v4(),
  name                   text not null,
  category               text,
  recurrence_days        int,
  pet_species_id         uuid references pet_species (id_pet_species) on delete cascade
);

-- ---------------------------------------------------------------------------
-- Users (a trigger on auth.users provisions the public.users row)
-- ---------------------------------------------------------------------------
create table users (
  id_user                   uuid primary key references auth.users (id) on delete cascade,
  user_name                 text,
  mail                      text unique not null,
  subscription_status       subscription_status_enum not null default 'free',
  subscription_expires_at   timestamptz,
  id_subscription_config    int not null default 1 references subscription_config (id_subscription_config)
);

-- ---------------------------------------------------------------------------
-- Pets and ownership
-- ---------------------------------------------------------------------------
create table pets (
  id_pet         uuid primary key default uuid_generate_v4(),
  pet_name       text not null,
  birthdate      date,
  gender         gender_enum not null default 'unknown',
  created_at     timestamptz not null default now(),
  pet_race_id    uuid references pet_race (id_pet_race) on delete set null,
  pet_species_id uuid references pet_species (id_pet_species) on delete set null,
  pet_icon_id    uuid
);

create table users_pets (
  user_id uuid not null references users (id_user) on delete cascade,
  pet_id  uuid not null references pets (id_pet) on delete cascade,
  primary key (user_id, pet_id)
);

-- ---------------------------------------------------------------------------
-- Events (linked to pets through pets_events, never directly to a user)
-- ---------------------------------------------------------------------------
create table events (
  id_event      uuid primary key default uuid_generate_v4(),
  title         text not null,
  description   text,
  created_at    timestamptz not null default now(),
  entry_date    timestamptz not null,
  event_type_id uuid not null references event_type (id_event_type)
);

create table pets_events (
  pet_id   uuid not null references pets (id_pet) on delete cascade,
  event_id uuid not null references events (id_event) on delete cascade,
  primary key (pet_id, event_id)
);

create table event_image (
  id_event_image uuid primary key default uuid_generate_v4(),
  asset_path     text not null,
  event_id       uuid not null references events (id_event) on delete cascade
);

-- ---------------------------------------------------------------------------
-- Health book
-- ---------------------------------------------------------------------------
create table health_diary (
  id_health_diary     uuid primary key default uuid_generate_v4(),
  is_sterilized       boolean,
  is_chipped          boolean,
  chip_number         text,
  last_deworming_at   date,
  last_vet_appointment date,
  pet_id              uuid not null unique references pets (id_pet) on delete cascade
);

create table health_diary_vaccines (
  id_health_diary_vaccine uuid primary key default uuid_generate_v4(),
  vaccine_name            text not null,
  last_date               date,
  next_date               date,
  recurrence              int,
  dose_number             int,
  total_dose_number       int,
  health_diary_id         uuid not null references health_diary (id_health_diary) on delete cascade
);

create table health_diary_weight_log (
  id_health_diary_weight_log uuid primary key default uuid_generate_v4(),
  weight                     numeric(6, 2) not null,
  logged_at                  timestamptz not null default now(),
  pet_id                     uuid not null references pets (id_pet) on delete cascade
);

create table vet_visits (
  id_vet_visit uuid primary key default uuid_generate_v4(),
  title        text not null,
  visited_at   date not null,
  vet_name     text,
  clinic_name  text,
  pet_id       uuid not null references pets (id_pet) on delete cascade
);

create table notifications (
  id_notification uuid primary key default uuid_generate_v4(),
  type            notification_type_enum not null,
  title           text not null,
  description     text,
  sending_at      timestamptz not null,
  id_pet          uuid references pets (id_pet) on delete cascade
);

-- ---------------------------------------------------------------------------
-- Indexes (hot paths from CLAUDE.md §3)
-- ---------------------------------------------------------------------------
create index idx_events_entry_date on events (entry_date desc);
create index idx_vaccines_next_date on health_diary_vaccines (next_date);
create index idx_notifications_sending_at on notifications (sending_at);
create index idx_weight_log_pet_id on health_diary_weight_log (pet_id);
create index idx_vet_visits_pet_id on vet_visits (pet_id);
create index idx_pets_events_event_id on pets_events (event_id);
create index idx_users_pets_pet_id on users_pets (pet_id);

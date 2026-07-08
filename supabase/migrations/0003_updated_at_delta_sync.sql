-- Nanimo — updated_at columns for delta sync (audit A-6)
-- Each syncable table gets an `updated_at` column kept current by the
-- `moddatetime` trigger, so the client can fetch only rows changed since its
-- last sync instead of re-downloading the whole table.

alter table pets                    add column updated_at timestamptz not null default now();
alter table events                  add column updated_at timestamptz not null default now();
alter table event_image             add column updated_at timestamptz not null default now();
alter table health_diary            add column updated_at timestamptz not null default now();
alter table health_diary_vaccines   add column updated_at timestamptz not null default now();
alter table health_diary_weight_log add column updated_at timestamptz not null default now();
alter table vet_visits              add column updated_at timestamptz not null default now();
alter table users                   add column updated_at timestamptz not null default now();

create trigger set_updated_at_pets
  before update on pets
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_events
  before update on events
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_event_image
  before update on event_image
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_health_diary
  before update on health_diary
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_vaccines
  before update on health_diary_vaccines
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_weight_log
  before update on health_diary_weight_log
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_vet_visits
  before update on vet_visits
  for each row execute procedure extensions.moddatetime (updated_at);
create trigger set_updated_at_users
  before update on users
  for each row execute procedure extensions.moddatetime (updated_at);

create index idx_pets_updated_at on pets (updated_at);
create index idx_events_updated_at on events (updated_at);

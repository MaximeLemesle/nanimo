-- Nanimo — Row Level Security
-- Every user-owned table is reachable only through the `users_pets` ownership
-- join. Referential tables are world-readable but not writable by clients.

-- ---------------------------------------------------------------------------
-- Helper: does the current user own this pet?
-- ---------------------------------------------------------------------------
create or replace function public.owns_pet(target_pet uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from users_pets up
    where up.pet_id = target_pet
      and up.user_id = auth.uid()
  );
$$;

-- ---------------------------------------------------------------------------
-- Enable RLS everywhere
-- ---------------------------------------------------------------------------
alter table users                     enable row level security;
alter table pets                      enable row level security;
alter table users_pets                enable row level security;
alter table events                    enable row level security;
alter table pets_events               enable row level security;
alter table event_image               enable row level security;
alter table health_diary              enable row level security;
alter table health_diary_vaccines     enable row level security;
alter table health_diary_weight_log   enable row level security;
alter table vet_visits                enable row level security;
alter table notifications             enable row level security;
alter table subscription_config       enable row level security;
alter table pet_species               enable row level security;
alter table pet_race                  enable row level security;
alter table event_type                enable row level security;
alter table recommended_vaccines      enable row level security;

-- ---------------------------------------------------------------------------
-- Referential: read-only for any authenticated user
-- ---------------------------------------------------------------------------
create policy referential_read_species on pet_species
  for select to authenticated using (true);
create policy referential_read_race on pet_race
  for select to authenticated using (true);
create policy referential_read_event_type on event_type
  for select to authenticated using (true);
create policy referential_read_vaccines on recommended_vaccines
  for select to authenticated using (true);
create policy referential_read_config on subscription_config
  for select to authenticated using (true);

-- ---------------------------------------------------------------------------
-- Users: a user sees and edits only their own row
-- ---------------------------------------------------------------------------
create policy users_select_self on users
  for select using (id_user = auth.uid());
create policy users_update_self on users
  for update using (id_user = auth.uid());

-- ---------------------------------------------------------------------------
-- Pets and ownership
-- ---------------------------------------------------------------------------
create policy pets_select_owned on pets
  for select using (owns_pet(id_pet));
create policy pets_insert_authenticated on pets
  for insert with check (auth.uid() is not null);
create policy pets_update_owned on pets
  for update using (owns_pet(id_pet));
create policy pets_delete_owned on pets
  for delete using (owns_pet(id_pet));

create policy users_pets_select_self on users_pets
  for select using (user_id = auth.uid());
create policy users_pets_insert_self on users_pets
  for insert with check (user_id = auth.uid());
create policy users_pets_delete_self on users_pets
  for delete using (user_id = auth.uid());

-- ---------------------------------------------------------------------------
-- Events: reachable through pets_events → users_pets
-- ---------------------------------------------------------------------------
create policy events_select_owned on events
  for select using (
    exists (
      select 1 from pets_events pe
      where pe.event_id = events.id_event and owns_pet(pe.pet_id)
    )
  );
create policy events_insert_authenticated on events
  for insert with check (auth.uid() is not null);
create policy events_update_owned on events
  for update using (
    exists (
      select 1 from pets_events pe
      where pe.event_id = events.id_event and owns_pet(pe.pet_id)
    )
  );
create policy events_delete_owned on events
  for delete using (
    exists (
      select 1 from pets_events pe
      where pe.event_id = events.id_event and owns_pet(pe.pet_id)
    )
  );

create policy pets_events_all_owned on pets_events
  for all using (owns_pet(pet_id)) with check (owns_pet(pet_id));

create policy event_image_all_owned on event_image
  for all using (
    exists (
      select 1 from pets_events pe
      where pe.event_id = event_image.event_id and owns_pet(pe.pet_id)
    )
  ) with check (
    exists (
      select 1 from pets_events pe
      where pe.event_id = event_image.event_id and owns_pet(pe.pet_id)
    )
  );

-- ---------------------------------------------------------------------------
-- Health book: owned through pet_id
-- ---------------------------------------------------------------------------
create policy health_diary_all_owned on health_diary
  for all using (owns_pet(pet_id)) with check (owns_pet(pet_id));

create policy vaccines_all_owned on health_diary_vaccines
  for all using (
    exists (
      select 1 from health_diary hd
      where hd.id_health_diary = health_diary_vaccines.health_diary_id
        and owns_pet(hd.pet_id)
    )
  ) with check (
    exists (
      select 1 from health_diary hd
      where hd.id_health_diary = health_diary_vaccines.health_diary_id
        and owns_pet(hd.pet_id)
    )
  );

create policy weight_log_all_owned on health_diary_weight_log
  for all using (owns_pet(pet_id)) with check (owns_pet(pet_id));

create policy vet_visits_all_owned on vet_visits
  for all using (owns_pet(pet_id)) with check (owns_pet(pet_id));

create policy notifications_all_owned on notifications
  for all using (owns_pet(id_pet)) with check (owns_pet(id_pet));

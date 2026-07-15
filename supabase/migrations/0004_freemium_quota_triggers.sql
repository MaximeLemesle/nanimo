-- Nanimo — server-side freemium quotas (audit A-2)
-- The client greys out over-quota actions for UX, but the plan limits are
-- enforced here so they cannot be bypassed by a crafted request.
--
-- Limits are resolved by joining `subscription_config.plan_name` on the user's
-- `subscription_status` — the entitlement itself, and a real FK (see 0001). An
-- earlier revision carried a `users.id_subscription_config` FK alongside the
-- status; the two could drift, silently capping a premium user at the freemium
-- quotas. `allowed` can no longer come back null for an existing user, but the
-- coalesce stays: it fails closed rather than trusting that invariant.

-- ---------------------------------------------------------------------------
-- Resolve the plan limits of the user who owns a pet.
-- ---------------------------------------------------------------------------
create or replace function public.plan_for_pet(target_pet uuid)
returns subscription_config
language sql
security definer
set search_path = public
stable
as $$
  select sc.*
  from users_pets up
  join users u on u.id_user = up.user_id
  join subscription_config sc on sc.plan_name = u.subscription_status
  where up.pet_id = target_pet
  limit 1;
$$;

-- ---------------------------------------------------------------------------
-- Enforce max_pets on the ownership link.
-- ---------------------------------------------------------------------------
create or replace function public.enforce_max_pets()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  current_count int;
  allowed int;
begin
  select count(*) into current_count from users_pets where user_id = new.user_id;
  select sc.max_pets into allowed
  from users u
  join subscription_config sc on sc.plan_name = u.subscription_status
  where u.id_user = new.user_id;

  if current_count >= coalesce(allowed, 0) then
    raise exception 'pet quota reached (max % for this plan)', allowed
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

create trigger trg_enforce_max_pets
  before insert on users_pets
  for each row execute procedure public.enforce_max_pets();

-- ---------------------------------------------------------------------------
-- Enforce max_images_per_event on event_image inserts.
-- ---------------------------------------------------------------------------
create or replace function public.enforce_max_images()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  current_count int;
  allowed int;
begin
  select count(*) into current_count
  from event_image where event_id = new.event_id;

  select min(sc.max_images_per_event) into allowed
  from pets_events pe
  join users_pets up on up.pet_id = pe.pet_id
  join users u on u.id_user = up.user_id
  join subscription_config sc on sc.plan_name = u.subscription_status
  where pe.event_id = new.event_id;

  if current_count >= coalesce(allowed, 0) then
    raise exception 'image quota reached (max % per event for this plan)', allowed
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

create trigger trg_enforce_max_images
  before insert on event_image
  for each row execute procedure public.enforce_max_images();

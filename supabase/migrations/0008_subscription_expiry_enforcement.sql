-- ---------------------------------------------------------------------------
-- 0008 — Faire expirer le premium sur la date, pas seulement sur le webhook
--
-- `users.subscription_expires_at` existe depuis 0001, le webhook RevenueCat
-- l'écrit à chaque octroi et les Paramètres l'affichent. Aucune autorisation
-- ne la lit : les trois résolutions de plan de 0004 joignent
-- `subscription_config` sur `subscription_status` seul.
--
-- Conséquence : `subscription_status` ne repasse à `freemium` que si un
-- événement EXPIRATION, SUBSCRIPTION_PAUSED ou REFUND arrive et aboutit. S'il
-- se perd, la ligne reste `premium` indéfiniment et aucune date ne vient
-- jamais la contredire.
--
-- Ce fichier remplace les trois fonctions de 0004 par la même logique, le
-- statut passant d'abord par `public.effective_plan_name`.
--
-- ⚠️ Ne jamais lancer `supabase db push` sur ce projet : la base live n'a pas
-- d'historique de migrations, un push rejouerait 0001 et échouerait sur
-- `create type gender_enum`. À appliquer à la main dans le SQL editor.
-- ---------------------------------------------------------------------------

-- ---------------------------------------------------------------------------
-- Le plan réellement en vigueur pour un utilisateur.
--
-- Le `is not null` n'est pas décoratif : sans lui, tout utilisateur premium
-- sans date d'expiration basculerait en freemium. Le webhook renseigne bien la
-- date sur les octrois, mais une correction manuelle en base ne le fera pas, et
-- un abonnement à vie ne doit pas être révoqué par effet de bord.
--
-- Un utilisateur freemium n'est jamais affecté, quelle que soit la date.
-- ---------------------------------------------------------------------------
create or replace function public.effective_plan_name(
  status subscription_status_enum,
  expires_at timestamptz
)
returns subscription_status_enum
language sql
stable
as $$
  select case
    when status = 'premium'
     and expires_at is not null
     and expires_at < now()
    then 'freemium'::subscription_status_enum
    else status
  end;
$$;

-- ---------------------------------------------------------------------------
-- Résoudre les limites du plan du propriétaire d'un animal.
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
  join subscription_config sc
    on sc.plan_name = public.effective_plan_name(
         u.subscription_status, u.subscription_expires_at)
  where up.pet_id = target_pet
  limit 1;
$$;

-- ---------------------------------------------------------------------------
-- Quota d'animaux.
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
  join subscription_config sc
    on sc.plan_name = public.effective_plan_name(
         u.subscription_status, u.subscription_expires_at)
  where u.id_user = new.user_id;

  if current_count >= coalesce(allowed, 0) then
    raise exception 'pet quota reached (max % for this plan)', allowed
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

-- ---------------------------------------------------------------------------
-- Quota d'images par souvenir.
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
  join subscription_config sc
    on sc.plan_name = public.effective_plan_name(
         u.subscription_status, u.subscription_expires_at)
  where pe.event_id = new.event_id;

  if current_count >= coalesce(allowed, 0) then
    raise exception 'image quota reached (max % per event for this plan)', allowed
      using errcode = 'check_violation';
  end if;
  return new;
end;
$$;

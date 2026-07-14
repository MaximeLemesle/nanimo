-- ---------------------------------------------------------------------------
-- 0006 — RPC delete_account (NAN-030)
--
-- ⚠️ La base live est la source de vérité : exécuter ce script manuellement
-- dans le SQL editor Supabase (jamais de `supabase db push`), après avoir
-- vérifié que les noms de colonnes correspondent au schéma live.
--
-- Supprime définitivement le compte de l'utilisateur appelant :
--   1. les events liés à ses animaux (les events n'ont pas de FK user directe,
--      le lien passe par pets_events → users_pets)
--   2. ses animaux (users_pets, pets_events, health_diary, vet_visits,
--      weight_log… suivent par ON DELETE CASCADE)
--   3. sa ligne public.users
--   4. sa ligne auth.users — invalide toutes les sessions
--
-- Note : les fichiers Storage (journal-media, documents) ne sont pas effacés
-- ici ; prévoir un nettoyage par edge function ou tâche d'admin (V2).
-- ---------------------------------------------------------------------------

create or replace function public.delete_account()
returns void
language plpgsql
security definer
set search_path = public
as $$
begin
  if auth.uid() is null then
    raise exception 'not authenticated';
  end if;

  delete from public.events
  where id_event in (
    select pe.event_id
    from public.pets_events pe
    join public.users_pets up on up.pet_id = pe.pet_id
    where up.user_id = auth.uid()
  );

  delete from public.pets
  where id_pet in (
    select pet_id from public.users_pets where user_id = auth.uid()
  );

  delete from public.users where id_user = auth.uid();

  delete from auth.users where id = auth.uid();
end;
$$;

revoke execute on function public.delete_account() from anon, public;
grant execute on function public.delete_account() to authenticated;

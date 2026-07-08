-- Nanimo — transactional event creation (audit A-3)
-- Creating an event and linking it to its pets in a single round-trip removes
-- the non-atomic client sequence that could leave an orphan event or a
-- duplicate on retry. The client uploads photos to Storage first, then calls
-- this RPC, then inserts event_image rows (each idempotent on its PK).

create or replace function public.create_event(
  p_event_id      uuid,
  p_title         text,
  p_description   text,
  p_entry_date    timestamptz,
  p_event_type_id uuid,
  p_pet_ids       uuid[]
)
returns void
language plpgsql
security invoker
set search_path = public
as $$
begin
  -- Idempotent: a retry with the same id is a no-op instead of a duplicate.
  insert into events (id_event, title, description, entry_date, event_type_id)
  values (p_event_id, p_title, p_description, p_entry_date, p_event_type_id)
  on conflict (id_event) do nothing;

  insert into pets_events (event_id, pet_id)
  select p_event_id, unnest(p_pet_ids)
  on conflict (pet_id, event_id) do nothing;
end;
$$;

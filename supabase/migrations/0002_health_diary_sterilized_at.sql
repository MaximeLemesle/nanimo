-- NAN-116: the guided diary asks when the pet was neutered.
-- To run by hand in the Supabase SQL editor, never with `supabase db push`.
alter table public.health_diary add column if not exists sterilized_at date;

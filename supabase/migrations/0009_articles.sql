-- ---------------------------------------------------------------------------
-- 0009 — Les conseils de la page d'accueil
--
-- La carte s'intitule « Le conseil de la semaine » et n'a jamais porté qu'un
-- seul article, écrit en dur dans le widget. Cette table lui donne de quoi
-- tourner sans nouvelle version de l'application.
--
-- Une seule colonne décide de tout : `published_at`. Elle porte à la fois le
-- droit de publier et la rotation, sans planificateur ni tâche de fond.
--
--   NULL          brouillon, jamais envoyé à un appareil
--   date future   programmé, devient courant tout seul le jour venu
--   date passée   la plus récente s'affiche, les autres sont des archives
--
-- ⚠️ Ne jamais lancer `supabase db push` sur ce projet : la base live n'a pas
-- d'historique de migrations. À appliquer à la main dans le SQL editor.
-- ---------------------------------------------------------------------------

create table public.articles (
  id_article   uuid primary key default gen_random_uuid(),
  title        text        not null,
  paragraphs   text[]      not null,
  published_at timestamptz,
  created_at   timestamptz not null default now(),
  updated_at   timestamptz not null default now()
);

comment on column public.articles.published_at is
  'Null = brouillon. Date future = programmé. L''article affiché est celui dont la date publiée est la plus récente et déjà passée.';

create index articles_published_at_idx
  on public.articles (published_at desc)
  where published_at is not null;

alter table public.articles enable row level security;

-- Lecture seule, et seulement ce qui est publié.
--
-- Le filtre vit ici et pas dans le Dart : filtrer côté client reviendrait à
-- distribuer les brouillons dans le cache de tout le monde et à compter sur
-- l'interface pour les cacher, ce qui est exactement le défaut corrigé par
-- NAN-074.
create policy articles_select_published
  on public.articles
  for select
  to authenticated
  using (published_at is not null and published_at <= now());

-- Aucune policy d'insertion, de modification ou de suppression : l'application
-- ne fait que lire. Les articles s'écrivent depuis le tableau de bord Supabase.

create or replace function public.set_updated_at()
returns trigger language plpgsql as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger articles_set_updated_at
  before update on public.articles
  for each row execute function public.set_updated_at();

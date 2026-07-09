# Supabase — schéma versionné

Ce dossier versionne le schéma PostgreSQL, les policies RLS, les triggers et les
fonctions RPC de Nanimo. Jusqu'ici tout cela ne vivait que dans la console
Supabase (hors Git) — impossible à reviewer, reproduire ou faire évoluer de
façon tracée (audit **A-11**).

## Contenu

| Migration | Rôle |
| --- | --- |
| `0001_initial_schema.sql` | Tables, enums, index (modèle de CLAUDE.md §3) |
| `0002_row_level_security.sql` | RLS : accès via la jointure `users_pets` |
| `0003_updated_at_delta_sync.sql` | Colonnes `updated_at` + `moddatetime` (delta sync, A-6) |
| `0004_freemium_quota_triggers.sql` | Quotas serveur `max_pets` / `max_images_per_event` (A-2) |
| `0005_create_event_rpc.sql` | RPC transactionnelle `create_event` (A-3) |

## Appliquer

```bash
# Une seule fois : lier le projet distant
supabase link --project-ref <ref>

# Réconcilier ces migrations avec la base existante
supabase db diff          # inspecter l'écart
supabase db push          # appliquer les migrations versionnées
```

> **Note** : ces fichiers reflètent le modèle documenté et les mappings
> `toJson`/`fromJson` des modèles Flutter. Sur un projet déjà en production,
> partez d'un `supabase db diff` pour générer une migration de réconciliation
> plutôt que de rejouer `0001` tel quel.

## Prochaines étapes (référencées dans l'audit)

- Brancher `create_event` dans `EventRepository.createEvent` (`supabase.rpc('create_event', …)`) une fois la fonction déployée.
- Implémenter le delta sync côté client sur `updated_at` (aujourd'hui : full-table).
- Ajouter des tests RLS (pgTAP ou intégration sur `supabase start`).

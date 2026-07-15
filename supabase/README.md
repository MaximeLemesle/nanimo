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
| `0003_updated_at_delta_sync.sql` | Colonnes `updated_at` + `moddatetime` (delta sync, A-6) — *pas encore lu côté client, sync full-table* |
| `0004_freemium_quota_triggers.sql` | Quotas serveur `max_pets` / `max_images_per_event` (A-2), résolus par `plan_name` = `subscription_status` |
| `0005_create_event_rpc.sql` | RPC transactionnelle `create_event` (A-3) — *pas encore branchée dans `EventRepository`* |
| `0006_delete_account_rpc.sql` | RPC `delete_account` (security definer), utilisée par la page Paramètres |

## Appliquer

**La base live est la source de vérité, pas ce dossier.** Ces fichiers décrivent
l'état voulu du schéma ; ils ne sont pas rejoués comme un historique et
`supabase db push` n'est jamais lancé sur live. Un changement de schéma se fait à
la main dans le SQL editor Supabase, puis se reflète ici dans le fichier concerné.

```bash
supabase link --project-ref <ref>   # une seule fois
supabase db diff                    # inspecter l'écart entre live et ce dossier
```

> **Note** : l'écart est réel et connu (`0001` décrit `id_subscription_config` en
> `serial` là où live est en `uuid`, `max_storage_mb` vs `max_storage_in_mb`…).
> Avant de faire foi d'un fichier, vérifie la colonne sur live.

## Prochaines étapes (référencées dans l'audit)

- Brancher `create_event` dans `EventRepository.createEvent` (`supabase.rpc('create_event', …)`) une fois la fonction déployée.
- Implémenter le delta sync côté client sur `updated_at` (aujourd'hui : full-table).
- Ajouter des tests RLS (pgTAP ou intégration sur `supabase start`).

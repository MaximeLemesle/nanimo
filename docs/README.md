# Bilan du projet Nanimo — points forts & axes de progression

> Synthèse de l'audit du 2026-07-01, orientée pratiques de développement. Pour le détail technique (schémas d'architecture, flux entre services, constats A-1 → A-13), voir [AUDIT.md](./AUDIT.md).
>
> **État : les 13 constats de l'audit (A-1 → A-13) ont été traités** sur la branche, un commit par point, tests au vert. Le détail de chaque résolution — et ce qui reste pour la V2 — est dans [AUDIT.md §6-7](./AUDIT.md). Les axes ci-dessous décrivent donc les *bonnes pratiques à pérenniser* plutôt que des correctifs à faire.

---

## ✅ Points forts

Ces pratiques sont solides — les garder telles quelles et les défendre quand le projet grossira.

### 1. Discipline architecturale
L'architecture feature-first est appliquée **sans exception** : chaque feature suit `data/ → presentation/cubit/ → presentation/page|widgets/`, aucune page n'appelle Supabase directement, les cubits ne parlent qu'aux repositories. Sur ~140 fichiers, zéro entorse — c'est rare, y compris en équipe.

### 2. Culture de test réelle
81,8 % de couverture avec un seuil bloquant en CI, et surtout les **trois étages** (unitaires, widgets, flux) sont réellement présents, avec des helpers réutilisables bien conçus (`IsarTestHarness`, `FakePostgrestChain`). Les tests miroir de l'arborescence rendent la navigation triviale.

### 3. Outillage et conventions
Convention de commit vérifiée par un hook **partagé entre local et CI** (`scripts/commit-msg-lint.sh` appelé par les deux) — c'est le bon pattern : une seule source de vérité pour une règle. CI en 3 jobs clairs, `analyze --fatal-infos` (strict), concurrency group pour annuler les runs obsolètes.

### 4. Documentation vivante
`CLAUDE.md` comme doc de référence et `CONTEXT.md` comme glossaire du domaine (avec les anti-termes à éviter !) sont d'excellents réflexes de dev solo : ils rendent le projet reprenable par quelqu'un d'autre — ou par soi-même dans 6 mois.

### 5. Bons choix ponctuels de conception
- Stratégie « pending pet » (onboarding avant signup) proprement isolée, avec retry.
- Helpers freemium **fail-closed** (pas de config → pas de droit).
- SSO natif avec nonce SHA-256 (conforme aux recommandations Supabase).
- Insert idempotent (`_insertIgnoringDuplicate`, code 23505) et retry avec backoff dans `PetRepository` — le bon réflexe, à généraliser.

---

## 🔧 Points à améliorer, et comment les traiter

Classés par impact sur la fiabilité du produit. Les références A-x renvoient à [AUDIT.md](./AUDIT.md).

### 1. Gestion des erreurs : ne jamais avaler une exception (A-4)

**Le problème.** Deux réflexes présents partout dans le code :
- `catch (_) {}` silencieux (les 9 méthodes de `SyncService`) ;
- tout transformer en « Une connexion internet est requise » dans les repositories, qu'il s'agisse d'un refus RLS, d'une contrainte violée ou d'un vrai problème réseau.

En production, un bug devient invisible et indiagnosticable — d'autant qu'il n'y a aucun crash reporting.

**La solution.**
1. Créer un mapper commun : `RepositoryException.fromError(e)` qui distingue `SocketException`/`TimeoutException` (réseau) de `PostgrestException`/`StorageException` (serveur/permission) et garde le message d'origine en cause.
2. Règle d'or à s'imposer : **un `catch` doit toujours faire au moins une chose** — logger, remonter un état, ou rethrow. `dart:developer log()` suffit pour commencer.
3. Intégrer Sentry (`sentry_flutter`) avant toute mise en production : c'est ~30 lignes dans `main.dart` et ça transforme chaque crash silencieux en ticket actionnable.

### 2. Penser « cycle de vie » pour les cubits et les streams (A-8)

**Le problème.** `HomeCubit`, `PetDetailsCubit`, `OnboardingCubit`, `PetCreationCubit` sont créés dans `main()` et vivent toute la durée de l'app — leurs subscriptions Isar tournent même sur l'écran de login, et leurs states gardent les données de l'utilisateur précédent après logout. `_AuthCubitListenable` ouvre un `listen()` jamais annulé.

**La solution.**
1. Règle simple : **un cubit vit là où vit son écran**. Seuls `AuthCubit` et `SubscriptionCubit` méritent le root ; scoper `HomeCubit`/`PetDetailsCubit` au `ShellRoute` (créés au login, fermés au logout), comme c'est déjà bien fait pour `JournalCubit` et `EventCreationCubit`.
2. Pour chaque `.listen(...)`, écrire le `cancel()` correspondant **dans le même commit** — stocker la subscription et l'annuler dans `dispose()`/`close()`.

### 3. Écritures multi-étapes : penser atomicité et idempotence (A-3)

**Le problème.** Créer un souvenir = 4 écritures distantes séquentielles (`events` → `pets_events` → upload Storage → `event_image`). Un échec au milieu laisse un event orphelin, et le retry régénère un UUID → doublon.

**La solution.**
1. Réflexe à acquérir : dès qu'une action métier = plusieurs écritures, **la transaction doit vivre côté serveur**. Créer une fonction RPC Postgres `create_event(event, pet_ids)` appelée en un seul `supabase.rpc()`.
2. Uploader les fichiers **avant** de créer les lignes (un fichier orphelin dans Storage est bénin ; une ligne orpheline en base ne l'est pas).
3. Générer les IDs une seule fois et les conserver dans le state pour qu'un retry soit idempotent — le pattern `_insertIgnoringDuplicate` de `PetRepository` existe déjà, le généraliser.

### 4. Le serveur doit être la barrière, pas le client (A-2, A-11)

**Le problème.** Les quotas freemium ne sont appliqués nulle part (ni client, ni — a priori — serveur), et tout ce qui fait la sécurité du projet (RLS, triggers, schéma) vit uniquement dans la console Supabase, hors Git.

**La solution.**
1. Adopter le CLI Supabase : `supabase init` puis `supabase db diff` pour versionner `supabase/migrations/`. À partir de là, chaque évolution de schéma/RLS passe par une PR reviewable, et l'environnement est reproductible.
2. Appliquer les quotas en base (trigger `BEFORE INSERT` sur `pets` et `event_image` qui compare au plan de l'utilisateur) — le client ne fait que l'UX (griser + upsell via les helpers `canCreatePet`/`canAddImageToEvent` qui existent déjà).
3. Ajouter des tests RLS (pgTAP ou tests d'intégration sur `supabase start` local) : c'est le seul moyen de prouver que l'utilisateur A ne voit pas les données de B.

### 5. Offline-first : aller au bout de la promesse (A-5, A-6)

**Le problème.** Les événements sont bien servis depuis le cache, mais le **référentiel** (espèces, races, types) est toujours fetché en réseau → le journal affiche une erreur hors-ligne alors que ses données sont là. Et la sync re-télécharge toutes les tables à chaque login, uniquement au login.

**La solution.**
1. Cacher le référentiel dans Isar (3 petites collections, données quasi statiques) et le rafraîchir dans la vague 2 de `SyncService` — le pattern existe déjà pour les autres tables, c'est un copier-adapter.
2. Passer au delta sync : colonne `updated_at` (trigger `moddatetime`) + `select().gt('updated_at', lastSyncedAt)`, avec soft-delete pour propager les suppressions.
3. Re-synchroniser sur `AppLifecycleState.resumed` et offrir un pull-to-refresh — aujourd'hui un souvenir créé sur un autre appareil n'apparaît qu'au redémarrage.
4. Au passage : ajouter le `try/catch` manquant dans `HomeCubit._loadSpecies` (seul appel réseau non protégé du projet, déclenché avant même le login).

### 6. Cohérence doc ↔ code (A-10, A-12)

**Le problème.** `CLAUDE.md` promet du FCM (aucune dépendance Firebase), une feature `settings/` (absente), une table `weight_logs` (le code utilise `health_diary_weight_log`). Le `README.md` racine est encore le boilerplate Flutter, et aucun `.env.example` n'existe — un clone frais ne build pas.

**La solution.**
1. S'imposer la règle : **une feature retirée ou renommée = la doc mise à jour dans la même PR** (c'est le même réflexe que le hook de commit — automatisable en checklist de PR).
2. Committer un `.env.example` documenté (clés attendues, où les obtenir) et remplacer le README racine par les vraies instructions de setup (le contenu de CLAUDE.md §8 est déjà prêt).
3. Ce qui est aspirationnel (FCM, PDF, calendrier) doit vivre dans des tickets NAN, pas dans la section « stack » du doc de référence.

### 7. Petites dettes à traiter au fil de l'eau (A-9, A-13)

| Point | Solution |
| --- | --- |
| `watchEvents()` utilise `titleIsNotEmpty()` comme « pas de filtre » → un event sans titre disparaît | `_isar.eventCaches.where().sortByEntryDateDesc()` |
| Dates : mélange `DateTime.now()` local / `.toUtc()` selon les endroits | Convention unique : stocker et comparer en UTC, convertir en local à l'affichage |
| Messages UX en français dans la couche data | Les remonter en presentation (préparer l'i18n même si V1 = FR) |
| `pet_details_cubit.dart` : 378 lignes, 5 subscriptions | Scinder en `PetDetailsCubit` + `HealthDiaryCubit` |
| Lints par défaut uniquement | Activer `unawaited_futures`, `always_use_package_imports`, `prefer_final_locals` |
| Matching des erreurs Supabase par chaîne exacte anglaise | Utiliser `AuthException.code` quand disponible |
| CI : pas de build APK/AAB, versions d'actions incohérentes | Job `flutter build` sur tag + Dependabot pour actions et pubspec |

---

## 📌 Par où commencer

1. **Erreurs + Sentry** (§1) — une journée, et tout le reste devient diagnosticable.
2. **Migrations Supabase versionnées** (§4.1) — prérequis de tout le travail serveur.
3. **Quotas côté base** (§4.2) — le business model devient réel.
4. **RPC transactionnelle pour les événements** (§3) — la fiabilité du flux cœur.
5. **Référentiel en cache + delta sync** (§5) — la promesse offline tenue, et la base du multi-device.

Le reste (§2, §6, §7) se traite au fil de l'eau, un item par PR.

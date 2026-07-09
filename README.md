# Nanimo

Journal émotionnel mobile pour propriétaires d'animaux : souvenirs du quotidien,
événements marquants et suivi de santé de chaque animal. **Flutter + Supabase +
Isar** (offline-first pour les lectures). Voir [`CLAUDE.md`](CLAUDE.md) pour
l'architecture détaillée et [`docs/AUDIT.md`](docs/AUDIT.md) pour l'audit technique.

## Prérequis

- Flutter `3.41.9` (voir [`.fvmrc`](.fvmrc))
- Un projet Supabase (URL + clé anon) et les identifiants OAuth Google/Apple

## Configuration

Les secrets sont lus depuis un fichier `.env` (gitignoré) chargé au démarrage.
Copiez le modèle et remplissez les valeurs :

```bash
cp .env.example .env
```

| Clé | Rôle |
| --- | --- |
| `SUPABASE_URL` / `SUPABASE_ANON_KEY` | Connexion Supabase (publiques par design) |
| `GOOGLE_IOS_CLIENT_ID` / `GOOGLE_WEB_CLIENT_ID` | SSO Google natif |
| `APPLE_SERVICE_ID` | SSO Apple |

> Ne mettez que des valeurs **publiques** dans `.env` : il est embarqué dans les
> assets et donc présent en clair dans l'app livrée.

## Lancer l'app

```bash
flutter pub get
dart run build_runner build --delete-conflicting-outputs   # schémas Isar
git config core.hooksPath .githooks                         # hook commit-msg (une fois)
flutter run
```

## Tests

```bash
flutter test                    # toute la suite
flutter test <chemin_du_test>   # un fichier
```

> Les tests Isar téléchargent `libisar` au premier lancement.

## Base de données

Le schéma PostgreSQL, les policies RLS, les triggers de quotas et la RPC
`create_event` sont versionnés dans [`supabase/migrations/`](supabase/README.md).

## Convention de commit

Tous les messages de commit doivent respecter le format :

```
<type>(<scope>): <description> NAN-<id>
```

**Exemple** : `feat(subscription): add subscription cubit NAN-008`

| Champ         | Règle                                                                                          |
| ------------- | ---------------------------------------------------------------------------------------------- |
| `type`        | `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`   |
| `scope`       | kebab-case (lettres minuscules, chiffres et `-`), ex : `subscription-config`                   |
| `description` | libre, en anglais ou français                                                                  |
| `NAN-<id>`    | identifiant du ticket en suffixe, ex : `NAN-008` — obligatoire                            |

Les commits auto-générés `Merge pull request …` et `Revert "…"` sont acceptés sans validation.

### Activer le hook local

Une seule fois après avoir cloné le repo :

```bash
git config core.hooksPath .githooks
```

À partir de là, `git commit` refusera tout message non conforme. La logique est dans `scripts/commit-msg-lint.sh` et est partagée avec la CI.

## CI — critères de validation

Deux workflows GitHub Actions tournent sur chaque PR vers `main` (et `ci.yml` aussi sur chaque push de branche) :

### `ci.yml` — Analyze & Test

Sur Flutter `3.41.9` (Ubuntu) :

1. `flutter pub get`
2. `dart run build_runner build --delete-conflicting-outputs` (régénère les schémas Isar)
3. `flutter analyze --fatal-infos` — échoue sur **toute** info, warning ou error
4. `flutter test` — tous les tests doivent passer

### `commitlint.yml` — Validation des commits de la PR

Pour chaque commit entre `origin/<base>` et `HEAD`, le script `scripts/commit-msg-lint.sh` est lancé. Un seul commit non conforme fait échouer le job.

Une PR ne peut être mergée que si **les deux** workflows sont au vert.

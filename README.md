# nanimo

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

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

# CLAUDE.md — Nanimo

**Nanimo** est un journal émotionnel mobile permettant aux propriétaires d'animaux de documenter leur vie partagée. L'app centralise les moments du quotidien, les événements marquants et le suivi de santé de chaque animal.

**Tagline**: "Chaque moment compte"  
**Marché**: France (V1)  
**Modèle**: Freemium + Premium  
**Stack**: Flutter 3.x + Supabase 2.x + Isar 3.x _(notifications push Firebase FCM prévues en V2 — non implémentées)_

---

## 1. Features Clés

### Core (MVP)

- **Onboarding** : Création du premier animal en 3 étapes avant signup (prénom + espèce, genre + race + date de naissance, avatar automatique) — le pet est inséré après la création du compte
- **Home** : Salutation personalisée, widget "il y a 1 an", alertes santé, dernier souvenir
- **Journal** : 2 vues (timeline + calendrier), filtres (animal + type)
- **Pet Page** : Switch multi-animaux, identité, poids, santé, vaccins, CTA carnet
- **Carnet de santé** : Récapitulatif complet, vaccins, visites véto, graphique poids, export PDF (premium)
- **Freemium** : Quotas (1 animaux free, 1 photo/souvenir, 500 Mo storage)

---

## 2. Architecture (Feature-first)

```
lib/
├── main.dart
├── config/
│   ├── router/
│   └── theme/
│       └── app_theme.dart
├── core/
│   ├── errors/          # RepositoryException + mapRepositoryError (typed errors)
│   ├── isar/            # schémas de cache + IsarService + SyncService
│   ├── utils/
│   └── widgets/
├── data/                # repositories transverses (référentiel)
└─── features/
    ├── auth/
    │   ├── data/
    │   │   ├── auth_repository.dart
    │   │   └── models/
    │   └── presentation/
    │       ├── cubit/
    │       ├── page/
    │       └── widgets/
    ├── onboarding/
    │   └── presentation/
    │       ├── cubit/
    │       └── page/     # splash_page.dart + onboarding_page.dart
    ├── home/
    │   └── presentation/ # profile_page.dart y vit (accès à recâbler, cf. §6)
    ├── event/            # création de souvenir (EventCreationCubit)
    ├── journal/          # timeline + filtres (JournalCubit)
    ├── health/           # data/ uniquement (piloté par pet/PetDetailsCubit)
    ├── pet/
    └── subscription/     # SubscriptionCubit + quotas freemium
```

> Pas de feature `settings/` à ce jour. Les notifications (FCM) sont prévues en V2.

**Pattern** : Cubit pour états simples, repositories = source de vérité
**Navigation** : Go Router avec deep linking + redirection auth conditionnelle  
**State** : Cubit → repositories uniquement, pages = affichage seulement

---

## 3. Modèle de Données

### Tables principales (PostgreSQL 15 + RLS)

| Table                   | Colonnes clés                                                                                                                                | Notes                            |
| ----------------------- | -------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `users`                 | id_user (UUID PK), user_name, mail (unique), subscription_status, subscription_expires_at, id_subscription_config FK                         | Auth Supabase                    |
| `pets`                  | id_pet (UUID PK), pet_name, birthdate (DATE), gender (enum), created_at, pet_race_id FK, pet_species_id FK, pet_icon_id FK                   | RLS: user_id                     |
| `events`                | id_event (UUID PK), title, description, created_at, entry_date (TIMESTAMPTZ), event_type_id FK                                                      | Aucun lien direct pet/user — passe par `pets_events`. RLS via `pets_events → users_pets` |
| `pets_events`           | pet_id FK, event_id FK (jointure M:N)                                                                                                        | Un event ↔ plusieurs animaux, un animal ↔ plusieurs events |
| `event_type`            | id_event_type (UUID PK), name, code (UNIQUE: balade/calin/anniversaire), is_premium                                                          | `code` pilote le style visuel app |
| `event_image`           | id_event_image (UUID PK), asset_path (Storage path), event_id FK                                                                             | Une ou plusieurs images. RLS via l'event lié |
| `health_diary`          | id_health_diary (UUID PK), is_sterilized, is_chipped, chip_number, last_deworming_at, last_vet_appointment, pet_id FK (UNIQUE 1:1)           | Lié au pet                       |
| `health_diary_vaccines` | id_health_diary_vaccine (UUID PK), vaccine_name, last_date, next_date, recurrence (days), dose_number, total_dose_number, health_diary_id FK | Historique vaccins               |
| `health_diary_weight_log` | id_health_diary_weight_log (UUID PK), weight (DECIMAL), logged_at (TIMESTAMPTZ), pet_id FK                                                 | Graphique 6 mois                 |
| `vet_visits`            | id_vet_visit (UUID PK), title, visited_at (DATE), vet_name, clinic_name, pet_id FK (CASCADE)                                                 | Timeline visites véto (carnet)   |
| `notifications`         | id_notification (UUID PK), type (enum), title, description, sending_at (TIMESTAMPTZ), id_pet FK                                              | Push Firebase FCM _(table prête, feature V2)_ |
| `subscription_config`   | id_subscription_config (SERIAL PK), plan_name, max_images_per_event, max_pets, max_storage_mb, can_access_premium_icons                      | Quotas freemium                  |

### ENUMs

- `gender_enum` : male, female, unknown
- `weight_unit_enum` : kg, g
- `subscription_status_enum` : free, premium
- `notification_type_enum` : anniversary, vaccine, vet, deworming, custom

### Règles critiques

- RLS activé sur toutes les tables
- ON DELETE CASCADE pour FK liées à pets
- Indexes sur : entry_date, next_date, sending_at, pet_id
- Buckets Storage : `pet-avatars` (public), `journal-media` (privé), `documents` (privé)
- **Schéma versionné** dans `supabase/migrations/` (tables, RLS, triggers de quotas, RPC `create_event`) — cf. `supabase/README.md`

---

## 4. Design System

### Couleurs

| Rôle               | Hex     | Usage      |
| ------------------ | ------- | ---------- |
| Primary            | #2D8B83 | Accents    |
| Secondary          | #FFB1C1 |            |
| Tertiary           | #FFD966 |            |
| Text primary       | #1A1C1C | Corps      |
| Text secondary     | #909190 | Labels     |
| Text invert        | #FDFCFB | On primary |
| Background         | #FDFCFB |            |
| Background surface | #FFFFFF |            |
| Background invert  | #1A1C1C |            |
| Background stroke  | #E3E2E1 |            |

### Typographie

- **Titres** : Gluten
- **Corps** : Geologica
- **Numbers** : Comfortaa

---

## 5. Stack Technique

### Frontend

- **Flutter 3.x** : iOS + Android
- **Cubit** : State management (flutter_bloc ^9.1.1)
- **Go Router ^14.x** : Navigation + deep linking

### Backend

- **Supabase 2.x** : Auth (SSO Apple/Google + email), PostgreSQL 15, RLS
- **Supabase Storage** : 3 buckets (avatars, journal-media, documents)
- **Firebase Cloud Messaging V2** : Notifications push

### Cache & Offline

- **Isar 3.x** : Cache local NoSQL
- **Stratégie** : Sync Isar ↔ Supabase au démarrage + fallback offline

### Dépendances clés

```yaml
flutter_bloc: ^9.1.1
go_router: ^17.2.3
supabase_flutter: ^2.12.4
isar: ^3.1.0
isar_flutter_libs: ^3.1.0
cached_network_image: ^3.3.1
image_picker: ^1.1.2
google_sign_in: ^7.2.0
sign_in_with_apple: ^8.0.0
crypto: ^3.0.7
flutter_confetti: ^0.5.1
uuid: ^4.5.1
fl_chart: ^0.69.2
```

### Auth SSO (Google + Apple)

- **Flow** : natif via `google_sign_in` / `sign_in_with_apple` → on récupère un `idToken`, puis `supabase.auth.signInWithIdToken()`. Pas de navigateur in-app.
- **Apple** : nonce SHA-256 généré côté client (`generateRawNonce` + `crypto.sha256`) — capability "Sign in with Apple" activée dans `ios/Runner/Runner.entitlements`. Bouton officiel `SignInWithAppleButton` du package.
- **Google** : Client IDs (iOS, Web) lus depuis `.env` (`GOOGLE_IOS_CLIENT_ID`, `GOOGLE_WEB_CLIENT_ID`) et injectés dans `AuthRepository` au boot via `main.dart`. URL scheme inversée Google déclarée dans `ios/Runner/Info.plist`.
- **Plateformes** : Apple visible uniquement sur iOS (`SsoButtonsWidget`), Google sur iOS et Android.
- **Création user** : un trigger SQL existant sur `auth.users` insère la ligne `public.users` quel que soit le provider — aucun code Dart supplémentaire.

---

## 6. Pages & Flows

### Onboarding → Home

```
Splash → Welcome → Create Pet (3 étapes) → Auth → Home
```

**Create Pet steps** (route `/onboarding/create-pet`, `PageView` non-swipable) :

1. Prénom + Espèce (grille filtrée depuis `pet_species`)
2. Genre + race (grille filtrée par species depuis `pet_race`) + date de naissance
3. Écran de succès : confetti + aperçu de l'avatar **automatique de l'espèce** + "Créer mon compte"

**Pending Pet Strategy** — la table `pets` exige un user authentifié (RLS) et le lien passe par `users_pets`. Le pet ne peut donc pas être inséré pendant l'onboarding. Implémentation (`PetCreationCubit`, fourni au root à côté d'`AuthCubit`) :

- Au tap "Créer mon compte", `CreatePetPage` construit le `PetModel` et le stocke comme `pendingPet`.
- Sur un échec post-signup, le `pendingPet` reste en mémoire et un message pour retry s'affiche.

### Home

- Widget "Il y a 1 an" si souvenir existe
- Alertes santé (badges couleur)
- Dernier souvenir
- Switch rapide entre animaux

### Journal

**Timeline** : fil chronologique invers, photos polaroid, titre bold, date, description  
**Calendrier** : mois avec dots, tap jour → panel bas montrant événements

**Implémentation (NAN-018)** — feature `lib/features/journal/`, route `/home/journal` (2ᵉ onglet de la navbar).

> Navbar (`AppShell`) : `Accueil / Journal / Animal / Créer (+)`. Le bouton `+` **push** `/home/create-event` (pas un onglet). La page Profil (`/home/profile`, déconnexion) n'est plus dans la navbar — accès à recâbler.

- `JournalCubit` : offline-first, écoute 3 streams Isar (`watchEvents`, `watchPetEvents`, `watchAllImages`) + charge pets/types/`iconsKey`.
- Lien `pets_events` : cache Isar `PetEventCache` (clé `"$petId|$eventId"`), pour les pastilles d'animaux et le filtre animal.
- Images : bucket `journal-media` privé → `EventRepository.signedImageUrl()` (URL signée 1h).
- Filtres (NAN-015) : multi-sélection animaux **et/ou** types via bottom sheet, toggle live sur le cubit (`togglePetFilter`/`toggleTypeFilter`/`clearFilters`), appliqués par `JournalState.filteredEvents` (OR intra-groupe, AND inter-groupes).
- `JournalFilterBarWidget` : chips des filtres actifs (scroll horizontal, tap = retire) à gauche, chip d'ouverture de la sheet à droite. UI à base de `ChipWidget` (core, réutilisable).
- Détail événement (NAN-032) : tap sur une carte timeline → `JournalEventDetailBottomSheetWidget.show()` (réutilise le `JournalCubit` ambiant via `BlocProvider.value`). Affiche photos (scroll horizontal, URL signées), titre, date, description, animaux (chips) + actions **Modifier**/**Supprimer**. Suppression câblée (`JournalCubit.deleteEvent` → `EventRepository.deleteEvent`, confirmation `AlertDialog`, la sheet se ferme sur succès et un snackbar remonte l'erreur réseau). **Modifier** = simple hook `onEdit` (placeholder snackbar) ; le vrai flux d'édition est un ticket séparé.
- Calendrier : onglet désactivé (v2).

### Créer souvenir

- Date + heure tappables
- Titre grand
- Photos en collage polaroid aléatoire
- Description optionnelle
- Si date future → le souvenir devient un rappel sans photo (v2)

### Pet Page

- Parc illustré (maison, arbres) + avatars des animaux cliquables
- Identité (espèce, race, genre, poids) en grille 2x2
- Poids : dropdown "6 mois", graphique, bouton "Ajouter +"
- Santé : stérilisé, pucé, prochain vermifuge, prochain véto
- Alerte saisonnière dynamique
- Vaccins à venir (badges couleur)
- CTA "Voir le carnet de santé"

### Carnet de santé

- Récapitulatif : toutes infos identité
- Vaccins : liste + dates + badges
- Visites véto : timeline
- Graphique poids : min/max/actuel
- Export PDF (premium, grisé en free)

---

## 7. Freemium

| Feature         | Free   | Premium |
| --------------- | ------ | ------- |
| Animaux         | 1 max  | 10 max  |
| Photos/souvenir | 1      | 5       |
| Stockage        | 500 Mo | 5000    |
| Icônes premium  | Non    | Oui     |
| Export PDF      | Non    | Oui     |

**Gestion quotas** : via `subscription_config` en base — UPDATE suffit, code inchangé

**Runtime** :

- `SubscriptionCubit` global (au root, à côté de `AuthCubit`) charge la config de l'user au login, en parallèle de `_syncUser` / `_syncPets` dans `SyncService.syncCritical`.
- Cache Isar (`SubscriptionConfigCache`) → offline-first : la dernière config connue est servie même sans réseau.
- Helpers sémantiques sur `SubscriptionState` (`canCreatePet`, `canAddImageToEvent`, `canAccessPremiumIcons`, `canUseStorage`) ; **fail-closed** si la config est absente.
- Upgrade détecté via `AuthRepository.watchCurrentUser()` : un changement de `subscriptionConfigId` déclenche un refresh forcé depuis Supabase.

---

## 8. Running the App

```bash
# Clone + setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Activer les hooks git versionnés (une seule fois après clone)
git config core.hooksPath .githooks

# Lancer
flutter run
```

**Convention de commit** : `<type>(<scope>): <description> NAN-<id>` (ex : `feat(subscription): add cubit NAN-008`). Types autorisés : `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`, `perf`, `ci`, `build`, `revert`. Le hook `commit-msg` bloque les messages non conformes en local ; la CI le revérifie sur chaque PR.

## 9. Tests

```bash
# Tous les tests
flutter test

# Un fichier spécifique
flutter test test/core/isar/cache/schemas/pet_cache_test.dart
```

> **Note** : les tests Isar téléchargent automatiquement `libisar.dylib` au premier lancement (`Isar.initializeIsarCore(download: true)`).

### 9.1 Couverture de tests

Étant le seul dev sur le projet, j'ai concentré les tests sur la logique métier, les repositories, et les principaux flux utilisateur.

### 9.2 Les 3 types de tests

- **Les tests unitaires** pour les modèles et la logique métier.
- **Les tests de widgets** pour maintenir le design de l'app.
- **Les tests end to end** pour assurer la protection des flux critiques.

### 9.3 Structure des fichiers

Miroir à l'architecture du projet.

```
test/
├── core/
└── features/
    └── pet/
        ├── data/
        │   └── pet_repository_test.dart
        └── presentation/
            ├── cubit/
            │   └── pet_creation_cubit_test.dart
            └── widgets/
                └── pet_card_test.dart
```

### 9.4 CI GitHub Actions

Workflow `.github/workflows/ci.yml` découpé en 3 jobs :

- **`analyze`** : analyse les erreurs de linter
- **`test`** : check que tout les tests passent
- **`coverage`** : vérifie que le coverage est au minimum à 80%

---

## 10. Conventions de Code

- **Nommage** : camelCase pour variables/fonctions, PascalCase pour classes/enums
- **Fichiers** : snake_case (auth_cubit.dart, pet_model.dart)
- **Cubits** : `[feature]_cubit.dart` + `[feature]_state.dart`
- **Pages** : `[feature]_page.dart`
- **Commentaires** : Une ligne courte en anglais pour chaque méthode publique avec /// pour différencier des balises flutter
- **Erreurs** : Toujours wrap Supabase calls en try/catch
- **Mounted** : Toujours vérifier `if (!mounted) return;` après await avant setState

---

## 11. Ressources

- **Supabase docs** : https://supabase.com/docs
- **Flutter best practices** : https://flutter.dev/docs

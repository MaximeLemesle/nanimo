# CLAUDE.md — Nanimo

**Nanimo** est un journal émotionnel mobile permettant aux propriétaires d'animaux de documenter leur vie partagée. L'app centralise les moments du quotidien, les événements marquants et le suivi de santé de chaque animal.

**Tagline**: "Chaque moment compte"  
**Marché**: France (V1)  
**Modèle**: Freemium + Premium  
**Stack**: Flutter 3.x + Supabase 2.x + Isar 3.x Firebase FCM

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
│   ├── errors/          # RepositoryException + mapRepositoryError : traduit les codes Postgres/Storage en messages clairs
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
    ├── event/            # création de souvenir (EventCreationCubit)
    ├── journal/          # timeline + filtres (JournalCubit)
    ├── health/           # data/ uniquement (piloté par pet/PetDetailsCubit)
    ├── pet/
    ├── settings/         # page Paramètres (SettingsCubit, prefs notifications locales, cf. §6)
    └── subscription/     # SubscriptionCubit + quotas freemium
```

> Les notifications push (FCM) restent prévues en V2 — seules les **préférences** existent déjà (feature `settings/`, stockage local Isar).

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
| `subscription_config`   | id_subscription_config (UUID PK), plan_name, max_images_per_event, max_pets, max_storage_in_mb                                               | Quotas freemium. Icônes premium = `is_premium` (event_type/pet_icons) croisé au `subscription_status` de l'user, pas une colonne de config |

### ENUMs

- `gender_enum` : male, female, unknown
- `weight_unit_enum` : kg, g
- `subscription_status_enum` : freemium, premium
- `notification_type_enum` : anniversary, vaccine, vet, deworming, custom

### Règles critiques

- RLS activé sur toutes les tables
- ON DELETE CASCADE pour FK liées à pets
- Indexes sur : entry_date, next_date, sending_at, pet_id
- Buckets Storage : `pet-avatars` (public), `journal-media` (privé), `documents` (privé)
- **Schéma versionné** dans `supabase/migrations/` (tables, RLS, triggers de quotas, RPC `create_event`, RPC `delete_account`) — cf. `supabase/README.md`

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
- **Prénom (user_name)** : le signup email collecte un champ user_name. `AuthRepository.register` l'envoie en metadata `signUp` (`data: {'user_name': …}`) **et** fait un UPDATE `users.user_name` post-signup (policy RLS `users_update_self`) + refresh du cache Isar — best-effort, n'échoue jamais le signup. Affiché par le header de la home via `watchCurrentUser()` ; `HomeCubit` ignore les noms vides (comptes créés avant ce champ).

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

**Implémentation (NAN-022)** — design « Gazette » (le parc illustré reste la signature de la Pet Page, la home a la sienne : la une d'un album souvenir).

- **Header gazette** (`HomeHeaderWidget`) centré : date du jour (`DateFormatter.weekdayDayMonth`) + « Gazette de {prénom} » en Gluten — prénom via `AuthRepository.watchCurrentUser()` (fallback « Votre gazette »).
- **Polaroïd héros « Il y a X ans »** (`HomeMemoryPolaroidWidget`) : souvenir survenu le même jour/mois une année précédente (`HomeState.anniversaryEvent`), fallback dernier souvenir (flag « Dernier souvenir »). Photo = 1ʳᵉ image de l'event, URL signée memoizée 45 min (`HomeCubit.imageUrl`, même pattern que le Journal). Tap → ouvre directement `JournalEventDetailBottomSheetWidget` sur l'event (avec Modifier/Supprimer câblés).
- **Strip d'animaux** (`HomePetListWidget`) : rangée horizontale scrollable d'avatars (`PetAvatarWidget` medium) + prénom sous chacun. Tap → sélection du pet (`PetDetailsCubit` partagé) + push pet page.
- **Carte Santé** (rose) : vaccins en retard ou dus sous 30 j (`HomeState.vaccineAlerts`, tri par urgence), badge `VaccineStatusBadgeWidget` réutilisé ; variante verte « Tout est à jour ! » sinon. Tap sur une ligne → sélection du pet + push carnet de santé.
- **Carte article canicule** (`HomeArticleCardWidget`, jaune) : teaser (kicker + titre + extrait + « Lire la suite ») d'un article de conseils, contenu **en dur** dans le fichier (pas de backend blog en V1). Tap → article complet dans une bottom sheet à 80 % de l'écran (`FractionallySizedBox`), bouton retour épinglé en haut, corps scrollable.
- **`RoundedBorderWidget`** (`core/widgets/`) : shell squircle commun à toutes les cartes de l'app — `ShapeDecoration` + `ContinuousRectangleBorder(AppRadius.lg * 2)`, fond/bordure/padding configurables, `fullWidth`, `onTap` optionnel (InkWell). Utilisé par les cartes home (Santé, article), les cartes Pet Page (`PetCardWidget`, `PetDiaryCardWidget`, `PetWeightCardWidget`), `GridTileWidget` (création) et `VaccineStatusBadgeWidget`. Les shapes `AppRadius.md * 2` (boutons, clip photo du journal) restent hors périmètre.
- **`HomeCubit`** : offline-first, écoute 6 streams Isar (pets, events, pets_events, images, diaries, vaccins) + le user courant. Les helpers dérivés du state prennent un `now` injectable pour les tests.
- La logique de statut vaccin (`VaccineStatus`/`vaccineStatusFor`) vit dans `core/utils/vaccine_status.dart` (ré-exportée par `vaccine_status_badge_widget.dart` pour compat) ; `HealthRepository.watchAllDiaries()`/`watchAllVaccines()` fournissent les streams globaux pour mapper vaccin → pet.

### Journal

**Timeline** : fil chronologique invers, photos polaroid, titre bold, date, description  
**Calendrier** : mois avec dots, tap jour → panel bas montrant événements

**Implémentation (NAN-018)** — feature `lib/features/journal/`, route `/home/journal` (2ᵉ onglet de la navbar).

> Navbar (`AppShell`, NAN-034) : pilule flottante blanche à 3 onglets (Accueil / Journal / Animal, icône sélectionnée dans un cercle blanc ombré) + bouton `+` rond sombre à droite. Le `+` ouvre/ferme un **menu de création** (panneau squircle sombre au-dessus de la barre, `AppCreateMenuWidget`) avec 3 actions : « Ajouter un nouveau poids » (bottom sheet `AddWeightBottomSheetWidget`, avec **sélecteur d'animal** (`PetPickerWidget.single`, cf. §4) ; affiché seulement si `pets.length > 1`, pré-coché sur le pet sélectionné du `PetDetailsCubit` ; `addWeightLog(weight, loggedAt, {petId})` cible ce pet **sans déplacer la sélection globale**, pour ne pas faire basculer la Pet Page dans le dos de l'user. Le sélecteur est opt-in via le paramètre `pets` : la Pet Page et le carnet ne le passent pas, l'animal y étant le sujet de la page), « Ajouter un évènement » (push `/home/create-event`) et « Ajouter un animal » (reset `OnboardingCubit` + push `/onboarding/create-pet` en mode in-app, quota freemium vérifié via `SubscriptionCubit.canCreatePet` avant navigation). Tap hors du menu = fermeture (scrim transparent), le `+` pivote en croix. Widgets dans `core/widgets/app_bottom_bar_widget.dart` / `app_create_menu_widget.dart`. **CreatePetPage est bi-mode** : onboarding (pending pet, bouton « Créer mon compte » → signup) ou in-app si authentifié (`PetCreationCubit.prepare` crée immédiatement, bouton « Créer » → retour page animal, erreurs via le snackbar retry du shell) ; la route `create-pet` n'est plus dans les routes publiques du guard pour rester accessible connecté. L'ancienne page Profil a été remplacée par la page Paramètres (`/home/settings`, NAN-030) — accès via la roue crantée en haut à droite du header de la home.

> **`PetDetailsCubit` est fourni en `lazy: false`** (`app_router.dart`). `BlocProvider` est lazy par défaut : or aucune page ne lit ce cubit au premier rendu (la home n'y touche que dans les callbacks `onPetTap`), donc il naissait au tap du menu `+` avec `pets: []` — quota freemium contourné (`canCreatePet(0)` = `true`) et sélecteur d'animal de la sheet poids jamais affiché. `HomeCubit`/`JournalCubit` n'ont pas le souci, leurs pages les lisent au montage.

- `JournalCubit` : offline-first, écoute 3 streams Isar (`watchEvents`, `watchPetEvents`, `watchAllImages`) + charge pets/types/`iconsKey`. Fourni au niveau du `ShellRoute` (à côté de `HomeCubit`/`PetDetailsCubit`) pour que la home puisse ouvrir la sheet de détail — les filtres survivent donc aux allers-retours de navigation.
- Lien `pets_events` : cache Isar `PetEventCache` (clé `"$petId|$eventId"`), pour les pastilles d'animaux et le filtre animal.
- Images : bucket `journal-media` privé → `EventRepository.signedImageUrl()` (URL signée 1h).
- Filtres (NAN-015) : multi-sélection animaux **et/ou** types via bottom sheet, toggle live sur le cubit (`togglePetFilter`/`toggleTypeFilter`/`clearFilters`), appliqués par `JournalState.filteredEvents` (OR intra-groupe, AND inter-groupes).
- `JournalFilterBarWidget` : chips des filtres actifs (scroll horizontal, tap = retire) à gauche, chip d'ouverture de la sheet à droite. UI à base de `ChipWidget` (core, réutilisable).
- Détail événement (NAN-032) : tap sur une carte timeline → `JournalEventDetailBottomSheetWidget.show()` (réutilise le `JournalCubit` ambiant via `BlocProvider.value`). Affiche photos (scroll horizontal, URL signées), titre, date, description, animaux (chips) + actions **Modifier**/**Supprimer**. Suppression câblée (`JournalCubit.deleteEvent` → `EventRepository.deleteEvent`, confirmation `AlertDialog`, la sheet se ferme sur succès et un snackbar remonte l'erreur réseau). **Modifier** ferme la sheet et push `/home/edit-event/:eventId` (NAN-033).
- Édition de souvenir (NAN-033) : route `/home/edit-event/:eventId`, `EditEventCubit` scopé route (créé par le `BlocProvider` du GoRoute, `load()` au push). Formulaire pré-rempli, photos gérées via bottom sheets (grille, ajout/remplacement/suppression — quota photos du plan appliqué comme en création), `EventRepository.updateEvent`/`updateEventPets` + upload/suppression d'images. URLs signées mémoïsées (TTL 45 min) + `cacheKey` stable sur les `CachedNetworkImage`.
- Calendrier (NAN-016) : vue mois avec dots sur les jours à événements, switch timeline/calendrier (`JournalSwitchViewWidget`), mois courant affiché en bas au premier rendu, chargement par blocs de 6 mois sans remonter avant le premier événement. Tap sur un jour → `JournalDayEventsBottomSheetWidget` → détail événement. État vide partagé `JournalEmptyStateWidget`.

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

### Paramètres (NAN-030)

Feature `lib/features/settings/`, route `/home/settings` (push depuis la roue crantée du header de la home, `HomeHeaderWidget.onSettingsTap`). Remplace l'ancienne `ProfilePage`.

- **`SettingsCubit`** scopé route (créé dans le `BlocProvider` du GoRoute, `load()` au push) : écoute `AuthRepository.watchCurrentUser()` + `SettingsRepository.watchNotificationPrefs()`.
- **Mon compte** : tuiles `SettingsTileWidget` (shell `RoundedBorderWidget` blanc + stroke, icône + label + valeur + trailing). Prénom éditable via bottom sheet (`SettingsEditNameBottomSheetWidget` → `AuthRepository.updateUserName`, méthode publique désormais partagée avec le post-signup `_saveUserName`). Email en lecture seule.
- **Abonnement** : lecture seule depuis le `UserModel` (badge Freemium/Premium + « Jusqu'au JJ/MM/AAAA » si premium). Pas de flow de paiement en V1.
- **Notifications** : master switch + 4 toggles (vaccins, visites véto, vermifuges, anniversaires — alignés sur `notification_type_enum`). **Stockage local uniquement** (`NotificationPrefsCache` Isar, une ligne par user, effacé au sign-out comme les autres caches) ; le câblage FCM (V2) lira ces flags.
- **Déconnexion** : `AuthCubit.logout()` — la redirection passe par le redirect du router.
- **Suppression de compte** : `AlertDialog` de confirmation → `AuthRepository.deleteAccount()` → RPC Supabase `delete_account` (security definer : events → pets → public.users → auth.users, cf. `supabase/migrations/0006_delete_account_rpc.sql` — **à exécuter manuellement sur la base live**, les fichiers Storage ne sont pas nettoyés en V1). Le signOut post-RPC ignore les erreurs (session déjà invalidée côté serveur).
- **Footer** : logo texte + tagline + version (constante `_appVersion` à garder synchro avec `pubspec.yaml`).

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
- Helpers sémantiques sur `SubscriptionState` (`canCreatePet`, `canAddImageToEvent`, `canUseStorage`) ; **fail-closed** si la config est absente. L'accès aux icônes premium ne passe plus par la config (cf. §3 : `is_premium` croisé au `subscription_status` de l'user).
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
- **Commentaires** : Uniquement sur les fonctions qui en ont vraiment besoin — logique non évidente, contrainte invisible dans le code, workaround. Ne pas commenter une méthode dont le nom suffit. Format : une ligne courte en anglais avec /// pour différencier des balises flutter
- **Erreurs** : Toujours wrap Supabase calls en try/catch
- **Mounted** : Toujours vérifier `if (!mounted) return;` après await avant setState

---

## 11. Ressources

- **Supabase docs** : https://supabase.com/docs
- **Flutter best practices** : https://flutter.dev/docs

# CLAUDE.md — Nanimo

**Nanimo** est un journal émotionnel mobile permettant aux propriétaires d'animaux de documenter leur vie partagée. L'app centralise les moments du quotidien, les événements marquants et le suivi de santé de chaque animal.

**Tagline**: "Chaque moment compte"  
**Marché**: France (V1)  
**Modèle**: Freemium + Premium  
**Stack**: Flutter 3.x + Supabase 2.x + Isar 3.x + Firebase FCM  

---

## 1. Features Clés

### Core (MVP)
- **Onboarding** : Création du premier animal en 3 étapes (prénom + espèce, genre + race + date de naissance, avatar automatique)
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
│   └── widgets/
│   ├── errors/
│   └── utils/
└─── features/
    ├── auth/
    │   ├── data/
    │   │   └── auth_repository.dart
    │   └── presentation/
    │       ├── cubit/
    │       │   ├── auth_cubit.dart
    │       │   └── auth_state.dart
    │       ├── page/
    │       │   └── login_page.dart
    │       └── widgets/
    │           └── login_button_widget.dart
    ├── home/
    │   ├── data/
    │   └── presentation/
    ├── health/
    ├── journal/
    ├── onboarding/
    ├── pet/
    └── settings/
```

**Pattern** : Cubit pour états simples, repositories = source de vérité
**Navigation** : Go Router avec deep linking + redirection auth conditionnelle  
**State** : Cubit → repositories uniquement, pages = affichage seulement

---

## 3. Modèle de Données

### Tables principales (PostgreSQL 15 + RLS)

| Table | Colonnes clés | Notes |
|-------|---|---|
| `users` | id_user (UUID PK), user_name, mail (unique), subscription_status, subscription_expires_at, id_subscription_config FK | Auth Supabase |
| `pets` | id_pet (UUID PK), pet_name, birthdate (DATE), gender (enum), created_at, pet_race_id FK, pet_species_id FK, pet_icon_id FK | RLS: user_id |
| `events` | id_event (UUID PK), title, description, created_at, entry_date (DATE), event_type_id FK | Photos peut être future (rappel) |
| `event_image` | id_event_image (UUID PK), asset_path (Storage path), event_id FK | Une ou plusieurs images |
| `health_diary` | id_health_diary (UUID PK), is_sterilized, is_chipped, chip_number, last_deworming_at, last_vet_appointment, pet_id FK (UNIQUE 1:1) | Lié au pet |
| `health_diary_vaccines` | id_health_diary_vaccine (UUID PK), vaccine_name, last_date, next_date, recurrence (days), dose_number, total_dose_number, health_diary_id FK | Historique vaccins |
| `weight_logs` | id_health_diary_weight_log (UUID PK), weight (DECIMAL), logged_at (TIMESTAMPTZ), pet_id FK | Graphique 6 mois |
| `notifications` | id_notification (UUID PK), type (enum), title, description, sending_at (TIMESTAMPTZ), id_pet FK | Push Firebase FCM |
| `subscription_config` | id_subscription_config (SERIAL PK), plan_name, max_images_per_event, max_pets, max_storage_mb, can_access_premium_icons | Quotas freemium |

### ENUMs
- `gender_enum` : male, female, unknown
- `weight_unit_enum` : kg, g
- `subscription_status_enum` : free, premium
- `notification_type_enum` : anniversary, vaccine, vet, deworming, custom

### Règles critiques
- RLS activé sur toutes les tables
- ON DELETE CASCADE pour FK liées à pets
- Indexes sur : entry_date, next_date, sending_at, pet_id
- Buckets Storage : `pet-avatars` (public), `journal-media` (public), `documents` (privé)

---

## 4. Design System

### Couleurs
| Rôle | Hex | Usage |
|---|---|---|
| Primary | #2D8B83 | Accents |
| Secondary | #FFB1C1 |  |
| Tertiary | #FFD966 |  |
| Text primary | #1A1C1C | Corps |
| Text secondary | #909190 | Labels |
| Text invert | #FDFCFB | On primary |
| Background | #FDFCFB |  |
| Background surface | #FFFFFF |  |
| Background invert | #1A1C1C |  |
| Background stroke | #E3E2E1 |  |

### Typographie
- **Titres** : Gluten
- **Corps** : Geologica
- **Numbers** : Comfortaa

---

## 5. Stack Technique

### Frontend
- **Flutter 3.x** : iOS + Android
- **Cubit** : State management (flutter_bloc ^8.1.6)
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
flutter_bloc: ^9.1.0
go_router: ^17.2.0
supabase_flutter: ^2.12.0
isar: ^3.1.0
isar_flutter_libs: ^3.1.0
cached_network_image: ^3.3.1
image_picker: ^1.1.2
```

---

## 6. Pages & Flows

### Onboarding → Home
```
Splash → Welcome → Create Pet (3 étapes) → Auth → Home
```

**Create Pet steps** :
1. Prénom + Espèce (grille 6 icônes)
2. Genre + race + date naissance
3. Avatar (automatique) + validation

### Home
- Widget "Il y a 1 an" si souvenir existe
- Alertes santé (badges couleur)
- Dernier souvenir
- Switch rapide entre animaux

### Journal
**Timeline** : fil chronologique invers, photos polaroid, titre bold, date, description  
**Calendrier** : mois avec dots, tap jour → panel bas montrant événements

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

| Feature | Free | Premium |
|---|---|---|
| Animaux | 1 max | 10 max |
| Photos/souvenir | 1 | 5 |
| Stockage | 500 Mo | 5000 |
| Icônes premium | Non | Oui |
| Export PDF | Non | Oui |

**Gestion quotas** : via `subscription_config` en base — UPDATE suffit, code inchangé

---

## 8. Running the App

```bash
# Clone + setup
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs

# Lancer
flutter run
```

## 9. Tests

```bash
# Tous les tests
flutter test

# Un fichier spécifique
flutter test test/core/isar/cache/schemas/pet_cache_test.dart
```

> **Note** : les tests Isar téléchargent automatiquement `libisar.dylib` au premier lancement (`Isar.initializeIsarCore(download: true)`).

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
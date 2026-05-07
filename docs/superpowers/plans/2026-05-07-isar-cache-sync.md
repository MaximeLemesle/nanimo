# Isar Cache & Sync Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Initialiser Isar 3.x, créer les schémas de cache pour les 7 entités principales, et implémenter la logique de sync Supabase → Isar au démarrage (vague critique bloquante + vague secondaire en arrière-plan).

**Architecture:** `IsarService` est un singleton initialisé dans `main()` avant `runApp()`. `SyncService` orchestre deux vagues : critique (user + pets, bloquante) déclenchée dans `AuthCubit._listenToAuthChanges()` avant d'émettre `authenticated`, et secondaire (events, health, weights, fire-and-forget). Chaque schéma inclut un `factory fromJson()` pour mapper le JSON Supabase vers l'objet cache.

**Tech Stack:** Flutter 3.x, Isar 3.1.0, isar_flutter_libs 3.1.0, isar_generator 3.1.0, build_runner 2.4.0, path_provider 2.1.0, supabase_flutter 2.x, flutter_test

---

## Fichiers créés / modifiés

| Fichier | Action |
|---|---|
| `pubspec.yaml` | Modifié — ajout isar, isar_flutter_libs, path_provider, isar_generator, build_runner |
| `lib/core/isar/cache/schemas/user_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/pet_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/event_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/event_image_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/health_diary_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/health_diary_vaccine_cache.dart` | Créé |
| `lib/core/isar/cache/schemas/weight_log_cache.dart` | Créé |
| `lib/core/isar/database/isar_service.dart` | Créé |
| `lib/core/isar/database/sync_service.dart` | Créé |
| `lib/main.dart` | Modifié — ajout `IsarService.initialize()` |
| `lib/features/auth/presentation/cubit/auth_cubit.dart` | Modifié — injection `SyncService`, appel sync sur session active |
| `test/core/isar/cache/schemas/user_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/pet_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/event_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/event_image_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/health_diary_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/health_diary_vaccine_cache_test.dart` | Créé |
| `test/core/isar/cache/schemas/weight_log_cache_test.dart` | Créé |
| `test/core/isar/database/isar_service_test.dart` | Créé |

---

## Task 1 : Ajouter les dépendances Isar

**Files:**
- Modify: `pubspec.yaml`

- [ ] **Step 1 : Ajouter les dépendances dans pubspec.yaml**

Dans la section `dependencies`, ajouter après `flutter_dotenv`:
```yaml
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  path_provider: ^2.1.0
```

Dans la section `dev_dependencies`, ajouter après `flutter_lints`:
```yaml
  isar_generator: ^3.1.0
  build_runner: ^2.4.0
```

- [ ] **Step 2 : Installer les dépendances**

```bash
flutter pub get
```

Expected: résolution sans erreur, `pubspec.lock` mis à jour.

- [ ] **Step 3 : Commit**

```bash
git add pubspec.yaml pubspec.lock
git commit -m "feat(isar): add isar, isar_flutter_libs, path_provider dependencies"
```

---

## Task 2 : Schéma UserCache

**Files:**
- Create: `lib/core/isar/cache/schemas/user_cache.dart`
- Create: `test/core/isar/cache/schemas/user_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/user_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';

void main() {
  group('UserCache.fromJson', () {
    test('maps all non-null fields correctly', () {
      final json = {
        'id_user': 'abc-123',
        'user_name': 'Alice',
        'mail': 'alice@example.com',
        'subscription_status': 'free',
        'subscription_expires_at': '2026-12-31T00:00:00.000Z',
      };

      final cache = UserCache.fromJson(json);

      expect(cache.idUser, 'abc-123');
      expect(cache.userName, 'Alice');
      expect(cache.mail, 'alice@example.com');
      expect(cache.subscriptionStatus, 'free');
      expect(cache.subscriptionExpiresAt, DateTime.parse('2026-12-31T00:00:00.000Z'));
    });

    test('handles null optional fields', () {
      final json = {
        'id_user': 'abc-123',
        'user_name': null,
        'mail': 'alice@example.com',
        'subscription_status': 'free',
        'subscription_expires_at': null,
      };

      final cache = UserCache.fromJson(json);

      expect(cache.userName, isNull);
      expect(cache.subscriptionExpiresAt, isNull);
    });
  });
}
```

- [ ] **Step 2 : Lancer le test — vérifier qu'il échoue**

```bash
flutter test test/core/isar/cache/schemas/user_cache_test.dart
```

Expected: erreur de compilation (`user_cache.dart` n'existe pas).

- [ ] **Step 3 : Créer le schéma UserCache**

Créer `lib/core/isar/cache/schemas/user_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'user_cache.g.dart';

@Collection()
class UserCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idUser;

  String? userName;
  late String mail;
  late String subscriptionStatus;
  DateTime? subscriptionExpiresAt;

  /// Maps a Supabase [json] row to a [UserCache] instance
  factory UserCache.fromJson(Map<String, dynamic> json) {
    final cache = UserCache();
    cache.idUser = json['id_user'] as String;
    cache.userName = json['user_name'] as String?;
    cache.mail = json['mail'] as String;
    cache.subscriptionStatus = json['subscription_status'] as String;
    cache.subscriptionExpiresAt = json['subscription_expires_at'] != null
        ? DateTime.parse(json['subscription_expires_at'] as String)
        : null;
    return cache;
  }
}
```

Note: le fichier `user_cache.g.dart` sera généré à la Task 9. Le test sera relancé à ce moment.

- [ ] **Step 4 : Commit**

```bash
git add lib/core/isar/cache/schemas/user_cache.dart test/core/isar/cache/schemas/user_cache_test.dart
git commit -m "feat(isar): add UserCache schema with fromJson"
```

---

## Task 3 : Schéma PetCache

**Files:**
- Create: `lib/core/isar/cache/schemas/pet_cache.dart`
- Create: `test/core/isar/cache/schemas/pet_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/pet_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';

void main() {
  group('PetCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_pet': 'pet-uuid',
        'pet_name': 'Buddy',
        'birthdate': '2020-03-15',
        'gender': 'male',
        'id_race': 'race-uuid',
        'id_species': 'species-uuid',
        'id_icon': 'icon-uuid',
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.idPet, 'pet-uuid');
      expect(cache.petName, 'Buddy');
      expect(cache.birthdate, DateTime.parse('2020-03-15'));
      expect(cache.gender, 'male');
      expect(cache.idRace, 'race-uuid');
      expect(cache.idSpecies, 'species-uuid');
      expect(cache.idIcon, 'icon-uuid');
      expect(cache.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
    });

    test('handles null optional fields', () {
      final json = {
        'id_pet': 'pet-uuid',
        'pet_name': 'Mimi',
        'birthdate': null,
        'gender': 'unknown',
        'id_race': null,
        'id_species': null,
        'id_icon': null,
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.birthdate, isNull);
      expect(cache.idRace, isNull);
      expect(cache.idSpecies, isNull);
      expect(cache.idIcon, isNull);
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma PetCache**

Créer `lib/core/isar/cache/schemas/pet_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'pet_cache.g.dart';

@Collection()
class PetCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idPet;

  late String petName;
  DateTime? birthdate;
  late String gender;
  String? idRace;
  String? idSpecies;
  String? idIcon;
  late DateTime createdAt;

  /// Maps a Supabase [json] row to a [PetCache] instance
  factory PetCache.fromJson(Map<String, dynamic> json) {
    final cache = PetCache();
    cache.idPet = json['id_pet'] as String;
    cache.petName = json['pet_name'] as String;
    cache.birthdate = json['birthdate'] != null
        ? DateTime.parse(json['birthdate'] as String)
        : null;
    cache.gender = json['gender'] as String;
    cache.idRace = json['id_race'] as String?;
    cache.idSpecies = json['id_species'] as String?;
    cache.idIcon = json['id_icon'] as String?;
    cache.createdAt = DateTime.parse(json['created_at'] as String);
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/pet_cache.dart test/core/isar/cache/schemas/pet_cache_test.dart
git commit -m "feat(isar): add PetCache schema with fromJson"
```

---

## Task 4 : Schéma EventCache

**Files:**
- Create: `lib/core/isar/cache/schemas/event_cache.dart`
- Create: `test/core/isar/cache/schemas/event_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/event_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';

void main() {
  group('EventCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_event': 'event-uuid',
        'title': 'First Walk',
        'description': 'Great walk in the park',
        'created_at': '2024-06-01T08:00:00.000Z',
        'entry_date': '2024-06-01',
        'id_event_type': 'type-uuid',
        'user_id': 'user-uuid',
      };

      final cache = EventCache.fromJson(json);

      expect(cache.idEvent, 'event-uuid');
      expect(cache.title, 'First Walk');
      expect(cache.description, 'Great walk in the park');
      expect(cache.createdAt, DateTime.parse('2024-06-01T08:00:00.000Z'));
      expect(cache.entryDate, DateTime.parse('2024-06-01'));
      expect(cache.idEventType, 'type-uuid');
      expect(cache.userId, 'user-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_event': 'event-uuid',
        'title': 'Quick note',
        'description': null,
        'created_at': '2024-06-01T08:00:00.000Z',
        'entry_date': '2024-06-01',
        'id_event_type': null,
        'user_id': 'user-uuid',
      };

      final cache = EventCache.fromJson(json);

      expect(cache.description, isNull);
      expect(cache.idEventType, isNull);
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma EventCache**

Créer `lib/core/isar/cache/schemas/event_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'event_cache.g.dart';

@Collection()
class EventCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idEvent;

  late String title;
  String? description;
  late DateTime createdAt;

  @Index()
  late DateTime entryDate;

  String? idEventType;
  late String userId;

  /// Maps a Supabase [json] row to an [EventCache] instance
  factory EventCache.fromJson(Map<String, dynamic> json) {
    final cache = EventCache();
    cache.idEvent = json['id_event'] as String;
    cache.title = json['title'] as String;
    cache.description = json['description'] as String?;
    cache.createdAt = DateTime.parse(json['created_at'] as String);
    cache.entryDate = DateTime.parse(json['entry_date'] as String);
    cache.idEventType = json['id_event_type'] as String?;
    cache.userId = json['user_id'] as String;
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/event_cache.dart test/core/isar/cache/schemas/event_cache_test.dart
git commit -m "feat(isar): add EventCache schema with fromJson"
```

---

## Task 5 : Schéma EventImageCache

**Files:**
- Create: `lib/core/isar/cache/schemas/event_image_cache.dart`
- Create: `test/core/isar/cache/schemas/event_image_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/event_image_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';

void main() {
  group('EventImageCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_event_image': 'img-uuid',
        'asset_path': 'journal-media/image.jpg',
        'id_event': 'event-uuid',
      };

      final cache = EventImageCache.fromJson(json);

      expect(cache.idEventImage, 'img-uuid');
      expect(cache.assetPath, 'journal-media/image.jpg');
      expect(cache.idEvent, 'event-uuid');
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma EventImageCache**

Créer `lib/core/isar/cache/schemas/event_image_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'event_image_cache.g.dart';

@Collection()
class EventImageCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idEventImage;

  late String assetPath;

  @Index()
  late String idEvent;

  /// Maps a Supabase [json] row to an [EventImageCache] instance
  factory EventImageCache.fromJson(Map<String, dynamic> json) {
    final cache = EventImageCache();
    cache.idEventImage = json['id_event_image'] as String;
    cache.assetPath = json['asset_path'] as String;
    cache.idEvent = json['id_event'] as String;
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/event_image_cache.dart test/core/isar/cache/schemas/event_image_cache_test.dart
git commit -m "feat(isar): add EventImageCache schema with fromJson"
```

---

## Task 6 : Schéma HealthDiaryCache

**Files:**
- Create: `lib/core/isar/cache/schemas/health_diary_cache.dart`
- Create: `test/core/isar/cache/schemas/health_diary_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/health_diary_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';

void main() {
  group('HealthDiaryCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary': 'hd-uuid',
        'is_sterilized': true,
        'is_chipped': true,
        'chip_number': '985141001234567',
        'last_deworming_at': '2024-03-01T00:00:00.000Z',
        'last_vet_appointment': '2024-05-10T00:00:00.000Z',
        'id_pet': 'pet-uuid',
      };

      final cache = HealthDiaryCache.fromJson(json);

      expect(cache.idHealthDiary, 'hd-uuid');
      expect(cache.isSterilized, true);
      expect(cache.isChipped, true);
      expect(cache.chipNumber, '985141001234567');
      expect(cache.lastDewormingAt, DateTime.parse('2024-03-01T00:00:00.000Z'));
      expect(cache.lastVetAppointment, DateTime.parse('2024-05-10T00:00:00.000Z'));
      expect(cache.idPet, 'pet-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_health_diary': 'hd-uuid',
        'is_sterilized': false,
        'is_chipped': false,
        'chip_number': null,
        'last_deworming_at': null,
        'last_vet_appointment': null,
        'id_pet': 'pet-uuid',
      };

      final cache = HealthDiaryCache.fromJson(json);

      expect(cache.chipNumber, isNull);
      expect(cache.lastDewormingAt, isNull);
      expect(cache.lastVetAppointment, isNull);
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma HealthDiaryCache**

Créer `lib/core/isar/cache/schemas/health_diary_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'health_diary_cache.g.dart';

@Collection()
class HealthDiaryCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idHealthDiary;

  late bool isSterilized;
  late bool isChipped;
  String? chipNumber;
  DateTime? lastDewormingAt;
  DateTime? lastVetAppointment;

  @Index(unique: true)
  late String idPet;

  /// Maps a Supabase [json] row to a [HealthDiaryCache] instance
  factory HealthDiaryCache.fromJson(Map<String, dynamic> json) {
    final cache = HealthDiaryCache();
    cache.idHealthDiary = json['id_health_diary'] as String;
    cache.isSterilized = json['is_sterilized'] as bool;
    cache.isChipped = json['is_chipped'] as bool;
    cache.chipNumber = json['chip_number'] as String?;
    cache.lastDewormingAt = json['last_deworming_at'] != null
        ? DateTime.parse(json['last_deworming_at'] as String)
        : null;
    cache.lastVetAppointment = json['last_vet_appointment'] != null
        ? DateTime.parse(json['last_vet_appointment'] as String)
        : null;
    cache.idPet = json['id_pet'] as String;
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/health_diary_cache.dart test/core/isar/cache/schemas/health_diary_cache_test.dart
git commit -m "feat(isar): add HealthDiaryCache schema with fromJson"
```

---

## Task 7 : Schéma HealthDiaryVaccineCache

**Files:**
- Create: `lib/core/isar/cache/schemas/health_diary_vaccine_cache.dart`
- Create: `test/core/isar/cache/schemas/health_diary_vaccine_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/health_diary_vaccine_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';

void main() {
  group('HealthDiaryVaccineCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary_vaccine': 'vax-uuid',
        'vaccine_name': 'Rabies',
        'last_date': '2024-01-15',
        'next_date': '2025-01-15',
        'recurrence': 365,
        'dose_number': 2,
        'total_dose_number': 3,
        'id_health_diary': 'hd-uuid',
      };

      final cache = HealthDiaryVaccineCache.fromJson(json);

      expect(cache.idHealthDiaryVaccine, 'vax-uuid');
      expect(cache.vaccineName, 'Rabies');
      expect(cache.lastDate, DateTime.parse('2024-01-15'));
      expect(cache.nextDate, DateTime.parse('2025-01-15'));
      expect(cache.recurrence, 365);
      expect(cache.doseNumber, 2);
      expect(cache.totalDoseNumber, 3);
      expect(cache.idHealthDiary, 'hd-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_health_diary_vaccine': 'vax-uuid',
        'vaccine_name': 'Unknown',
        'last_date': null,
        'next_date': null,
        'recurrence': null,
        'dose_number': null,
        'total_dose_number': null,
        'id_health_diary': 'hd-uuid',
      };

      final cache = HealthDiaryVaccineCache.fromJson(json);

      expect(cache.lastDate, isNull);
      expect(cache.nextDate, isNull);
      expect(cache.recurrence, isNull);
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma HealthDiaryVaccineCache**

Créer `lib/core/isar/cache/schemas/health_diary_vaccine_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'health_diary_vaccine_cache.g.dart';

@Collection()
class HealthDiaryVaccineCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idHealthDiaryVaccine;

  late String vaccineName;
  DateTime? lastDate;

  @Index()
  DateTime? nextDate;

  int? recurrence;
  int? doseNumber;
  int? totalDoseNumber;

  @Index()
  late String idHealthDiary;

  /// Maps a Supabase [json] row to a [HealthDiaryVaccineCache] instance
  factory HealthDiaryVaccineCache.fromJson(Map<String, dynamic> json) {
    final cache = HealthDiaryVaccineCache();
    cache.idHealthDiaryVaccine = json['id_health_diary_vaccine'] as String;
    cache.vaccineName = json['vaccine_name'] as String;
    cache.lastDate = json['last_date'] != null
        ? DateTime.parse(json['last_date'] as String)
        : null;
    cache.nextDate = json['next_date'] != null
        ? DateTime.parse(json['next_date'] as String)
        : null;
    cache.recurrence = json['recurrence'] as int?;
    cache.doseNumber = json['dose_number'] as int?;
    cache.totalDoseNumber = json['total_dose_number'] as int?;
    cache.idHealthDiary = json['id_health_diary'] as String;
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/health_diary_vaccine_cache.dart test/core/isar/cache/schemas/health_diary_vaccine_cache_test.dart
git commit -m "feat(isar): add HealthDiaryVaccineCache schema with fromJson"
```

---

## Task 8 : Schéma WeightLogCache

**Files:**
- Create: `lib/core/isar/cache/schemas/weight_log_cache.dart`
- Create: `test/core/isar/cache/schemas/weight_log_cache_test.dart`

- [ ] **Step 1 : Écrire le test fromJson**

Créer `test/core/isar/cache/schemas/weight_log_cache_test.dart` :

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

void main() {
  group('WeightLogCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_weight_log': 'wl-uuid',
        'weight': 5.2,
        'logged_at': '2024-06-15T09:30:00.000Z',
        'id_pet': 'pet-uuid',
      };

      final cache = WeightLogCache.fromJson(json);

      expect(cache.idWeightLog, 'wl-uuid');
      expect(cache.weight, 5.2);
      expect(cache.loggedAt, DateTime.parse('2024-06-15T09:30:00.000Z'));
      expect(cache.idPet, 'pet-uuid');
    });

    test('casts weight from int to double when Supabase returns int', () {
      final json = {
        'id_weight_log': 'wl-uuid',
        'weight': 5,
        'logged_at': '2024-06-15T09:30:00.000Z',
        'id_pet': 'pet-uuid',
      };

      final cache = WeightLogCache.fromJson(json);

      expect(cache.weight, 5.0);
      expect(cache.weight, isA<double>());
    });
  });
}
```

- [ ] **Step 2 : Créer le schéma WeightLogCache**

Créer `lib/core/isar/cache/schemas/weight_log_cache.dart` :

```dart
import 'package:isar/isar.dart';

part 'weight_log_cache.g.dart';

@Collection()
class WeightLogCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String idWeightLog;

  late double weight;

  @Index()
  late DateTime loggedAt;

  @Index()
  late String idPet;

  /// Maps a Supabase [json] row to a [WeightLogCache] instance
  factory WeightLogCache.fromJson(Map<String, dynamic> json) {
    final cache = WeightLogCache();
    cache.idWeightLog = json['id_weight_log'] as String;
    cache.weight = (json['weight'] as num).toDouble();
    cache.loggedAt = DateTime.parse(json['logged_at'] as String);
    cache.idPet = json['id_pet'] as String;
    return cache;
  }
}
```

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/cache/schemas/weight_log_cache.dart test/core/isar/cache/schemas/weight_log_cache_test.dart
git commit -m "feat(isar): add WeightLogCache schema with fromJson"
```

---

## Task 9 : Générer le code Isar (build_runner)

**Files:**
- Create (auto-generated): `lib/core/isar/cache/schemas/*.g.dart` (7 fichiers)

- [ ] **Step 1 : Lancer build_runner**

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

Expected: 7 fichiers `.g.dart` générés sans erreur dans `lib/core/isar/cache/schemas/`.

- [ ] **Step 2 : Vérifier la génération**

```bash
ls lib/core/isar/cache/schemas/
```

Expected: les 7 fichiers `*.dart` + les 7 fichiers `*.g.dart` correspondants.

- [ ] **Step 3 : Lancer tous les tests fromJson**

```bash
flutter test test/core/isar/cache/schemas/
```

Expected: 14 tests PASS (2 par schéma × 7 schémas). Le code généré est maintenant résolu, les imports `isar/isar.dart` sont valides.

- [ ] **Step 4 : Commit**

```bash
git add lib/core/isar/cache/schemas/*.g.dart
git commit -m "feat(isar): generate isar collection code via build_runner"
```

---

## Task 10 : Créer IsarService

**Files:**
- Create: `lib/core/isar/database/isar_service.dart`
- Create: `test/core/isar/database/isar_service_test.dart`

- [ ] **Step 1 : Écrire le test d'initialisation**

Créer `test/core/isar/database/isar_service_test.dart` :

```dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

void main() {
  group('Isar schemas', () {
    late Directory tempDir;
    late Isar isar;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('isar_test_');
      isar = await Isar.open(
        [
          UserCacheSchema,
          PetCacheSchema,
          EventCacheSchema,
          EventImageCacheSchema,
          HealthDiaryCacheSchema,
          HealthDiaryVaccineCacheSchema,
          WeightLogCacheSchema,
        ],
        directory: tempDir.path,
      );
    });

    tearDown(() async {
      await isar.close();
      tempDir.deleteSync(recursive: true);
    });

    test('opens with all schemas without throwing', () {
      expect(isar.isOpen, true);
    });

    test('can write and read a UserCache', () async {
      final user = UserCache.fromJson({
        'id_user': 'test-uuid',
        'user_name': 'Test User',
        'mail': 'test@example.com',
        'subscription_status': 'free',
        'subscription_expires_at': null,
      });

      await isar.writeTxn(() async {
        await isar.userCaches.putByIdUser(user);
      });

      final result = await isar.userCaches.getByIdUser('test-uuid');
      expect(result, isNotNull);
      expect(result!.mail, 'test@example.com');
    });

    test('can write and read a PetCache', () async {
      final pet = PetCache.fromJson({
        'id_pet': 'pet-uuid',
        'pet_name': 'Buddy',
        'birthdate': null,
        'gender': 'male',
        'id_race': null,
        'id_species': null,
        'id_icon': null,
        'created_at': '2024-01-01T00:00:00.000Z',
      });

      await isar.writeTxn(() async {
        await isar.petCaches.putByIdPet(pet);
      });

      final result = await isar.petCaches.getByIdPet('pet-uuid');
      expect(result, isNotNull);
      expect(result!.petName, 'Buddy');
    });
  });
}
```

- [ ] **Step 2 : Lancer le test — vérifier qu'il échoue**

```bash
flutter test test/core/isar/database/isar_service_test.dart
```

Expected: erreur de compilation (`isar_service.dart` n'existe pas encore, mais le test en lui-même compile car il n'importe pas encore `isar_service.dart`). Si le test passe déjà (possible car il n'importe que les schemas), c'est bon — ce test valide l'intégration Isar complète.

- [ ] **Step 3 : Créer IsarService**

Créer `lib/core/isar/database/isar_service.dart` :

```dart
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

class IsarService {
  static late Isar _isar;

  /// Opens Isar with all collection schemas and stores the instance
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        UserCacheSchema,
        PetCacheSchema,
        EventCacheSchema,
        EventImageCacheSchema,
        HealthDiaryCacheSchema,
        HealthDiaryVaccineCacheSchema,
        WeightLogCacheSchema,
      ],
      directory: dir.path,
    );
  }

  /// Returns the open Isar instance. Must call [initialize] first.
  static Isar get instance => _isar;
}
```

- [ ] **Step 4 : Lancer le test d'intégration**

```bash
flutter test test/core/isar/database/isar_service_test.dart
```

Expected: 3 tests PASS.

- [ ] **Step 5 : Commit**

```bash
git add lib/core/isar/database/isar_service.dart test/core/isar/database/isar_service_test.dart
git commit -m "feat(isar): add IsarService singleton with initialize()"
```

---

## Task 11 : Créer SyncService

**Files:**
- Create: `lib/core/isar/database/sync_service.dart`

- [ ] **Step 1 : Créer SyncService**

Créer `lib/core/isar/database/sync_service.dart` :

```dart
import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';

class SyncService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Isar _isar = IsarService.instance;

  /// Wave 1 — awaited before Home renders. Syncs user and pets.
  Future<void> syncCritical() async {
    await Future.wait([_syncUser(), _syncPets()]);
  }

  /// Wave 2 — fire and forget after Home renders.
  void syncSecondary() {
    Future(() async {
      await _syncEvents();
      await _syncEventImages();
      await _syncHealthDiaries();
      await _syncHealthDiaryVaccines();
      await _syncWeightLogs();
    });
  }

  Future<void> _syncUser() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return;

      final data = await _supabase
          .from('users')
          .select()
          .eq('id_user', userId)
          .single();

      final user = UserCache.fromJson(data);
      await _isar.writeTxn(() async {
        await _isar.userCaches.putByIdUser(user);
      });
    } catch (_) {}
  }

  Future<void> _syncPets() async {
    try {
      final data = await _supabase.from('pets').select();
      final pets = (data as List).map((e) => PetCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.petCaches.putAllByIdPet(pets);
      });
    } catch (_) {}
  }

  Future<void> _syncEvents() async {
    try {
      final data = await _supabase.from('events').select();
      final events = (data as List).map((e) => EventCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.eventCaches.putAllByIdEvent(events);
      });
    } catch (_) {}
  }

  Future<void> _syncEventImages() async {
    try {
      final data = await _supabase.from('event_image').select();
      final images = (data as List).map((e) => EventImageCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.eventImageCaches.putAllByIdEventImage(images);
      });
    } catch (_) {}
  }

  Future<void> _syncHealthDiaries() async {
    try {
      final data = await _supabase.from('health_diary').select();
      final diaries = (data as List).map((e) => HealthDiaryCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryCaches.putAllByIdHealthDiary(diaries);
      });
    } catch (_) {}
  }

  Future<void> _syncHealthDiaryVaccines() async {
    try {
      final data = await _supabase.from('health_diary_vaccines').select();
      final vaccines = (data as List).map((e) => HealthDiaryVaccineCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.healthDiaryVaccineCaches.putAllByIdHealthDiaryVaccine(vaccines);
      });
    } catch (_) {}
  }

  Future<void> _syncWeightLogs() async {
    try {
      final data = await _supabase.from('weight_logs').select();
      final logs = (data as List).map((e) => WeightLogCache.fromJson(e as Map<String, dynamic>)).toList();
      await _isar.writeTxn(() async {
        await _isar.weightLogCaches.putAllByIdWeightLog(logs);
      });
    } catch (_) {}
  }
}
```

- [ ] **Step 2 : Vérifier la compilation**

```bash
flutter analyze lib/core/isar/database/sync_service.dart
```

Expected: aucune erreur. Si des erreurs de type Isar collection name apparaissent (ex: `isar.userCaches` non résolu), vérifier que les `.g.dart` sont bien générés (Task 9).

- [ ] **Step 3 : Commit**

```bash
git add lib/core/isar/database/sync_service.dart
git commit -m "feat(isar): add SyncService with two-wave sync orchestration"
```

---

## Task 12 : Intégrer IsarService dans main.dart

**Files:**
- Modify: `lib/main.dart`

- [ ] **Step 1 : Ajouter l'initialisation Isar dans main()**

Remplacer le contenu de `lib/main.dart` par :

```dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/core/isar/database/isar_service.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: ".env");
  final url = dotenv.env['SUPABASE_URL'];
  final anonKey = dotenv.env['SUPABASE_ANON_KEY'];
  if (url == null || anonKey == null) {
    throw Exception('Please add SUPABASE_URL and SUPABASE_ANON_KEY to your .env file');
  }

  await Supabase.initialize(url: url, anonKey: anonKey);
  await IsarService.initialize();

  final authCubit = AuthCubit(
    repository: AuthRepository(),
    syncService: SyncService(),
  );
  runApp(MyApp(authCubit: authCubit));
}

class MyApp extends StatelessWidget {
  final AuthCubit authCubit;
  const MyApp({super.key, required this.authCubit});

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: authCubit,
      child: MaterialApp.router(
        title: 'Nanimo',
        routerConfig: createRouter(authCubit),
      ),
    );
  }
}
```

- [ ] **Step 2 : Vérifier la compilation**

```bash
flutter analyze lib/main.dart
```

Expected: erreur sur `AuthCubit` qui n'accepte pas encore `syncService`. Normal — sera résolu à la Task 13.

- [ ] **Step 3 : Commit**

```bash
git add lib/main.dart
git commit -m "feat(isar): initialize IsarService in main() before runApp"
```

---

## Task 13 : Intégrer SyncService dans AuthCubit

**Files:**
- Modify: `lib/features/auth/presentation/cubit/auth_cubit.dart`

- [ ] **Step 1 : Modifier AuthCubit pour injecter et appeler SyncService**

Remplacer le contenu de `lib/features/auth/presentation/cubit/auth_cubit.dart` par :

```dart
import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _repository;
  final SyncService _syncService;
  late final StreamSubscription<supabase.AuthState> _authSubscription;

  AuthCubit({
    required AuthRepository repository,
    required SyncService syncService,
  }) : _repository = repository,
       _syncService = syncService,
       super(const AuthState.unknown()) {
    _listenToAuthChanges();
  }

  void _listenToAuthChanges() {
    /// Listen to session changes and trigger sync on sign-in or session restore
    _authSubscription = supabase.Supabase.instance.client.auth.onAuthStateChange
        .listen((supabase.AuthState data) async {
      final session = data.session;

      if (session != null) {
        final isNewSession = data.event == supabase.AuthChangeEvent.signedIn ||
            data.event == supabase.AuthChangeEvent.initialSession;

        if (isNewSession) {
          try {
            await _syncService.syncCritical();
          } catch (_) {}
          _syncService.syncSecondary();
        }
        emit(const AuthState.authenticated());
      } else {
        emit(const AuthState.unauthenticated());
      }
    });
  }

  Future<void> login(String email, String password) async {
    try {
      await _repository.login(email, password);
    } catch (e) {
      emit(AuthState.error(e.toString()));
    }
  }

  Future<void> logout() async {
    await _repository.logout();
  }

  @override
  Future<void> close() {
    _authSubscription.cancel();
    return super.close();
  }
}
```

- [ ] **Step 2 : Vérifier la compilation complète**

```bash
flutter analyze
```

Expected: aucune erreur. Si des warnings lint apparaissent sur les `catch (_) {}`, ils sont intentionnels (sync silencieuse).

- [ ] **Step 3 : Lancer tous les tests**

```bash
flutter test
```

Expected: tous les tests PASS (14 tests fromJson + 3 tests isar_service).

- [ ] **Step 4 : Commit final**

```bash
git add lib/features/auth/presentation/cubit/auth_cubit.dart
git commit -m "feat(isar): inject SyncService into AuthCubit, trigger sync on session"
```

---

## Résumé du flux final

```
main()
 ├─ Supabase.initialize()
 ├─ IsarService.initialize()       ← nouveau
 └─ runApp()
      └─ AuthCubit._listenToAuthChanges()
           └─ session détectée (signedIn | initialSession)
                ├─ syncCritical() await  ← user + pets, splash reste visible
                ├─ emit(authenticated)   ← router redirige vers Home
                └─ syncSecondary()       ← events, health, weights en arrière-plan
```

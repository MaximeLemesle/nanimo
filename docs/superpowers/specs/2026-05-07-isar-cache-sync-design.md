# Design : Initialisation Isar + Cache Schemas + Sync Supabase → Isar

**Date** : 2026-05-07  
**Tâche** : NAN-005 — Isar init, schémas de cache, logique de sync au démarrage  
**Approche retenue** : Sync prioritisée en deux vagues (critique bloquante + secondaire non-bloquante)

---

## 1. Structure des fichiers

```
lib/
└── core/
    └── isar/
        ├── database/
        │   ├── isar_service.dart          # Singleton Isar — init + accès à l'instance
        │   └── sync_service.dart          # Orchestration des deux vagues de sync
        └── cache/
            └── schemas/
                ├── user_cache.dart
                ├── pet_cache.dart
                ├── event_cache.dart
                ├── event_image_cache.dart
                ├── health_diary_cache.dart
                ├── health_diary_vaccine_cache.dart
                └── weight_log_cache.dart
```

---

## 2. Dépendances à ajouter (pubspec.yaml)

```yaml
dependencies:
  isar: ^3.1.0
  isar_flutter_libs: ^3.1.0
  path_provider: ^2.1.0   # requis pour getApplicationDocumentsDirectory()

dev_dependencies:
  isar_generator: ^3.1.0
  build_runner: ^2.4.0
```

---

## 3. Schémas Isar

Tous les schémas utilisent `@Collection()`, un `Id` Isar auto-increment, et un `@Index(unique: true)` sur l'UUID Supabase pour les upserts.

### Entités cachées

| Schema | Table Supabase | Priorité sync |
|---|---|---|
| `UserCache` | `users` | Critique (vague 1) |
| `PetCache` | `pets` | Critique (vague 1) |
| `EventCache` | `events` | Secondaire (vague 2) |
| `EventImageCache` | `event_image` | Secondaire (vague 2) |
| `HealthDiaryCache` | `health_diary` | Secondaire (vague 2) |
| `HealthDiaryVaccineCache` | `health_diary_vaccines` | Secondaire (vague 2) |
| `WeightLogCache` | `weight_logs` | Secondaire (vague 2) |

Non cachés : `notifications` (géré par FCM), `subscription_config` (statique).

### Détail des schémas

**UserCache**
```dart
@Collection()
class UserCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idUser;
  String? userName;
  late String mail;
  late String subscriptionStatus;   // 'free' | 'premium'
  DateTime? subscriptionExpiresAt;
}
```

**PetCache**
```dart
@Collection()
class PetCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idPet;
  late String petName;
  DateTime? birthdate;
  late String gender;               // 'male' | 'female' | 'unknown'
  String? idRace;
  String? idSpecies;
  String? idIcon;
  late DateTime createdAt;
}
```

**EventCache**
```dart
@Collection()
class EventCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idEvent;
  late String title;
  String? description;
  late DateTime createdAt;
  @Index() late DateTime entryDate; // indexé pour tri timeline
  String? idEventType;
  late String userId;
}
```

**EventImageCache**
```dart
@Collection()
class EventImageCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idEventImage;
  late String assetPath;
  @Index() late String idEvent;     // indexé pour lookup par event
}
```

**HealthDiaryCache**
```dart
@Collection()
class HealthDiaryCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idHealthDiary;
  late bool isSterilized;
  late bool isChipped;
  String? chipNumber;
  DateTime? lastDewormingAt;
  DateTime? lastVetAppointment;
  @Index(unique: true) late String idPet; // 1:1 avec pet
}
```

**HealthDiaryVaccineCache**
```dart
@Collection()
class HealthDiaryVaccineCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idHealthDiaryVaccine;
  late String vaccineName;
  DateTime? lastDate;
  @Index() DateTime? nextDate;      // indexé pour alertes santé
  int? recurrence;
  int? doseNumber;
  int? totalDoseNumber;
  @Index() late String idHealthDiary;
}
```

**WeightLogCache**
```dart
@Collection()
class WeightLogCache {
  Id id = Isar.autoIncrement;
  @Index(unique: true) late String idWeightLog;
  late double weight;
  @Index() late DateTime loggedAt;  // indexé pour graphique 6 mois
  @Index() late String idPet;
}
```

---

## 4. IsarService

```dart
// core/isar/database/isar_service.dart
class IsarService {
  static late Isar _isar;

  /// Opens Isar with all collection schemas
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

  static Isar get instance => _isar;
}
```

---

## 5. SyncService

```dart
// core/isar/database/sync_service.dart
class SyncService {
  final SupabaseClient _supabase = Supabase.instance.client;
  final Isar _isar = IsarService.instance;

  /// Wave 1 — awaited, blocks until user + pets are cached
  Future<void> syncCritical() async {
    await Future.wait([_syncUser(), _syncPets()]);
  }

  /// Wave 2 — fire and forget after Home renders
  void syncSecondary() {
    Future(() async {
      await _syncEvents();
      await _syncEventImages();
      await _syncHealthDiaries();
      await _syncHealthDiaryVaccines();
      await _syncWeightLogs();
    });
  }

  // Each private method:
  // 1. Fetch from Supabase (filtered by userId via RLS)
  // 2. Map JSON → XCache object
  // 3. isar.writeTxn(() => isar.xCaches.putAllByIdX([...]))  ← upsert by UUID
}
```

---

## 6. Intégration main.dart + AuthCubit

**main.dart** — init Isar avant `runApp()` :
```dart
await Supabase.initialize(url: url, anonKey: anonKey);
await IsarService.initialize();
final authCubit = AuthCubit(
  repository: AuthRepository(),
  syncService: SyncService(),
);
runApp(MyApp(authCubit: authCubit));
```

**AuthCubit** — déclenche la sync après session active :
```dart
await syncService.syncCritical();  // bloquant
syncService.syncSecondary();       // non-bloquant
```

---

## 7. Flux au démarrage

```
main()
 ├─ Supabase.initialize()
 ├─ IsarService.initialize()
 └─ runApp()
      └─ AuthCubit détecte session active
           ├─ syncCritical()  ← await (user + pets)
           ├─ redirect → Home
           └─ syncSecondary() ← fire & forget (events, health, weights)
```

---

## 8. Gestion d'erreurs

- Chaque méthode `_syncX()` est wrappée dans un `try/catch` (convention CLAUDE.md)
- Échec de sync secondaire : silencieux (log uniquement), l'app fonctionne avec les données Isar existantes
- Échec de sync critique : état d'erreur dans AuthCubit → affichage d'un message retry

---

## 9. Génération de code

Après implémentation, lancer :
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

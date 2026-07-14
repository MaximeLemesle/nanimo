import 'dart:io';

import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_type_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/notification_prefs_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_species_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

class IsarTestHarness {
  late Directory _tempDir;
  late Isar isar;

  static bool _coreReady = false;

  Future<void> setUp() async {
    if (!_coreReady) {
      await Isar.initializeIsarCore(download: true);
      _coreReady = true;
    }
    _tempDir = Directory.systemTemp.createTempSync('isar_repo_test_');
    isar = await Isar.open(
      [
        UserCacheSchema,
        PetCacheSchema,
        PetSpeciesCacheSchema,
        EventTypeCacheSchema,
        EventCacheSchema,
        EventImageCacheSchema,
        PetEventCacheSchema,
        HealthDiaryCacheSchema,
        HealthDiaryVaccineCacheSchema,
        WeightLogCacheSchema,
        SubscriptionConfigCacheSchema,
        VetVisitCacheSchema,
        NotificationPrefsCacheSchema,
      ],
      directory: _tempDir.path,
    );
  }

  Future<void> tearDown() async {
    if (isar.isOpen) {
      await isar.close();
    }
    if (_tempDir.existsSync()) {
      _tempDir.deleteSync(recursive: true);
    }
  }
}

import 'dart:io';

import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

/// Spins up a temp-dir Isar instance with every cache schema. Repository tests
/// only need a subset, but loading them all keeps the helper trivial to use.
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
        EventCacheSchema,
        EventImageCacheSchema,
        HealthDiaryCacheSchema,
        HealthDiaryVaccineCacheSchema,
        WeightLogCacheSchema,
        SubscriptionConfigCacheSchema,
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

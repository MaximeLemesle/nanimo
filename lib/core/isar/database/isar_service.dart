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

  /// Opens Isar with all collection schemas and stores the singleton instance
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

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

class IsarService {
  static late Isar _isar;

  static Future<void> initialize() async {
    final existing = Isar.getInstance();
    if (existing != null) {
      _isar = existing;
      return;
    }

    final dir = await getApplicationDocumentsDirectory();
    _isar = await Isar.open(
      [
        UserCacheSchema,
        PetCacheSchema,
        EventCacheSchema,
        EventImageCacheSchema,
        PetEventCacheSchema,
        HealthDiaryCacheSchema,
        HealthDiaryVaccineCacheSchema,
        SubscriptionConfigCacheSchema,
        VetVisitCacheSchema,
        WeightLogCacheSchema,
      ],
      directory: dir.path,
    );
  }

  static Isar get instance => _isar;
}

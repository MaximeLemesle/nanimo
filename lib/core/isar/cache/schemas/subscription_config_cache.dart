import 'package:isar/isar.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

part 'subscription_config_cache.g.dart';

@Collection()
class SubscriptionConfigCache {
  Id id = Isar.autoIncrement;

  late String configId;

  @Index(unique: true)
  late String planName;
  
  late int maxImagesPerEvent;
  late int maxPets;

  SubscriptionConfigCache();

  /// Maps a Supabase [json] row to a [SubscriptionConfigCache] instance
  factory SubscriptionConfigCache.fromJson(Map<String, dynamic> json) {
    return SubscriptionConfigCache()
      ..configId = json['id_subscription_config'].toString()
      ..planName = json['plan_name'] as String
      ..maxImagesPerEvent = json['max_images_per_event'] as int
      ..maxPets = json['max_pets'] as int;
  }

  /// Builds a [SubscriptionConfigCache] from a [SubscriptionConfigModel]
  factory SubscriptionConfigCache.fromModel(SubscriptionConfigModel model) {
    return SubscriptionConfigCache()
      ..configId = model.configId
      ..planName = model.planName
      ..maxImagesPerEvent = model.maxImagesPerEvent
      ..maxPets = model.maxPets;
  }

  /// Converts this cache row into the domain [SubscriptionConfigModel]
  SubscriptionConfigModel toModel() {
    return SubscriptionConfigModel(
      configId: configId,
      planName: planName,
      maxImagesPerEvent: maxImagesPerEvent,
      maxPets: maxPets,
    );
  }
}

import 'package:isar/isar.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';

part 'weight_log_cache.g.dart';

@Collection()
class WeightLogCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String healthDiaryWeightLogId;

  late double weight;

  @Index()
  late DateTime loggedAt;

  @Index()
  late String petId;

  WeightLogCache();

  /// Maps a Supabase [json] row to a [WeightLogCache] instance
  factory WeightLogCache.fromJson(Map<String, dynamic> json) {
    return WeightLogCache()
      ..healthDiaryWeightLogId = json['id_health_diary_weight_log'] as String
      ..weight = (json['weight'] as num).toDouble()
      ..loggedAt = DateTime.parse(json['logged_at'] as String)
      ..petId = json['pet_id'] as String;
  }

  /// Builds a [WeightLogCache] from a [HealthDiaryWeightLogModel]
  factory WeightLogCache.fromModel(HealthDiaryWeightLogModel model) {
    return WeightLogCache()
      ..healthDiaryWeightLogId = model.healthDiaryWeightLogId
      ..weight = model.weight
      ..loggedAt = model.loggedAt
      ..petId = model.petId;
  }

  /// Converts this cache row into the domain [HealthDiaryWeightLogModel]
  HealthDiaryWeightLogModel toModel() {
    return HealthDiaryWeightLogModel(
      healthDiaryWeightLogId: healthDiaryWeightLogId,
      weight: weight,
      loggedAt: loggedAt,
      petId: petId,
    );
  }
}

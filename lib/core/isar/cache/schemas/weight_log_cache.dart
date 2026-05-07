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

  WeightLogCache();

  /// Maps a Supabase [json] row to a [WeightLogCache] instance
  factory WeightLogCache.fromJson(Map<String, dynamic> json) {
    return WeightLogCache()
      ..idWeightLog = json['id_weight_log'] as String
      ..weight = (json['weight'] as num).toDouble()
      ..loggedAt = DateTime.parse(json['logged_at'] as String)
      ..idPet = json['id_pet'] as String;
  }
}

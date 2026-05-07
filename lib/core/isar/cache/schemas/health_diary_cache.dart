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

  HealthDiaryCache();

  /// Maps a Supabase [json] row to a [HealthDiaryCache] instance
  factory HealthDiaryCache.fromJson(Map<String, dynamic> json) {
    return HealthDiaryCache()
      ..idHealthDiary = json['id_health_diary'] as String
      ..isSterilized = json['is_sterilized'] as bool
      ..isChipped = json['is_chipped'] as bool
      ..chipNumber = json['chip_number'] as String?
      ..lastDewormingAt = json['last_deworming_at'] != null
          ? DateTime.parse(json['last_deworming_at'] as String)
          : null
      ..lastVetAppointment = json['last_vet_appointment'] != null
          ? DateTime.parse(json['last_vet_appointment'] as String)
          : null
      ..idPet = json['id_pet'] as String;
  }
}

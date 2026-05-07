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

  HealthDiaryVaccineCache();

  /// Maps a Supabase [json] row to a [HealthDiaryVaccineCache] instance
  factory HealthDiaryVaccineCache.fromJson(Map<String, dynamic> json) {
    return HealthDiaryVaccineCache()
      ..idHealthDiaryVaccine = json['id_health_diary_vaccine'] as String
      ..vaccineName = json['vaccine_name'] as String
      ..lastDate = json['last_date'] != null
          ? DateTime.parse(json['last_date'] as String)
          : null
      ..nextDate = json['next_date'] != null
          ? DateTime.parse(json['next_date'] as String)
          : null
      ..recurrence = json['recurrence'] as int?
      ..doseNumber = json['dose_number'] as int?
      ..totalDoseNumber = json['total_dose_number'] as int?
      ..idHealthDiary = json['id_health_diary'] as String;
  }
}

import 'package:isar/isar.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';

part 'health_diary_vaccine_cache.g.dart';

@Collection()
class HealthDiaryVaccineCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String healthDiaryVaccineId;

  late String vaccineName;
  DateTime? lastDate;

  @Index()
  DateTime? nextDate;

  int? recurrence;
  int? doseNumber;
  int? totalDoseNumber;

  @Index()
  late String healthDiaryId;

  HealthDiaryVaccineCache();

  /// Maps a Supabase [json] row to a [HealthDiaryVaccineCache] instance
  factory HealthDiaryVaccineCache.fromJson(Map<String, dynamic> json) {
    return HealthDiaryVaccineCache()
      ..healthDiaryVaccineId = json['id_health_diary_vaccine'] as String
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
      ..healthDiaryId = json['id_health_diary'] as String;
  }

  /// Builds a [HealthDiaryVaccineCache] from a [HealthDiaryVaccineModel]
  factory HealthDiaryVaccineCache.fromModel(HealthDiaryVaccineModel model) {
    return HealthDiaryVaccineCache()
      ..healthDiaryVaccineId = model.healthDiaryVaccineId
      ..vaccineName = model.vaccineName
      ..lastDate = model.lastDate
      ..nextDate = model.nextDate
      ..recurrence = model.recurrence
      ..doseNumber = model.doseNumber
      ..totalDoseNumber = model.totalDoseNumber
      ..healthDiaryId = model.healthDiaryId;
  }

  /// Converts this cache row into the domain [HealthDiaryVaccineModel]
  HealthDiaryVaccineModel toModel() {
    final epoch = DateTime.fromMillisecondsSinceEpoch(0);
    return HealthDiaryVaccineModel(
      healthDiaryVaccineId: healthDiaryVaccineId,
      vaccineName: vaccineName,
      lastDate: lastDate ?? epoch,
      nextDate: nextDate ?? epoch,
      recurrence: recurrence ?? 0,
      doseNumber: doseNumber ?? 0,
      totalDoseNumber: totalDoseNumber ?? 0,
      healthDiaryId: healthDiaryId,
    );
  }
}

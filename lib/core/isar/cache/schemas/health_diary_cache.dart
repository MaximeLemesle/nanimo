import 'package:isar/isar.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';

part 'health_diary_cache.g.dart';

@Collection()
class HealthDiaryCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String healthDiaryId;

  bool? isSterilized;
  bool? isChipped;
  String? chipNumber;
  DateTime? lastDeworming;
  DateTime? lastVetAppointment;

  @Index(unique: true)
  late String petId;

  HealthDiaryCache();

  /// Maps a Supabase [json] row to a [HealthDiaryCache] instance
  factory HealthDiaryCache.fromJson(Map<String, dynamic> json) {
    return HealthDiaryCache()
      ..healthDiaryId = json['id_health_diary'] as String
      ..isSterilized = json['is_sterilized'] as bool?
      ..isChipped = json['is_chipped'] as bool?
      ..chipNumber = json['chip_number'] as String?
      ..lastDeworming = json['last_deworming_at'] != null
          ? DateTime.parse(json['last_deworming_at'] as String)
          : null
      ..lastVetAppointment = json['last_vet_appointment'] != null
          ? DateTime.parse(json['last_vet_appointment'] as String)
          : null
      ..petId = json['pet_id'] as String;
  }

  /// Builds a [HealthDiaryCache] from a [HealthDiaryModel]
  factory HealthDiaryCache.fromModel(HealthDiaryModel model) {
    return HealthDiaryCache()
      ..healthDiaryId = model.healthDiaryId
      ..isSterilized = model.isSterilized
      ..isChipped = model.isChipped
      ..chipNumber = model.chipNumber
      ..lastDeworming = model.lastDeworming
      ..lastVetAppointment = model.lastVetAppointment
      ..petId = model.petId;
  }

  /// Converts this cache row into the domain [HealthDiaryModel]
  HealthDiaryModel toModel() {
    return HealthDiaryModel(
      healthDiaryId: healthDiaryId,
      isSterilized: isSterilized,
      isChipped: isChipped,
      chipNumber: chipNumber,
      lastDeworming: lastDeworming,
      lastVetAppointment: lastVetAppointment,
      petId: petId,
    );
  }
}

import 'package:isar/isar.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';

part 'vet_visit_cache.g.dart';

@Collection()
class VetVisitCache {
  Id id = Isar.autoIncrement;

  @Index(unique: true)
  late String vetVisitId;

  late String title;

  @Index()
  late DateTime visitedAt;

  String? vetName;
  String? clinicName;

  @Index()
  late String petId;

  VetVisitCache();

  /// Maps a Supabase [json] row to a [VetVisitCache] instance
  factory VetVisitCache.fromJson(Map<String, dynamic> json) {
    return VetVisitCache()
      ..vetVisitId = json['id_vet_visit'] as String
      ..title = json['title'] as String
      ..visitedAt = DateTime.parse(json['visited_at'] as String)
      ..vetName = json['vet_name'] as String?
      ..clinicName = json['clinic_name'] as String?
      ..petId = json['pet_id'] as String;
  }

  /// Builds a [VetVisitCache] from a [VetVisitModel]
  factory VetVisitCache.fromModel(VetVisitModel model) {
    return VetVisitCache()
      ..vetVisitId = model.vetVisitId
      ..title = model.title
      ..visitedAt = model.visitedAt
      ..vetName = model.vetName
      ..clinicName = model.clinicName
      ..petId = model.petId;
  }

  /// Converts this cache row into the domain [VetVisitModel]
  VetVisitModel toModel() {
    return VetVisitModel(
      vetVisitId: vetVisitId,
      title: title,
      visitedAt: visitedAt,
      vetName: vetName,
      clinicName: clinicName,
      petId: petId,
    );
  }
}

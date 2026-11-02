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

  bool hasTime = false;
  String? reason;
  String? report;
  int documentCount = 0;

  VetVisitCache();

  /// Maps a Supabase [json] row to a [VetVisitCache] instance
  factory VetVisitCache.fromJson(Map<String, dynamic> json) =>
      VetVisitCache.fromModel(VetVisitModel.fromJson(json));

  /// Builds a [VetVisitCache] from a [VetVisitModel]
  factory VetVisitCache.fromModel(VetVisitModel model) {
    return VetVisitCache()
      ..vetVisitId = model.vetVisitId
      ..title = model.title
      ..visitedAt = model.visitedAt
      ..vetName = model.vetName
      ..clinicName = model.clinicName
      ..petId = model.petId
      ..hasTime = model.hasTime
      ..reason = model.reason
      ..report = model.report
      ..documentCount = model.documentCount;
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
      hasTime: hasTime,
      reason: reason,
      report: report,
      documentCount: documentCount,
    );
  }
}

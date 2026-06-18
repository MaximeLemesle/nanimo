class VetVisitModel {
  final String vetVisitId;
  final String title;
  final DateTime visitedAt;
  final String? vetName;
  final String? clinicName;
  final String petId;

  const VetVisitModel({
    required this.vetVisitId,
    required this.title,
    required this.visitedAt,
    required this.petId,
    this.vetName,
    this.clinicName,
  });

  factory VetVisitModel.fromJson(Map<String, dynamic> json) {
    return VetVisitModel(
      vetVisitId: json['id_vet_visit'],
      title: json['title'],
      visitedAt: DateTime.parse(json['visited_at'] as String),
      vetName: json['vet_name'],
      clinicName: json['clinic_name'],
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_vet_visit': vetVisitId,
        'title': title,
        'visited_at': visitedAt.toIso8601String(),
        'vet_name': vetName,
        'clinic_name': clinicName,
        'pet_id': petId,
      };
}

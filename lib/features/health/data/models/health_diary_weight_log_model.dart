class HealthDiaryWeightLogModel {
  final String healthDiaryWeightLogId;
  final double weight;
  final DateTime loggedAt;
  final String petId;

  const HealthDiaryWeightLogModel({
    required this.healthDiaryWeightLogId,
    required this.weight,
    required this.loggedAt,
    required this.petId,
  });

  factory HealthDiaryWeightLogModel.fromJson(Map<String, dynamic> json) {
    return HealthDiaryWeightLogModel(
      healthDiaryWeightLogId: json['id_health_diary_weight_log'],
      weight: (json['weight'] as num).toDouble(),
      loggedAt: DateTime.parse(json['logged_at'] as String),
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_health_diary_weight_log': healthDiaryWeightLogId,
        'weight': weight,
        'logged_at': loggedAt.toIso8601String(),
        'pet_id': petId,
      };
}

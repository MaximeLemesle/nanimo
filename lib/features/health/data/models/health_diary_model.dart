class HealthDiaryModel {
  final String healthDiaryId;
  final bool? isSterilized;
  final bool? isChipped;
  final String? chipNumber;
  final DateTime? lastDeworming;
  final DateTime? lastVetAppointment;
  final String petId;

  const HealthDiaryModel({
    required this.healthDiaryId,
    required this.petId,
    this.isSterilized,
    this.isChipped,
    this.chipNumber,
    this.lastDeworming,
    this.lastVetAppointment,
  });

  factory HealthDiaryModel.fromJson(Map<String, dynamic> json) {
    return HealthDiaryModel(
      healthDiaryId: json['id_health_diary'],
      isSterilized: json['is_sterilized'],
      isChipped: json['is_chipped'],
      chipNumber: json['chip_number'],
      lastDeworming: json['last_deworming_at'] != null
          ? DateTime.parse(json['last_deworming_at'] as String)
          : null,
      lastVetAppointment: json['last_vet_appointment'] != null
          ? DateTime.parse(json['last_vet_appointment'] as String)
          : null,
      petId: json['pet_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_health_diary': healthDiaryId,
        'is_sterilized': isSterilized,
        'is_chipped': isChipped,
        'chip_number': chipNumber,
        'last_deworming_at': lastDeworming?.toIso8601String(),
        'last_vet_appointment': lastVetAppointment?.toIso8601String(),
        'pet_id': petId,
      };
}

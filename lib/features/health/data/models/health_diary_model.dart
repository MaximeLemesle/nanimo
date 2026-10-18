class HealthDiaryModel {
  final String healthDiaryId;
  final bool? isSterilized;
  final DateTime? sterilizedAt;
  final bool? isChipped;
  final String? chipNumber;
  final DateTime? lastDeworming;
  final DateTime? lastVetAppointment;
  final String petId;

  const HealthDiaryModel({
    required this.healthDiaryId,
    required this.petId,
    this.isSterilized,
    this.sterilizedAt,
    this.isChipped,
    this.chipNumber,
    this.lastDeworming,
    this.lastVetAppointment,
  });

  factory HealthDiaryModel.fromJson(Map<String, dynamic> json) {
    return HealthDiaryModel(
      healthDiaryId: json['id_health_diary'],
      isSterilized: json['is_sterilized'],
      sterilizedAt: json['sterilized_at'] != null ? DateTime.parse(json['sterilized_at'] as String) : null,
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
        'is_sterilized': isSterilized ?? false,
        // Sent only when known: the column needs migration 0002 (NAN-116).
        if (sterilizedAt != null) 'sterilized_at': sterilizedAt!.toIso8601String().split('T').first,
        'is_chipped': isChipped ?? false,
        'chip_number': chipNumber,
        'last_deworming_at': lastDeworming?.toIso8601String(),
        'last_vet_appointment': lastVetAppointment?.toIso8601String(),
        'pet_id': petId,
      };
}

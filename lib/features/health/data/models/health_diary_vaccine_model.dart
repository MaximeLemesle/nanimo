class HealthDiaryVaccineModel {
  final String healthDiaryVaccineId;
  final String vaccineName;
  final DateTime lastDate;
  final DateTime nextDate;
  final int recurrence;
  final int doseNumber;
  final int totalDoseNumber;
  final String healthDiaryId;

  const HealthDiaryVaccineModel({
    required this.healthDiaryVaccineId,
    required this.vaccineName,
    required this.lastDate,
    required this.nextDate,
    required this.recurrence,
    required this.doseNumber,
    required this.totalDoseNumber,
    required this.healthDiaryId,
  });

  factory HealthDiaryVaccineModel.fromJson(Map<String, dynamic> json) {
    return HealthDiaryVaccineModel(
      healthDiaryVaccineId: json['id_health_diary_vaccine'],
      vaccineName: json['vaccine_name'],
      lastDate: json['last_date'],
      nextDate: json['next_date'],
      recurrence: json['recurrence'],
      doseNumber: json['dose_number'],
      totalDoseNumber: json['total_dose_number'],
      healthDiaryId: json['health_diary_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_health_diary_vaccine': healthDiaryVaccineId,
        'vaccine_name': vaccineName,
        'last_date': lastDate,
        'next_date': nextDate,
        'recurrence': recurrence,
        'dose_number': doseNumber,
        'total_dose_number': totalDoseNumber,
        'health_diary_id': healthDiaryId,
      };
}

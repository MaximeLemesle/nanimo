class RecommendedVaccineModel {
  final String name;
  final String category;
  final int recurrenceDays;

  const RecommendedVaccineModel({
    required this.name,
    required this.category,
    required this.recurrenceDays,
  });

  factory RecommendedVaccineModel.fromJson(Map<String, dynamic> json) {
    return RecommendedVaccineModel(
      name: json['name'] as String,
      category: json['category'] as String,
      recurrenceDays: (json['recurrence_days'] as num).toInt(),
    );
  }
}

class VetVisitModel {
  /// Also the id of the journal event the visit lives in (NAN-133).
  final String vetVisitId;
  final String title;

  /// Local midnight when [hasTime] is false.
  final DateTime visitedAt;
  final String? vetName;
  final String? clinicName;
  final String petId;
  final bool hasTime;

  /// Why the visit is booked, written before it.
  final String? reason;

  /// What the vet said, written after it.
  final String? report;
  final int documentCount;

  const VetVisitModel({
    required this.vetVisitId,
    required this.title,
    required this.visitedAt,
    required this.petId,
    this.vetName,
    this.clinicName,
    this.hasTime = false,
    this.reason,
    this.report,
    this.documentCount = 0,
  });

  /// A visit is filled in once it carries a report or a document.
  bool get isCompleted => (report?.trim().isNotEmpty ?? false) || documentCount > 0;

  bool isUpcoming(DateTime now) => hasTime
      ? visitedAt.isAfter(now)
      : !DateTime(visitedAt.year, visitedAt.month, visitedAt.day).isBefore(DateTime(now.year, now.month, now.day));

  /// Past, still empty, and within the week that follows the visit.
  bool needsCompletion(DateTime now) {
    if (isCompleted || isUpcoming(now)) return false;
    final day = DateTime(visitedAt.year, visitedAt.month, visitedAt.day);
    return now.isBefore(day.add(const Duration(days: 8)));
  }

  /// `visit_at` exists from v1.3.0 on; older rows only carry the date.
  factory VetVisitModel.fromJson(Map<String, dynamic> json) {
    final hasTime = json['has_time'] as bool? ?? false;
    final visitAt = json['visit_at'] as String?;
    return VetVisitModel(
      vetVisitId: json['id_vet_visit'],
      title: json['title'],
      visitedAt: hasTime && visitAt != null
          ? DateTime.parse(visitAt).toLocal()
          : DateTime.parse(json['visited_at'] as String),
      vetName: json['vet_name'],
      clinicName: json['clinic_name'],
      petId: json['pet_id'],
      hasTime: hasTime,
      reason: json['reason'] as String?,
      report: json['report'] as String?,
      documentCount: (json['document_count'] as num?)?.toInt() ?? 0,
    );
  }

  /// `document_count` is computed by the view, never written.
  Map<String, dynamic> toJson() => {
        'id_vet_visit': vetVisitId,
        'title': title,
        'visited_at': _dateOnly(visitedAt),
        'visit_at': visitedAt.toUtc().toIso8601String(),
        'has_time': hasTime,
        'vet_name': vetName,
        'clinic_name': clinicName,
        'pet_id': petId,
        'reason': reason,
        'report': report,
      };

  VetVisitModel copyWith({
    String? title,
    DateTime? visitedAt,
    bool? hasTime,
    String? petId,
    String? Function()? vetName,
    String? Function()? clinicName,
    String? Function()? reason,
    String? Function()? report,
    int? documentCount,
  }) {
    return VetVisitModel(
      vetVisitId: vetVisitId,
      title: title ?? this.title,
      visitedAt: visitedAt ?? this.visitedAt,
      hasTime: hasTime ?? this.hasTime,
      petId: petId ?? this.petId,
      vetName: vetName != null ? vetName() : this.vetName,
      clinicName: clinicName != null ? clinicName() : this.clinicName,
      reason: reason != null ? reason() : this.reason,
      report: report != null ? report() : this.report,
      documentCount: documentCount ?? this.documentCount,
    );
  }

  static String _dateOnly(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

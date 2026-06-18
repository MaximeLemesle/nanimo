class DateFormatter {
  /// Format date as DD/MM/YYYY.
  static String date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  } 

  static String age(DateTime birthdate, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    var years = reference.year - birthdate.year;
    var months = reference.month - birthdate.month;
    if (reference.day < birthdate.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years <= 0) {
      if (months <= 0) return 'Moins d\'un mois';
      return months == 1 ? '1 mois' : '$months mois';
    }
    return years == 1 ? '1 an' : '$years ans';
  }

  /// Detailed age such as « 2 ans et 3 mois » (falls back to [age]).
  static String ageDetailed(DateTime birthdate, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    var years = reference.year - birthdate.year;
    var months = reference.month - birthdate.month;
    if (reference.day < birthdate.day) months--;
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years <= 0) return age(birthdate, now: now);

    final yearsLabel = years == 1 ? '1 an' : '$years ans';
    if (months <= 0) return yearsLabel;
    final monthsLabel = months == 1 ? '1 mois' : '$months mois';
    return '$yearsLabel et $monthsLabel';
  }
}

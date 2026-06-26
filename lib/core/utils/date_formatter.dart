class DateFormatter {
  static const List<String> _frenchMonths = [
    'janvier',
    'février',
    'mars',
    'avril',
    'mai',
    'juin',
    'juillet',
    'août',
    'septembre',
    'octobre',
    'novembre',
    'décembre',
  ];

  /// Format date as DD/MM/YYYY.
  static String date(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = value.month.toString().padLeft(2, '0');
    return '$day/$month/${value.year}';
  }

  /// Event header such as « 05 mars à 11h43 ».
  static String eventHeader(DateTime value) {
    final day = value.day.toString().padLeft(2, '0');
    final month = _frenchMonths[value.month - 1];
    final hour = value.hour.toString().padLeft(2, '0');
    final minute = value.minute.toString().padLeft(2, '0');
    return '$day $month à ${hour}h$minute';
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

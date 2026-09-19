/// Floor of every diary date field is the birthdate; a past event stops at
/// today, a scheduled one is left open. The Journal is deliberately unbounded.
abstract final class DiaryDateBounds {
  /// Floor of a date that may only be booked ahead.
  static DateTime today({DateTime? now}) {
    final reference = now ?? DateTime.now();
    return DateTime(reference.year, reference.month, reference.day);
  }

  /// How far ahead a scheduled date may be set.
  static DateTime openEnd({DateTime? now}) {
    final reference = now ?? DateTime.now();
    return DateTime(reference.year + 30, reference.month, reference.day);
  }
}

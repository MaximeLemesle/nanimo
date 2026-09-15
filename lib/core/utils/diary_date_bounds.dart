/// Floor of every diary date field is the birthdate; a past event stops at
/// today, a scheduled one is left open. The Journal is deliberately unbounded.
abstract final class DiaryDateBounds {
  /// How far ahead a scheduled date may be set.
  static DateTime openEnd({DateTime? now}) {
    final reference = now ?? DateTime.now();
    return DateTime(reference.year + 30, reference.month, reference.day);
  }
}

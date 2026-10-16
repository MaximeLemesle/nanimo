/// Single-date vaccine entry (NAN-096): a future date is the booster to come,
/// a past one is the booster just given, and the next one is deduced from it.
abstract final class VaccineSchedule {
  /// Offered intervals, in months. `null` is "je ne sais pas".
  static const intervals = [1, 3, 6];

  /// Stored in `recurrence` so the next booster can reuse the same interval.
  static int recurrenceDays(int? months) => months == null ? 0 : months * 30;

  /// Recovers the interval of a saved vaccine, `null` when it matches none.
  static int? monthsFromRecurrence(int recurrence) {
    for (final months in intervals) {
      if (recurrenceDays(months) == recurrence) return months;
    }
    return null;
  }

  static bool isUpcoming(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final today = DateTime(reference.year, reference.month, reference.day);
    return DateTime(date.year, date.month, date.day).isAfter(today);
  }

  /// Calendar months, clamped on short months: 31/01 + 1 gives 28 or 29/02.
  static DateTime addMonths(DateTime date, int months) {
    final firstOfTarget = DateTime(date.year, date.month + months);
    final lastDay = DateTime(firstOfTarget.year, firstOfTarget.month + 1, 0).day;
    final day = date.day > lastDay ? lastDay : date.day;
    return DateTime(firstOfTarget.year, firstOfTarget.month, day);
  }

  /// Counts from the date entered, not from today, so a deduced booster may
  /// already be overdue. That is the truth, and it is shown as such.
  static ({DateTime? lastDate, DateTime? nextDate, int recurrence}) resolve({
    required DateTime date,
    int? monthsUntilNext,
    DateTime? now,
  }) {
    if (isUpcoming(date, now: now)) {
      return (lastDate: null, nextDate: date, recurrence: 0);
    }
    return (
      lastDate: date,
      nextDate: monthsUntilNext == null ? null : addMonths(date, monthsUntilNext),
      recurrence: recurrenceDays(monthsUntilNext),
    );
  }
}

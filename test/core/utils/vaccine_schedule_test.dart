import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/vaccine_schedule.dart';

void main() {
  final now = DateTime(2026, 10, 16, 15);

  group('resolve', () {
    test('a future date is the booster to come, with no previous one', () {
      final r = VaccineSchedule.resolve(date: DateTime(2026, 11, 12), monthsUntilNext: 3, now: now);
      expect(r.lastDate, isNull);
      expect(r.nextDate, DateTime(2026, 11, 12));
    });

    test('a past date deduces the next booster from that date, not from today', () {
      final r = VaccineSchedule.resolve(date: DateTime(2026, 6, 10), monthsUntilNext: 6, now: now);
      expect(r.lastDate, DateTime(2026, 6, 10));
      expect(r.nextDate, DateTime(2026, 12, 10));
      expect(r.recurrence, 180);
    });

    test('today counts as past', () {
      final r = VaccineSchedule.resolve(date: DateTime(2026, 10, 16), monthsUntilNext: 1, now: now);
      expect(r.lastDate, DateTime(2026, 10, 16));
      expect(r.nextDate, DateTime(2026, 11, 16));
    });

    test('"je ne sais pas" leaves the next booster empty', () {
      final r = VaccineSchedule.resolve(date: DateTime(2026, 6, 10), now: now);
      expect(r.nextDate, isNull);
      expect(r.recurrence, 0);
    });

    test('a deduced booster may already be overdue, and is kept as is', () {
      final r = VaccineSchedule.resolve(date: DateTime(2026, 2, 1), monthsUntilNext: 3, now: now);
      expect(r.nextDate, DateTime(2026, 5, 1));
    });
  });

  test('addMonths clamps on short months', () {
    expect(VaccineSchedule.addMonths(DateTime(2026, 1, 31), 1), DateTime(2026, 2, 28));
    expect(VaccineSchedule.addMonths(DateTime(2026, 8, 31), 6), DateTime(2027, 2, 28));
    expect(VaccineSchedule.addMonths(DateTime(2026, 11, 15), 3), DateTime(2027, 2, 15));
  });

  test('recurrence round-trips through the offered intervals', () {
    for (final months in VaccineSchedule.intervals) {
      expect(VaccineSchedule.monthsFromRecurrence(VaccineSchedule.recurrenceDays(months)), months);
    }
    expect(VaccineSchedule.monthsFromRecurrence(365), isNull);
  });
}

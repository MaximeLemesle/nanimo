import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

void main() {
  group('DateFormatter.date', () {
    test('formats as DD/MM/YYYY with zero padding', () {
      expect(DateFormatter.date(DateTime(2026, 3, 5)), '05/03/2026');
    });
  });

  group('DateFormatter.time', () {
    test('formats as HH:mm with zero padding', () {
      expect(DateFormatter.time(DateTime(2026, 3, 5, 9, 5)), '09:05');
    });
  });

  group('DateFormatter.monthYear', () {
    test('formats a French month header with capitalization', () {
      expect(DateFormatter.monthYear(DateTime(2026, 3, 5)), 'Mars 2026');
    });
  });

  group('DateFormatter.calendarDay', () {
    test('formats a selected calendar day', () {
      expect(DateFormatter.calendarDay(DateTime(2026, 3, 5)), '5 mars 2026');
    });
  });

  group('DateFormatter.age', () {
    final now = DateTime(2026, 6, 15);

    test('returns "Moins d\'un mois" for newborns', () {
      expect(
        DateFormatter.age(DateTime(2026, 6, 1), now: now),
        "Moins d'un mois",
      );
    });

    test('returns months when under a year', () {
      expect(DateFormatter.age(DateTime(2026, 3, 15), now: now), '3 mois');
      expect(DateFormatter.age(DateTime(2026, 5, 15), now: now), '1 mois');
    });

    test('returns years when over a year', () {
      expect(DateFormatter.age(DateTime(2025, 6, 15), now: now), '1 an');
      expect(DateFormatter.age(DateTime(2023, 6, 15), now: now), '3 ans');
    });
  });

  group('DateFormatter.ageDetailed', () {
    final now = DateTime(2026, 6, 15);

    test('combines years and months', () {
      expect(DateFormatter.ageDetailed(DateTime(2024, 3, 15), now: now),
          '2 ans et 3 mois');
    });

    test('uses singular labels', () {
      expect(DateFormatter.ageDetailed(DateTime(2025, 5, 15), now: now),
          '1 an et 1 mois');
    });

    test('drops the months part when zero', () {
      expect(
          DateFormatter.ageDetailed(DateTime(2024, 6, 15), now: now), '2 ans');
    });

    test('falls back to age() under a year', () {
      expect(
          DateFormatter.ageDetailed(DateTime(2026, 3, 15), now: now), '3 mois');
    });
  });
}

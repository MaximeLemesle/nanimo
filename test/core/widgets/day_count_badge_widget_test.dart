import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/day_count_badge_widget.dart';

void main() {
  final now = DateTime(2026, 9, 16, 12);

  group('DayCountBadgeWidget.labelFor', () {
    test('counts the days ahead', () {
      expect(
        DayCountBadgeWidget.labelFor(now.add(const Duration(days: 24)), now: now),
        'Dans 24 j',
      );
    });

    test('names the two nearest days', () {
      expect(
        DayCountBadgeWidget.labelFor(now.add(const Duration(days: 1)), now: now),
        'Demain',
      );
      expect(
        DayCountBadgeWidget.labelFor(now.add(const Duration(hours: 2)), now: now),
        "Aujourd'hui",
      );
    });

    // NAN-111: 14 h ahead is tomorrow once midnight lies in between.
    test('counts calendar days, not 24-hour spans', () {
      final evening = DateTime(2026, 10, 18, 19, 32);
      expect(DayCountBadgeWidget.labelFor(DateTime(2026, 10, 19, 10), now: evening), 'Demain');
      expect(DayCountBadgeWidget.labelFor(DateTime(2026, 10, 20, 8), now: evening), 'Dans 2 j');
      expect(DayCountBadgeWidget.labelFor(DateTime(2026, 10, 18, 23), now: evening), "Aujourd'hui");
    });

    // NAN-090: VaccineStatusBadgeWidget would read "Terminé" past thirty days.
    test('keeps counting beyond thirty days, in months then years', () {
      final from = DateTime(2026, 10, 22, 9);
      String label(DateTime date) => DayCountBadgeWidget.labelFor(date, now: from);
      expect(label(DateTime(2026, 11, 21)), 'Dans 30 j');
      expect(label(DateTime(2026, 11, 23)), 'Dans 1 mois');
      expect(label(DateTime(2027, 1, 21)), 'Dans 2 mois');
      expect(label(DateTime(2027, 1, 22)), 'Dans 3 mois');
      expect(label(DateTime(2027, 10, 21)), 'Dans 11 mois');
      expect(label(DateTime(2027, 10, 22)), 'Dans 1 an');
      expect(label(DateTime(2029, 3, 1)), 'Dans 2 ans');
    });
  });

  test('is yellow within a month only', () {
    expect(DayCountBadgeWidget.isSoon(now.add(const Duration(days: 30)), now: now), isTrue);
    expect(DayCountBadgeWidget.isSoon(now.add(const Duration(days: 31)), now: now), isFalse);
  });

  testWidgets('renders its label', (tester) async {
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: DayCountBadgeWidget(
          date: now.add(const Duration(days: 24)),
          now: now,
        ),
      ),
    ));

    expect(find.text('Dans 24 j'), findsOneWidget);
  });
}

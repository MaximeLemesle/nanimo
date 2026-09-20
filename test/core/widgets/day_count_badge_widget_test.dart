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

    // NAN-090: VaccineStatusBadgeWidget would read "Terminé" past thirty days.
    test('keeps counting beyond thirty days', () {
      expect(
        DayCountBadgeWidget.labelFor(now.add(const Duration(days: 90)), now: now),
        'Dans 90 j',
      );
    });
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

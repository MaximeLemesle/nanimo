import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';

/// NAN-096: one date field wherever the sheet opens.
DateTime _day(DateTime d) => DateTime(d.year, d.month, d.day);

void main() {
  ({String name, DateTime? last, DateTime? next, int recurrence})? submitted;

  Future<void> pumpSheet(WidgetTester tester, {HealthDiaryVaccineModel? initial}) async {
    submitted = null;
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddVaccineBottomSheetWidget(
          birthdate: DateTime(2020, 3, 12),
          initial: initial,
          onSubmit: ({
            required String vaccineName,
            DateTime? lastDate,
            DateTime? nextDate,
            required int recurrence,
            String? petId,
          }) {
            submitted = (name: vaccineName, last: lastDate, next: nextDate, recurrence: recurrence);
          },
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  ButtonState saveState(WidgetTester tester) =>
      tester.widget<ButtonWidget>(find.widgetWithText(ButtonWidget, 'Enregistrer')).state;

  /// The picker opens on today and has no confirm button: dismissing it keeps the date.
  Future<void> pickToday(WidgetTester tester) async {
    await tester.tap(find.widgetWithText(InputDecorator, 'Date du vaccin'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();
  }

  HealthDiaryVaccineModel vaccine({DateTime? last, DateTime? next, int recurrence = 0}) => HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'v1',
        vaccineName: 'Rage',
        lastDate: last,
        nextDate: next,
        recurrence: recurrence,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: 'd1',
      );

  testWidgets('carries a single date field', (tester) async {
    await pumpSheet(tester);

    expect(find.text('Date du vaccin'), findsOneWidget);
    expect(find.text('Dernier rappel'), findsNothing);
    expect(find.text('Prochain rappel'), findsNothing);
    expect(find.text('Quand est le prochain rappel ?'), findsNothing);
  });

  testWidgets('a past date asks for the next booster before saving', (tester) async {
    await pumpSheet(tester);
    await tester.enterText(find.byType(TextField).first, 'Rage');
    await pickToday(tester);

    expect(find.text('Quand est le prochain rappel ?'), findsOneWidget);
    for (final label in ['Dans 1 mois', 'Dans 3 mois', 'Dans 6 mois', 'Je ne sais pas']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(saveState(tester), ButtonState.disabled);

    await tester.tap(find.text('Dans 3 mois'));
    await tester.pumpAndSettle();
    expect(saveState(tester), ButtonState.normal);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    final today = DateTime.now();
    expect(_day(submitted!.last!), _day(today));
    expect(submitted!.next, isNotNull);
    expect(submitted!.recurrence, 90);
  });

  testWidgets('"Je ne sais pas" saves without a next booster', (tester) async {
    await pumpSheet(tester);
    await tester.enterText(find.byType(TextField).first, 'Rage');
    await pickToday(tester);

    await tester.tap(find.text('Je ne sais pas'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted!.last, isNotNull);
    expect(submitted!.next, isNull);
  });

  testWidgets('a future date is the booster to come, nothing more to ask', (tester) async {
    final next = DateTime.now().add(const Duration(days: 40));
    await pumpSheet(tester, initial: vaccine(next: next));

    expect(find.text('Quand est le prochain rappel ?'), findsNothing);
    expect(saveState(tester), ButtonState.normal);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted!.last, isNull);
    expect(_day(submitted!.next!), _day(next));
  });

  testWidgets('editing a vaccine saved with two unrelated dates keeps its booster', (tester) async {
    await pumpSheet(tester, initial: vaccine(last: DateTime(2025, 8, 24), next: DateTime(2026, 8, 24), recurrence: 365));

    expect(find.text('Le 24/08/2026'), findsOneWidget);
    expect(saveState(tester), ButtonState.normal);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted!.last, DateTime(2025, 8, 24));
    expect(submitted!.next, DateTime(2026, 8, 24));
    expect(submitted!.recurrence, 365);
  });

  testWidgets('editing a vaccine with a known interval preselects it', (tester) async {
    await pumpSheet(tester, initial: vaccine(last: DateTime(2026, 6, 10), next: DateTime(2026, 12, 10), recurrence: 180));

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted!.next, DateTime(2026, 12, 10));
    expect(submitted!.recurrence, 180);
  });
}

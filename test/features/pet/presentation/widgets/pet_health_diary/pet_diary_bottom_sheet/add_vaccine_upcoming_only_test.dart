import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/add_vaccine_bottom_sheet_widget.dart';

/// NAN-090 review: an animal booked for a first booster never had one, so the
/// home sheet must not ask for a past date it cannot have.
void main() {
  DateTime? submittedLast;
  DateTime? submittedNext;

  Future<void> pumpSheet(WidgetTester tester, {bool upcomingOnly = true}) async {
    submittedLast = null;
    submittedNext = null;

    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: AddVaccineBottomSheetWidget(
          birthdate: DateTime(2024, 3, 12),
          upcomingOnly: upcomingOnly,
          onSubmit: ({
            required String vaccineName,
            DateTime? lastDate,
            required DateTime nextDate,
            String? petId,
          }) {
            submittedLast = lastDate;
            submittedNext = nextDate;
          },
        ),
      ),
    ));
    await tester.pumpAndSettle();
  }

  ButtonWidget saveButton(WidgetTester tester) => tester.widget<ButtonWidget>(
        find.widgetWithText(ButtonWidget, 'Enregistrer'),
      );

  testWidgets('booked ahead, the last booster field is gone', (tester) async {
    await pumpSheet(tester);

    expect(find.text('Dernier rappel'), findsNothing);
    expect(find.text('Prochain rappel'), findsOneWidget);
  });

  testWidgets('from the diary, the last booster field is still there',
      (tester) async {
    await pumpSheet(tester, upcomingOnly: false);

    expect(find.text('Dernier rappel'), findsOneWidget);
  });

  testWidgets('booked ahead, the name and the next booster are enough',
      (tester) async {
    await pumpSheet(tester);

    expect(saveButton(tester).state, ButtonState.disabled);

    await tester.enterText(find.byType(TextField).first, 'Rage');
    await tester.pumpAndSettle();

    /// Still short of the next booster.
    expect(saveButton(tester).state, ButtonState.disabled);

    await tester.tap(find.widgetWithText(InputDecorator, 'Prochain rappel'));
    await tester.pumpAndSettle();

    /// The picker has no confirm button: dismissing it keeps the date.
    await tester.tapAt(const Offset(10, 10));
    await tester.pumpAndSettle();

    expect(saveButton(tester).state, ButtonState.normal);

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submittedNext, isNotNull);
    expect(submittedLast, isNull);
  });
}

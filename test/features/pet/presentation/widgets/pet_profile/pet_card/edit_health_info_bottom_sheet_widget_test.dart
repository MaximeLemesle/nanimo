import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/edit_health_info_bottom_sheet_widget.dart';

void main() {
  late bool submitted;
  late bool? capturedSterilized;
  late bool? capturedChipped;
  late String? capturedChipNumber;
  late DateTime? capturedDeworming;

  setUp(() {
    submitted = false;
    capturedSterilized = null;
    capturedChipped = null;
    capturedChipNumber = null;
    capturedDeworming = null;
  });

  Future<void> pumpSheet(WidgetTester tester, HealthDiaryModel diary) async {
    tester.view.physicalSize = const Size(1200, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => EditHealthInfoBottomSheetWidget(
                  diary: diary,
                  onSubmit: ({
                    required bool isSterilized,
                    required bool isChipped,
                    String? chipNumber,
                    DateTime? lastDeworming,
                  }) {
                    submitted = true;
                    capturedSterilized = isSterilized;
                    capturedChipped = isChipped;
                    capturedChipNumber = chipNumber;
                    capturedDeworming = lastDeworming;
                  },
                ),
              ),
              child: const Text('open'),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  HealthDiaryModel diary({
    bool? isSterilized,
    bool? isChipped,
    String? chipNumber,
    DateTime? lastDeworming,
  }) =>
      HealthDiaryModel(
        healthDiaryId: 'diary-1',
        petId: 'pet-1',
        isSterilized: isSterilized,
        isChipped: isChipped,
        chipNumber: chipNumber,
        lastDeworming: lastDeworming,
        lastVetAppointment: DateTime(2026, 1, 1),
      );

  testWidgets('opens pre-filled with the recorded values', (tester) async {
    await pumpSheet(
      tester,
      diary(isSterilized: true, isChipped: true, chipNumber: '250269'),
    );

    final switches =
        tester.widgetList<CupertinoSwitch>(find.byType(CupertinoSwitch)).toList();

    /// Sterilised, dewormed, chipped, in that order. This diary carries no
    /// deworming date, so the middle one must stay off.
    expect(switches[0].value, isTrue);
    expect(switches[1].value, isFalse);
    expect(switches[2].value, isTrue);
    expect(find.text('250269'), findsOneWidget);
  });

  /// A recorded date is the only evidence the pet was dewormed, so it drives
  /// the toggle. Without it the section would open closed on a filled diary.
  testWidgets('opens the deworming section when a date exists', (tester) async {
    await pumpSheet(tester, diary(lastDeworming: DateTime(2026, 5, 4)));

    expect(find.text('Dernier vermifuge'), findsOneWidget);
  });

  testWidgets('hands back the untouched values on save', (tester) async {
    await pumpSheet(
      tester,
      diary(isSterilized: true, isChipped: true, chipNumber: '250269'),
    );

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(capturedSterilized, isTrue);
    expect(capturedChipped, isTrue);
    expect(capturedChipNumber, '250269');
  });

  /// The point of the ticket: a value entered by mistake must be reversible.
  /// `updateDiary` could not do this, hence `updateHealthInfo`.
  testWidgets('a sterilisation ticked by mistake can be unticked',
      (tester) async {
    await pumpSheet(tester, diary(isSterilized: true));

    await tester.tap(find.byType(CupertinoSwitch).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(capturedSterilized, isFalse);
  });

  /// No orphan chip number left behind a "Non".
  testWidgets('unticking the chip clears its number', (tester) async {
    await pumpSheet(tester, diary(isChipped: true, chipNumber: '250269'));

    await tester.tap(find.byType(CupertinoSwitch).last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(capturedChipped, isFalse);
    expect(capturedChipNumber, isNull);
  });

  testWidgets('unticking the deworming clears its date', (tester) async {
    await pumpSheet(tester, diary(lastDeworming: DateTime(2026, 5, 4)));

    /// Sterilised, dewormed, chipped: the deworming switch is the second.
    await tester.tap(find.byType(CupertinoSwitch).at(1));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(capturedDeworming, isNull);
  });
}

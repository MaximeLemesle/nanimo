import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

const _recommended = [
  RecommendedVaccineModel(
    name: 'Typhus félin',
    category: 'Obligatoire',
    recurrenceDays: 365,
  ),
];

void main() {
  late bool submitted;
  late double? capturedWeight;
  late DateTime? capturedDate;
  late bool? capturedChipped;
  late List<VaccineEntry> capturedVaccines;
  late List<VetVisitEntry> capturedVisits;

  setUp(() {
    submitted = false;
    capturedWeight = null;
    capturedDate = null;
    capturedChipped = null;
    capturedVaccines = const [];
    capturedVisits = const [];
  });

  Widget harness() {
    return MaterialApp(
      home: Scaffold(
        body: Builder(
          builder: (context) => ElevatedButton(
            onPressed: () => showModalBottomSheet<void>(
              context: context,
              isScrollControlled: true,
              builder: (_) => CreateHealthDiaryBottomSheetWidget(
                petName: 'Yummy',
                gender: Gender.female,
                birthdate: DateTime(2024, 1, 1),
                recommendedVaccines: _recommended,
                onSubmit: ({
                  double? birthWeight,
                  DateTime? birthWeightDate,
                  bool? isSterilized,
                  bool? isChipped,
                  String? chipNumber,
                  DateTime? lastDeworming,
                  required List<VaccineEntry> vaccines,
                  required List<VetVisitEntry> vetVisits,
                }) {
                  submitted = true;
                  capturedWeight = birthWeight;
                  capturedDate = birthWeightDate;
                  capturedChipped = isChipped;
                  capturedVaccines = vaccines;
                  capturedVisits = vetVisits;
                },
              ),
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
  }

  testWidgets('submits the birth weight with the birthdate by default',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '0,3');
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(capturedWeight, 0.3);
    expect(capturedDate, DateTime(2024, 1, 1));
    expect(capturedChipped, isFalse);
    expect(capturedVaccines, isEmpty);
    expect(capturedVisits, isEmpty);
  });

  testWidgets('includes a checked recommended vaccine in the payload',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Enable the "Déjà reçu des vaccins ?" switch (4th switch).
    await tester.tap(find.byType(CupertinoSwitch).at(3));
    await tester.pumpAndSettle();

    // Check the recommended vaccine.
    await tester.tap(find.byType(Checkbox).first);
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(capturedVaccines.length, 1);
    expect(capturedVaccines.first.name, 'Typhus félin');
    expect(capturedVaccines.first.recurrence, 365);
  });

  // NAN-087: the vet visit sheet used to pop twice, taking the diary sheet down
  // with it and losing everything already typed.
  testWidgets('keeps the diary sheet open and lists the visit after adding one',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(harness());
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, '0,3');
    await tester.pumpAndSettle();

    // Enable "Déjà allé chez le véto ?" (5th switch) then open the visit sheet.
    await tester.tap(find.byType(CupertinoSwitch).at(4));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter une visite'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.widgetWithText(TextField, 'Motif de la visite'), 'Rappel annuel');
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(InkWell, 'Sélectionner une date').last);
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(400, 50));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer').last);
    await tester.pumpAndSettle();

    expect(find.text('Création du carnet de santé'), findsOneWidget);
    expect(find.textContaining('Rappel annuel'), findsOneWidget);
    expect(submitted, isFalse);

    // The typed weight survived, and the visit rides along on submit.
    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    expect(submitted, isTrue);
    expect(capturedWeight, 0.3);
    expect(capturedVisits.length, 1);
    expect(capturedVisits.first.title, 'Rappel annuel');
  });
}

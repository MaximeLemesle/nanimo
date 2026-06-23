import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_bottom_sheet/create_health_diary_bottom_sheet_widget.dart';

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
}

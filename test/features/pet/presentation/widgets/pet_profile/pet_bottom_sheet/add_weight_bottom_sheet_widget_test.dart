import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';

PetModel _pet(String id, String name) => PetModel(
      petId: id,
      petName: name,
      birthdate: DateTime(2024, 1, 1),
      gender: Gender.male,
      createdAt: DateTime(2024, 1, 1),
      petRaceId: 'r1',
      petSpeciesId: 's1',
    );

void main() {
  double? submittedWeight;
  String? submittedPetId;

  Widget wrap({List<PetModel> pets = const [], String? initialPetId}) {
    return MaterialApp(
      home: Scaffold(
        body: AddWeightBottomSheetWidget(
          pets: pets,
          portraits: const {
            'p1': PetPortrait.species('cat-europeen'),
            'p2': PetPortrait.species('cat-europeen'),
          },
          initialPetId: initialPetId,
          onSubmit: (weight, loggedAt, {petId}) {
            submittedWeight = weight;
            submittedPetId = petId;
          },
        ),
      ),
    );
  }

  setUp(() {
    submittedWeight = null;
    submittedPetId = null;
  });

  testWidgets('weight input and save stay above the keyboard in the real modal',
      (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: Builder(
                builder: (context) => TextButton(
                    onPressed: () => BottomSheetWidget.show(
                        context,
                        AddWeightBottomSheetWidget(
                            pets: [_pet('p1', 'Maki')],
                            onSubmit: (_, __, {petId}) {})),
                    child: const Text('open'))))));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    tester.view.viewInsets = const FakeViewPadding(bottom: 320);
    await tester.pumpAndSettle();
    final keyboardTop = 844 - 320;
    expect(tester.getBottomLeft(find.byType(TextField)).dy,
        lessThanOrEqualTo(keyboardTop));
    await tester.ensureVisible(find.text('Enregistrer'));
    await tester.pumpAndSettle();
    expect(tester.getBottomLeft(find.text('Enregistrer')).dy,
        lessThanOrEqualTo(keyboardTop));
    expect(tester.takeException(), isNull);
  });

  testWidgets('hides the pet picker with a single pet', (tester) async {
    await tester.pumpWidget(wrap(pets: [_pet('p1', 'Maki')]));
    expect(find.byType(PetPickerWidget), findsNothing);
  });

  testWidgets('shows the pet picker with several pets', (tester) async {
    await tester.pumpWidget(
      wrap(pets: [_pet('p1', 'Maki'), _pet('p2', 'Nala')]),
    );
    expect(find.byType(PetPickerWidget), findsOneWidget);
    expect(find.byKey(const ValueKey('p1')), findsOneWidget);
    expect(find.byKey(const ValueKey('p2')), findsOneWidget);
  });

  testWidgets('submits the weight for the tapped pet', (tester) async {
    await tester.pumpWidget(
      wrap(
        pets: [_pet('p1', 'Maki'), _pet('p2', 'Nala')],
        initialPetId: 'p1',
      ),
    );

    await tester.tap(find.byKey(const ValueKey('p2')));
    await tester.pump();

    await tester.enterText(find.byType(TextField), '6,2');
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    expect(submittedWeight, 6.2);
    expect(submittedPetId, 'p2');
  });

  testWidgets('falls back to the initial pet when none is tapped',
      (tester) async {
    await tester.pumpWidget(
      wrap(
        pets: [_pet('p1', 'Maki'), _pet('p2', 'Nala')],
        initialPetId: 'p2',
      ),
    );

    await tester.enterText(find.byType(TextField), '4,5');
    await tester.pump();
    await tester.tap(find.text('Enregistrer'));
    await tester.pump();

    expect(submittedPetId, 'p2');
  });
}

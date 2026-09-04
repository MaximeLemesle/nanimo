import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/event/presentation/widgets/create_event/create_event_bottom_sheet/pet_select_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

final _milo = PetModel(
  petId: 'pet-milo',
  petName: 'Milo',
  birthdate: DateTime(2022, 5, 1),
  gender: Gender.male,
  createdAt: DateTime(2022, 5, 1),
  petRaceId: 'r',
  petSpeciesId: 's-cat',
);

final _rex = PetModel(
  petId: 'pet-rex',
  petName: 'Rex',
  birthdate: DateTime(2021, 1, 1),
  gender: Gender.male,
  createdAt: DateTime(2021, 1, 1),
  petRaceId: 'r2',
  petSpeciesId: 's-dog',
);

void main() {
  Widget harness(Future<void> Function(BuildContext) onTap) => MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => onTap(context),
              child: const Text('open'),
            ),
          ),
        ),
      );

  testWidgets('disables validation until a pet is picked, then returns it',
      (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<String>? result;
    await tester.pumpWidget(harness((context) async {
      result = await PetSelectBottomSheetWidget.show(
        context,
        pets: [_milo, _rex],
        selectedPetIds: const [],
        portraits: const {
          'pet-milo': PetPortrait.species('cat'),
          'pet-rex': PetPortrait.species('dog'),
        },
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Choisir au moins un animal'), findsOneWidget);
    expect(
      find.text('Sélectionnez au moins un animal pour ce souvenir.'),
      findsOneWidget,
    );

    // Validate is disabled: tapping it should not close the sheet.
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();
    expect(find.text('Choisir au moins un animal'), findsOneWidget);

    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Valider'));
    await tester.pumpAndSettle();

    expect(result, ['pet-milo']);
  });

  testWidgets('deselects a pet when tapped twice', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 1600));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    List<String>? result;
    await tester.pumpWidget(harness((context) async {
      result = await PetSelectBottomSheetWidget.show(
        context,
        pets: [_milo],
        selectedPetIds: const ['pet-milo'],
        portraits: const {
          'pet-milo': PetPortrait.species('cat'),
          'pet-rex': PetPortrait.species('dog'),
        },
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    // Pre-selected: tap once to remove, validation becomes disabled again.
    await tester.tap(find.text('Milo'));
    await tester.pumpAndSettle();
    expect(
      find.text('Sélectionnez au moins un animal pour ce souvenir.'),
      findsOneWidget,
    );
    expect(result, isNull);
  });

  testWidgets('shows an empty message when there is no pet', (tester) async {
    await tester.pumpWidget(harness((context) async {
      await PetSelectBottomSheetWidget.show(
        context,
        pets: const [],
        selectedPetIds: const [],
        portraits: const {},
      );
    }));

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('Aucun animal disponible.'), findsOneWidget);
  });
}

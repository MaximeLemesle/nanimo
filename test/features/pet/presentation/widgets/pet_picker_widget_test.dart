import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_picker_widget.dart';

PetModel _pet(String id, String name) => PetModel(
      petId: id,
      petName: name,
      birthdate: DateTime(2024, 1, 1),
      gender: Gender.male,
      createdAt: DateTime(2024, 1, 1),
      petRaceId: 'r1',
      petSpeciesId: 's1',
    );

final _pets = [_pet('p1', 'Maki'), _pet('p2', 'Nala'), _pet('p3', 'Pixel')];
const _portraits = {
  'p1': PetPortrait.species('cat'),
  'p2': PetPortrait.species('cat'),
  'p3': PetPortrait.species('cat'),
};

Widget _host(Widget child) => MaterialApp(home: Scaffold(body: child));

void main() {
  group('single', () {
    testWidgets('reports the tapped pet', (tester) async {
      String? tapped;
      await tester.pumpWidget(_host(
        PetPickerWidget.single(
          pets: _pets,
          portraits: _portraits,
          selectedPetId: 'p1',
          onSelected: (id) => tapped = id,
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('p3')));
      expect(tapped, 'p3');
    });

    testWidgets('renders one tile per pet', (tester) async {
      await tester.pumpWidget(_host(
        PetPickerWidget.single(
          pets: _pets,
          portraits: _portraits,
          selectedPetId: 'p1',
          onSelected: (_) {},
        ),
      ));

      for (final pet in _pets) {
        expect(find.byKey(ValueKey(pet.petId)), findsOneWidget);
      }
    });

    testWidgets('a null selection highlights nothing', (tester) async {
      await tester.pumpWidget(_host(
        PetPickerWidget.single(
          pets: _pets,
          portraits: _portraits,
          selectedPetId: null,
          onSelected: (_) {},
        ),
      ));

      final picker = tester.widget<PetPickerWidget>(find.byType(PetPickerWidget));
      expect(picker.selectedPetIds, isEmpty);
    });
  });

  group('multi', () {
    testWidgets('reports the tapped pet without toggling itself', (tester) async {
      final taps = <String>[];
      await tester.pumpWidget(_host(
        PetPickerWidget.multi(
          pets: _pets,
          portraits: _portraits,
          selectedPetIds: const {'p1', 'p2'},
          onToggled: taps.add,
        ),
      ));

      await tester.tap(find.byKey(const ValueKey('p1')));
      await tester.tap(find.byKey(const ValueKey('p3')));

      /// Selection belongs to the caller — the widget only relays taps.
      expect(taps, ['p1', 'p3']);
    });

    testWidgets('keeps every selected id', (tester) async {
      await tester.pumpWidget(_host(
        PetPickerWidget.multi(
          pets: _pets,
          portraits: _portraits,
          selectedPetIds: const {'p1', 'p2'},
          onToggled: (_) {},
        ),
      ));

      final picker = tester.widget<PetPickerWidget>(find.byType(PetPickerWidget));
      expect(picker.selectedPetIds, {'p1', 'p2'});
    });
  });

  testWidgets('falls back to a blank tile when the species has no icon',
      (tester) async {
    await tester.pumpWidget(_host(
      PetPickerWidget.single(
        pets: _pets,
        portraits: const {},
        selectedPetId: 'p1',
        onSelected: (_) {},
      ),
    ));

    expect(find.byKey(const ValueKey('p1')), findsOneWidget);
  });
}

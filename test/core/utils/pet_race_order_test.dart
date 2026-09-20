import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/pet_race_order.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';

PetRaceModel _race(String name) => PetRaceModel(
      petRaceId: name,
      raceName: name,
      petSpeciesId: 's1',
    );

List<String> _names(List<PetRaceModel> races) =>
    races.map((r) => r.raceName).toList();

void main() {
  group('PetRaceOrder.sorted', () {
    test('orders alphabetically', () {
      final sorted = PetRaceOrder.sorted(
        [_race('Teckel'), _race('Beagle'), _race('Husky')],
      );

      expect(_names(sorted), ['Beagle', 'Husky', 'Teckel']);
    });

    /// The catch-all would otherwise sit in the A's, between Akita and Beagle.
    test('closes the list with Autre', () {
      final sorted = PetRaceOrder.sorted(
        [_race('Beagle'), _race('Autre'), _race('Akita Inu')],
      );

      expect(_names(sorted), ['Akita Inu', 'Beagle', 'Autre']);
    });

    /// The breeds are typed by hand and their casing is uneven in base.
    test('ignores the casing', () {
      final sorted = PetRaceOrder.sorted(
        [_race('Berger Australien'), _race('Berger américain')],
      );

      expect(_names(sorted), ['Berger américain', 'Berger Australien']);
    });

    /// On a raw comparison, É sits after Z and the breed closes the list.
    test('files an accent with its plain letter', () {
      final sorted = PetRaceOrder.sorted(
        [_race('Teckel'), _race('Épagneul breton'), _race('Dobermann')],
      );

      expect(_names(sorted), ['Dobermann', 'Épagneul breton', 'Teckel']);
    });

    test('leaves the caller list untouched', () {
      final source = [_race('Teckel'), _race('Beagle')];

      PetRaceOrder.sorted(source);

      expect(_names(source), ['Teckel', 'Beagle']);
    });

    test('takes an empty list', () {
      expect(PetRaceOrder.sorted(const []), isEmpty);
    });
  });
}

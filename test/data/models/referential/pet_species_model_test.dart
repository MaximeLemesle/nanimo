import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';

void main() {
  group('PetSpeciesModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_pet_species': 'species-1',
        'species_name': 'Chien',
        'weight_unit': 'kg',
        'icon_key': 'dog',
      };

      final model = PetSpeciesModel.fromJson(json);

      expect(model.petSpeciesId, 'species-1');
      expect(model.speciesName, 'Chien');
      expect(model.weightUnit, WeightUnit.kg);
      expect(model.iconKey, 'dog');
    });

    test('parses gram weight unit and defaults unknown to kg', () {
      PetSpeciesModel build(String unit) => PetSpeciesModel.fromJson({
            'id_pet_species': 'species-1',
            'species_name': 'Hamster',
            'weight_unit': unit,
            'icon_key': 'hamster',
          });

      expect(build('g').weightUnit, WeightUnit.g);
      expect(build('kg').weightUnit, WeightUnit.kg);
      expect(build('garbage').weightUnit, WeightUnit.kg);
    });
  });

  group('PetSpeciesModel.toJson', () {
    test('round-trips through fromJson for each unit', () {
      for (final unit in WeightUnit.values) {
        final original = PetSpeciesModel(
          petSpeciesId: 'species-1',
          speciesName: 'Chien',
          weightUnit: unit,
          iconKey: 'dog',
        );

        final roundTripped = PetSpeciesModel.fromJson(original.toJson());

        expect(roundTripped.petSpeciesId, original.petSpeciesId);
        expect(roundTripped.speciesName, original.speciesName);
        expect(roundTripped.weightUnit, original.weightUnit);
        expect(roundTripped.iconKey, original.iconKey);
      }
    });
  });
}

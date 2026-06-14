import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';

void main() {
  group('PetRaceModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_pet_race': 'race-1',
        'pet_race_name': 'Labrador',
        'pet_species_id': 'species-1',
      };

      final model = PetRaceModel.fromJson(json);

      expect(model.petRaceId, 'race-1');
      expect(model.raceName, 'Labrador');
      expect(model.petSpeciesId, 'species-1');
    });

    test('toJson round-trips through fromJson', () {
      const original = PetRaceModel(
        petRaceId: 'race-1',
        raceName: 'Labrador',
        petSpeciesId: 'species-1',
      );

      final roundTripped = PetRaceModel.fromJson(original.toJson());

      expect(roundTripped.petRaceId, original.petRaceId);
      expect(roundTripped.raceName, original.raceName);
      expect(roundTripped.petSpeciesId, original.petSpeciesId);
    });
  });
}

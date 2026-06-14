import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

void main() {
  group('PetModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_pet': 'pet-1',
        'pet_name': 'Rex',
        'birthdate': '2024-05-01',
        'gender': 'male',
        'created_at': '2026-01-01T10:00:00.000Z',
        'pet_race_id': 'race-1',
        'pet_species_id': 'species-1',
      };

      final model = PetModel.fromJson(json);

      expect(model.petId, 'pet-1');
      expect(model.petName, 'Rex');
      expect(model.birthdate, DateTime.parse('2024-05-01'));
      expect(model.gender, Gender.male);
      expect(model.createdAt, DateTime.parse('2026-01-01T10:00:00.000Z'));
      expect(model.petRaceId, 'race-1');
      expect(model.petSpeciesId, 'species-1');
    });

    test('parses female and unknown genders', () {
      PetModel build(String gender) => PetModel.fromJson({
            'id_pet': 'pet-1',
            'pet_name': 'Rex',
            'birthdate': '2024-05-01',
            'gender': gender,
            'created_at': '2026-01-01T10:00:00.000Z',
            'pet_race_id': 'race-1',
            'pet_species_id': 'species-1',
          });

      expect(build('female').gender, Gender.female);
      expect(build('unknown').gender, Gender.unknown);
      expect(build('garbage').gender, Gender.unknown);
    });
  });

  group('PetModel.toJson', () {
    test('round-trips through fromJson for each gender', () {
      for (final gender in Gender.values) {
        final original = PetModel(
          petId: 'pet-1',
          petName: 'Rex',
          birthdate: DateTime.parse('2024-05-01'),
          gender: gender,
          createdAt: DateTime.parse('2026-01-01T10:00:00.000Z'),
          petRaceId: 'race-1',
          petSpeciesId: 'species-1',
        );

        final roundTripped = PetModel.fromJson(original.toJson());

        expect(roundTripped.petId, original.petId);
        expect(roundTripped.petName, original.petName);
        expect(roundTripped.birthdate, original.birthdate);
        expect(roundTripped.gender, original.gender);
        expect(roundTripped.petRaceId, original.petRaceId);
        expect(roundTripped.petSpeciesId, original.petSpeciesId);
      }
    });

    test('serializes birthdate as a date-only string', () {
      final original = PetModel(
        petId: 'pet-1',
        petName: 'Rex',
        birthdate: DateTime.parse('2024-05-01T00:00:00.000Z'),
        gender: Gender.male,
        createdAt: DateTime.parse('2026-01-01T10:00:00.000Z'),
        petRaceId: 'race-1',
        petSpeciesId: 'species-1',
      );

      expect(original.toJson()['birthdate'], '2024-05-01');
    });
  });
}

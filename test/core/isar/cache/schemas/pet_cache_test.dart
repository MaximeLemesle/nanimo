import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';

void main() {
  group('PetCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_pet': 'pet-uuid',
        'pet_name': 'Buddy',
        'birthdate': '2020-03-15',
        'gender': 'male',
        'pet_race_id': 'race-uuid',
        'pet_species_id': 'species-uuid',
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.petId, 'pet-uuid');
      expect(cache.petName, 'Buddy');
      expect(cache.birthdate, DateTime.parse('2020-03-15'));
      expect(cache.gender, 'male');
      expect(cache.petRaceId, 'race-uuid');
      expect(cache.petSpeciesId, 'species-uuid');
      expect(cache.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
    });

    test('handles null optional fields', () {
      final json = {
        'id_pet': 'pet-uuid',
        'pet_name': 'Mimi',
        'birthdate': null,
        'gender': 'unknown',
        'pet_race_id': null,
        'pet_species_id': null,
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.birthdate, isNull);
      expect(cache.petRaceId, isNull);
      expect(cache.petSpeciesId, isNull);
    });
  });
}

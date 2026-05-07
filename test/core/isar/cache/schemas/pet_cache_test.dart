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
        'id_race': 'race-uuid',
        'id_species': 'species-uuid',
        'id_icon': 'icon-uuid',
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.idPet, 'pet-uuid');
      expect(cache.petName, 'Buddy');
      expect(cache.birthdate, DateTime.parse('2020-03-15'));
      expect(cache.gender, 'male');
      expect(cache.idRace, 'race-uuid');
      expect(cache.idSpecies, 'species-uuid');
      expect(cache.idIcon, 'icon-uuid');
      expect(cache.createdAt, DateTime.parse('2024-01-01T10:00:00.000Z'));
    });

    test('handles null optional fields', () {
      final json = {
        'id_pet': 'pet-uuid',
        'pet_name': 'Mimi',
        'birthdate': null,
        'gender': 'unknown',
        'id_race': null,
        'id_species': null,
        'id_icon': null,
        'created_at': '2024-01-01T10:00:00.000Z',
      };

      final cache = PetCache.fromJson(json);

      expect(cache.birthdate, isNull);
      expect(cache.idRace, isNull);
      expect(cache.idSpecies, isNull);
      expect(cache.idIcon, isNull);
    });
  });
}

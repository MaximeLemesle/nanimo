import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';

void main() {
  group('HealthDiaryCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary': 'hd-uuid',
        'is_sterilized': true,
        'is_chipped': true,
        'chip_number': '985141001234567',
        'last_deworming_at': '2024-03-01T00:00:00.000Z',
        'last_vet_appointment': '2024-05-10T00:00:00.000Z',
        'id_pet': 'pet-uuid',
      };

      final cache = HealthDiaryCache.fromJson(json);

      expect(cache.idHealthDiary, 'hd-uuid');
      expect(cache.isSterilized, true);
      expect(cache.isChipped, true);
      expect(cache.chipNumber, '985141001234567');
      expect(cache.lastDewormingAt, DateTime.parse('2024-03-01T00:00:00.000Z'));
      expect(cache.lastVetAppointment, DateTime.parse('2024-05-10T00:00:00.000Z'));
      expect(cache.idPet, 'pet-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_health_diary': 'hd-uuid',
        'is_sterilized': false,
        'is_chipped': false,
        'chip_number': null,
        'last_deworming_at': null,
        'last_vet_appointment': null,
        'id_pet': 'pet-uuid',
      };

      final cache = HealthDiaryCache.fromJson(json);

      expect(cache.chipNumber, isNull);
      expect(cache.lastDewormingAt, isNull);
      expect(cache.lastVetAppointment, isNull);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

void main() {
  group('WeightLogCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary_weight_log': 'wl-uuid',
        'weight': 5.2,
        'logged_at': '2024-06-15T09:30:00.000Z',
        'pet_id': 'pet-uuid',
      };

      final cache = WeightLogCache.fromJson(json);

      expect(cache.healthDiaryWeightLogId, 'wl-uuid');
      expect(cache.weight, 5.2);
      expect(cache.loggedAt, DateTime.parse('2024-06-15T09:30:00.000Z'));
      expect(cache.petId, 'pet-uuid');
    });

    test('casts weight from int to double when Supabase returns int', () {
      final json = {
        'id_health_diary_weight_log': 'wl-uuid',
        'weight': 5,
        'logged_at': '2024-06-15T09:30:00.000Z',
        'pet_id': 'pet-uuid',
      };

      final cache = WeightLogCache.fromJson(json);

      expect(cache.weight, 5.0);
      expect(cache.weight, isA<double>());
    });
  });
}

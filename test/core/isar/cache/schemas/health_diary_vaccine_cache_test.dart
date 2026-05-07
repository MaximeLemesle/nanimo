import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';

void main() {
  group('HealthDiaryVaccineCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary_vaccine': 'vax-uuid',
        'vaccine_name': 'Rabies',
        'last_date': '2024-01-15',
        'next_date': '2025-01-15',
        'recurrence': 365,
        'dose_number': 2,
        'total_dose_number': 3,
        'id_health_diary': 'hd-uuid',
      };

      final cache = HealthDiaryVaccineCache.fromJson(json);

      expect(cache.idHealthDiaryVaccine, 'vax-uuid');
      expect(cache.vaccineName, 'Rabies');
      expect(cache.lastDate, DateTime.parse('2024-01-15'));
      expect(cache.nextDate, DateTime.parse('2025-01-15'));
      expect(cache.recurrence, 365);
      expect(cache.doseNumber, 2);
      expect(cache.totalDoseNumber, 3);
      expect(cache.idHealthDiary, 'hd-uuid');
    });

    test('handles null optional fields', () {
      final json = {
        'id_health_diary_vaccine': 'vax-uuid',
        'vaccine_name': 'Unknown',
        'last_date': null,
        'next_date': null,
        'recurrence': null,
        'dose_number': null,
        'total_dose_number': null,
        'id_health_diary': 'hd-uuid',
      };

      final cache = HealthDiaryVaccineCache.fromJson(json);

      expect(cache.lastDate, isNull);
      expect(cache.nextDate, isNull);
      expect(cache.recurrence, isNull);
    });
  });
}

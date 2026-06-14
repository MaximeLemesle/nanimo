import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';

void main() {
  group('HealthDiaryVaccineModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_health_diary_vaccine': 'vac-1',
        'vaccine_name': 'Rage',
        'last_date': '2026-01-01T00:00:00.000Z',
        'next_date': '2027-01-01T00:00:00.000Z',
        'recurrence': 365,
        'dose_number': 1,
        'total_dose_number': 2,
        'health_diary_id': 'hd-1',
      };

      final model = HealthDiaryVaccineModel.fromJson(json);

      expect(model.healthDiaryVaccineId, 'vac-1');
      expect(model.vaccineName, 'Rage');
      expect(model.lastDate, DateTime.parse('2026-01-01T00:00:00.000Z'));
      expect(model.nextDate, DateTime.parse('2027-01-01T00:00:00.000Z'));
      expect(model.recurrence, 365);
      expect(model.doseNumber, 1);
      expect(model.totalDoseNumber, 2);
      expect(model.healthDiaryId, 'hd-1');
    });

    test('toJson round-trips through fromJson', () {
      final original = HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'vac-1',
        vaccineName: 'Rage',
        lastDate: DateTime.parse('2026-01-01T00:00:00.000Z'),
        nextDate: DateTime.parse('2027-01-01T00:00:00.000Z'),
        recurrence: 365,
        doseNumber: 1,
        totalDoseNumber: 2,
        healthDiaryId: 'hd-1',
      );

      final roundTripped = HealthDiaryVaccineModel.fromJson(original.toJson());

      expect(roundTripped.healthDiaryVaccineId, original.healthDiaryVaccineId);
      expect(roundTripped.vaccineName, original.vaccineName);
      expect(roundTripped.lastDate, original.lastDate);
      expect(roundTripped.nextDate, original.nextDate);
      expect(roundTripped.recurrence, original.recurrence);
      expect(roundTripped.doseNumber, original.doseNumber);
      expect(roundTripped.totalDoseNumber, original.totalDoseNumber);
      expect(roundTripped.healthDiaryId, original.healthDiaryId);
    });
  });
}

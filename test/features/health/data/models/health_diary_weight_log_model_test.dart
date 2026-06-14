import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';

void main() {
  group('HealthDiaryWeightLogModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_health_diary_weight_log': 'wl-1',
        'weight': 4.2,
        'logged_at': '2026-03-01T08:00:00.000Z',
        'pet_id': 'pet-1',
      };

      final model = HealthDiaryWeightLogModel.fromJson(json);

      expect(model.healthDiaryWeightLogId, 'wl-1');
      expect(model.weight, 4.2);
      expect(model.loggedAt, DateTime.parse('2026-03-01T08:00:00.000Z'));
      expect(model.petId, 'pet-1');
    });

    test('fromJson coerces integer weight to double', () {
      final json = {
        'id_health_diary_weight_log': 'wl-2',
        'weight': 5,
        'logged_at': '2026-03-01T08:00:00.000Z',
        'pet_id': 'pet-1',
      };

      final model = HealthDiaryWeightLogModel.fromJson(json);

      expect(model.weight, 5.0);
      expect(model.weight, isA<double>());
    });

    test('toJson round-trips through fromJson', () {
      final original = HealthDiaryWeightLogModel(
        healthDiaryWeightLogId: 'wl-1',
        weight: 4.2,
        loggedAt: DateTime.parse('2026-03-01T08:00:00.000Z'),
        petId: 'pet-1',
      );

      final roundTripped = HealthDiaryWeightLogModel.fromJson(original.toJson());

      expect(roundTripped.healthDiaryWeightLogId,
          original.healthDiaryWeightLogId);
      expect(roundTripped.weight, original.weight);
      expect(roundTripped.loggedAt, original.loggedAt);
      expect(roundTripped.petId, original.petId);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';

void main() {
  group('HealthDiaryModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_health_diary': 'hd-1',
        'is_sterilized': true,
        'is_chipped': true,
        'chip_number': '250269812345678',
        'last_deworming_at': '2026-01-01T00:00:00.000Z',
        'last_vet_appointment': '2026-02-01T00:00:00.000Z',
        'pet_id': 'pet-1',
      };

      final model = HealthDiaryModel.fromJson(json);

      expect(model.healthDiaryId, 'hd-1');
      expect(model.isSterilized, true);
      expect(model.isChipped, true);
      expect(model.chipNumber, '250269812345678');
      expect(model.lastDeworming, DateTime.parse('2026-01-01T00:00:00.000Z'));
      expect(
          model.lastVetAppointment, DateTime.parse('2026-02-01T00:00:00.000Z'));
      expect(model.petId, 'pet-1');
    });

    test('handles null optional fields', () {
      final json = {
        'id_health_diary': 'hd-2',
        'is_sterilized': null,
        'is_chipped': null,
        'chip_number': null,
        'last_deworming_at': null,
        'last_vet_appointment': null,
        'pet_id': 'pet-2',
      };

      final model = HealthDiaryModel.fromJson(json);

      expect(model.isSterilized, isNull);
      expect(model.isChipped, isNull);
      expect(model.chipNumber, isNull);
      expect(model.lastDeworming, isNull);
      expect(model.lastVetAppointment, isNull);
    });
  });

  group('HealthDiaryModel.toJson', () {
    test('round-trips through fromJson', () {
      final original = HealthDiaryModel(
        healthDiaryId: 'hd-1',
        petId: 'pet-1',
        isSterilized: true,
        isChipped: false,
        chipNumber: '250269812345678',
        lastDeworming: DateTime.parse('2026-01-01T00:00:00.000Z'),
        lastVetAppointment: DateTime.parse('2026-02-01T00:00:00.000Z'),
      );

      final roundTripped = HealthDiaryModel.fromJson(original.toJson());

      expect(roundTripped.healthDiaryId, original.healthDiaryId);
      expect(roundTripped.petId, original.petId);
      expect(roundTripped.isSterilized, original.isSterilized);
      expect(roundTripped.isChipped, original.isChipped);
      expect(roundTripped.chipNumber, original.chipNumber);
      expect(roundTripped.lastDeworming, original.lastDeworming);
      expect(roundTripped.lastVetAppointment, original.lastVetAppointment);
    });
  });
}

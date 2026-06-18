import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';

void main() {
  group('VetVisitModel', () {
    test('fromJson maps all fields correctly', () {
      final json = {
        'id_vet_visit': 'vv-1',
        'title': 'Bilan annuel',
        'visited_at': '2026-01-14T00:00:00.000Z',
        'vet_name': 'Dr.Martin',
        'clinic_name': 'Clinique des Pins',
        'pet_id': 'pet-1',
      };

      final model = VetVisitModel.fromJson(json);

      expect(model.vetVisitId, 'vv-1');
      expect(model.title, 'Bilan annuel');
      expect(model.visitedAt, DateTime.parse('2026-01-14T00:00:00.000Z'));
      expect(model.vetName, 'Dr.Martin');
      expect(model.clinicName, 'Clinique des Pins');
      expect(model.petId, 'pet-1');
    });

    test('fromJson keeps optional fields null when absent', () {
      final json = {
        'id_vet_visit': 'vv-2',
        'title': 'Vaccination',
        'visited_at': '2026-02-01T00:00:00.000Z',
        'vet_name': null,
        'clinic_name': null,
        'pet_id': 'pet-1',
      };

      final model = VetVisitModel.fromJson(json);

      expect(model.vetName, isNull);
      expect(model.clinicName, isNull);
    });

    test('toJson round-trips through fromJson', () {
      final original = VetVisitModel(
        vetVisitId: 'vv-1',
        title: 'Bilan annuel',
        visitedAt: DateTime.parse('2026-01-14T00:00:00.000Z'),
        vetName: 'Dr.Martin',
        clinicName: 'Clinique des Pins',
        petId: 'pet-1',
      );

      final roundTripped = VetVisitModel.fromJson(original.toJson());

      expect(roundTripped.vetVisitId, original.vetVisitId);
      expect(roundTripped.title, original.title);
      expect(roundTripped.visitedAt, original.visitedAt);
      expect(roundTripped.vetName, original.vetName);
      expect(roundTripped.clinicName, original.clinicName);
      expect(roundTripped.petId, original.petId);
    });
  });
}

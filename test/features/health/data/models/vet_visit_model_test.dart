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
        visitedAt: DateTime(2026, 1, 14),
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

    test('fromJson keeps the time from visit_at only when has_time is set', () {
      final timed = VetVisitModel.fromJson({
        'id_vet_visit': 'vv-3',
        'title': 'Contrôle',
        'visited_at': '2026-11-25',
        'visit_at': '2026-11-25T13:30:00+00:00',
        'has_time': true,
        'pet_id': 'pet-1',
        'reason': 'Toux',
        'report': 'RAS',
        'document_count': 2,
      });
      final dateOnly = VetVisitModel.fromJson({
        'id_vet_visit': 'vv-4',
        'title': 'Contrôle',
        'visited_at': '2026-11-25',
        'visit_at': '2026-11-24T23:00:00+00:00',
        'has_time': false,
        'pet_id': 'pet-1',
      });

      expect(timed.visitedAt, DateTime.parse('2026-11-25T13:30:00Z').toLocal());
      expect(timed.hasTime, isTrue);
      expect(timed.reason, 'Toux');
      expect(timed.report, 'RAS');
      expect(timed.documentCount, 2);
      expect(dateOnly.visitedAt, DateTime(2026, 11, 25));
      expect(dateOnly.hasTime, isFalse);
      expect(dateOnly.documentCount, 0);
    });

    test('toJson sends the date for old clients and the instant for new ones', () {
      final json = VetVisitModel(
        vetVisitId: 'vv-5',
        title: 'Vaccin',
        visitedAt: DateTime(2026, 3, 4, 9, 15),
        hasTime: true,
        petId: 'pet-1',
        documentCount: 3,
      ).toJson();

      expect(json['visited_at'], '2026-03-04');
      expect(json['visit_at'], DateTime(2026, 3, 4, 9, 15).toUtc().toIso8601String());
      expect(json['has_time'], isTrue);
      expect(json.containsKey('document_count'), isFalse);
    });
  });

  group('VetVisitModel state', () {
    final now = DateTime(2026, 11, 10, 12);
    VetVisitModel visit(DateTime at, {bool hasTime = false, String? report, int documentCount = 0}) => VetVisitModel(
          vetVisitId: 'vv',
          title: 'Contrôle',
          visitedAt: at,
          hasTime: hasTime,
          petId: 'pet-1',
          report: report,
          documentCount: documentCount,
        );

    test('a visit later today is upcoming with a time, and all day without one', () {
      expect(visit(DateTime(2026, 11, 10, 15), hasTime: true).isUpcoming(now), isTrue);
      expect(visit(DateTime(2026, 11, 10, 9), hasTime: true).isUpcoming(now), isFalse);
      expect(visit(DateTime(2026, 11, 10)).isUpcoming(now), isTrue);
      expect(visit(DateTime(2026, 11, 9)).isUpcoming(now), isFalse);
    });

    test('a report or a document completes it, blank text does not', () {
      expect(visit(DateTime(2026, 11, 9), report: '  ').isCompleted, isFalse);
      expect(visit(DateTime(2026, 11, 9), report: 'RAS').isCompleted, isTrue);
      expect(visit(DateTime(2026, 11, 9), documentCount: 1).isCompleted, isTrue);
    });

    test('« À compléter » lasts 7 days after the visit, then goes', () {
      expect(visit(DateTime(2026, 11, 9)).needsCompletion(now), isTrue);
      expect(visit(DateTime(2026, 11, 3)).needsCompletion(now), isTrue);
      expect(visit(DateTime(2026, 11, 2)).needsCompletion(now), isFalse);
      expect(visit(DateTime(2026, 11, 9), report: 'RAS').needsCompletion(now), isFalse);
      expect(visit(DateTime(2026, 11, 12)).needsCompletion(now), isFalse);
    });

    test('copyWith clears an optional field through its callback', () {
      final filled = visit(DateTime(2026, 11, 9), report: 'RAS');

      expect(filled.copyWith(report: () => null).report, isNull);
      expect(filled.copyWith(title: 'Autre').report, 'RAS');
    });
  });
}

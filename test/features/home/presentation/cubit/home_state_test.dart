import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/utils/vaccine_status.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

final _now = DateTime(2026, 7, 8, 14);

final _milo = PetModel(
  petId: 'p1',
  petName: 'Milo',
  birthdate: DateTime(2024, 6, 15),
  gender: Gender.female,
  createdAt: DateTime(2026, 6, 10),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

final _nala = PetModel(
  petId: 'p2',
  petName: 'Nala',
  birthdate: DateTime(2022, 3, 2),
  gender: Gender.female,
  createdAt: DateTime(2026, 6, 10),
  petRaceId: 'r2',
  petSpeciesId: 's2',
);

EventModel _event(String id, DateTime entryDate) => EventModel(
      eventId: id,
      title: 'Souvenir $id',
      entryDate: entryDate,
      eventTypeId: 't1',
    );

HealthDiaryVaccineModel _vaccine(String id, DateTime nextDate,
        {String diaryId = 'd1'}) =>
    HealthDiaryVaccineModel(
      healthDiaryVaccineId: id,
      vaccineName: 'Vaccin $id',
      lastDate: DateTime(2025, 1, 1),
      nextDate: nextDate,
      recurrence: 365,
      doseNumber: 1,
      totalDoseNumber: 1,
      healthDiaryId: diaryId,
    );

void main() {
  group('weekEvents', () {
    test('keeps only events from the last 7 days', () {
      final state = HomeState(events: [
        _event('today', _now.subtract(const Duration(hours: 2))),
        _event('threeDays', _now.subtract(const Duration(days: 3))),
        _event('eightDays', _now.subtract(const Duration(days: 8))),
        _event('future', _now.add(const Duration(days: 1))),
      ]);

      final week = state.weekEvents(now: _now);

      expect(week.map((e) => e.eventId), ['today', 'threeDays']);
    });

    test('ignores events without an entry date', () {
      final state = HomeState(events: [
        const EventModel(eventId: 'e1', title: 'Sans date', eventTypeId: 't1'),
      ]);

      expect(state.weekEvents(now: _now), isEmpty);
    });

    test('weekActiveDays exposes the weekdays covered', () {
      // 2026-07-08 is a Wednesday; 3 days before is a Sunday.
      final state = HomeState(events: [
        _event('today', _now.subtract(const Duration(hours: 2))),
        _event('sunday', _now.subtract(const Duration(days: 3))),
      ]);

      expect(
        state.weekActiveDays(now: _now),
        {DateTime.wednesday, DateTime.sunday},
      );
    });
  });

  group('anniversaryEvent', () {
    test('returns the most recent event on the same day and month', () {
      final state = HomeState(events: [
        _event('twoYears', DateTime(2024, 7, 8, 10)),
        _event('oneYear', DateTime(2025, 7, 8, 16)),
        _event('otherDay', DateTime(2025, 7, 9)),
      ]);

      final memory = state.anniversaryEvent(now: _now);

      expect(memory?.eventId, 'oneYear');
      expect(state.yearsAgo(memory!, now: _now), 1);
    });

    test('ignores events from the current year', () {
      final state = HomeState(events: [
        _event('thisMorning', DateTime(2026, 7, 8, 9)),
      ]);

      expect(state.anniversaryEvent(now: _now), isNull);
    });

    test('returns null when nothing matches', () {
      final state = HomeState(events: [
        _event('lastWeek', _now.subtract(const Duration(days: 6))),
      ]);

      expect(state.anniversaryEvent(now: _now), isNull);
    });
  });

  group('vaccineAlerts', () {
    final diaries = [
      const HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1'),
      const HealthDiaryModel(healthDiaryId: 'd2', petId: 'p2'),
    ];

    test('keeps overdue and soon vaccines sorted by urgency', () {
      final state = HomeState(
        pets: [_milo, _nala],
        diaries: diaries,
        vaccines: [
          _vaccine('ok', _now.add(const Duration(days: 90))),
          _vaccine('soon', _now.add(const Duration(days: 10)), diaryId: 'd2'),
          _vaccine('late', _now.subtract(const Duration(days: 12))),
        ],
      );

      final alerts = state.vaccineAlerts(now: _now);

      expect(alerts.map((a) => a.vaccine.healthDiaryVaccineId),
          ['late', 'soon']);
      expect(alerts.first.status, VaccineStatus.overdue);
      expect(alerts.first.pet?.petName, 'Milo');
      expect(alerts.last.status, VaccineStatus.soon);
      expect(alerts.last.pet?.petName, 'Nala');
    });

    test('vaccineStatusByPet keeps the worst status per pet', () {
      final state = HomeState(
        pets: [_milo, _nala],
        diaries: diaries,
        vaccines: [
          _vaccine('soon', _now.add(const Duration(days: 10))),
          _vaccine('late', _now.subtract(const Duration(days: 2))),
          _vaccine('ok', _now.add(const Duration(days: 90)), diaryId: 'd2'),
        ],
      );

      expect(state.vaccineStatusByPet(now: _now), {
        'p1': VaccineStatus.overdue,
        'p2': VaccineStatus.done,
      });
    });

    test('drops a vaccine whose diary belongs to no pet of the account', () {
      final state = HomeState(
        pets: [_milo],
        diaries: [const HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1')],
        vaccines: [
          _vaccine('mine', _now.subtract(const Duration(days: 2))),
          _vaccine('foreign', _now.subtract(const Duration(days: 3)),
              diaryId: 'unknown'),
        ],
      );

      final alerts = state.vaccineAlerts(now: _now);

      expect(alerts.map((a) => a.vaccine.healthDiaryVaccineId), ['mine']);
      expect(alerts.single.pet, isNotNull);
    });

    test('drops every vaccine when the diaries have not synced yet', () {
      final state = HomeState(
        pets: [_milo],
        vaccines: [_vaccine('late', _now.subtract(const Duration(days: 2)))],
      );

      expect(state.vaccineAlerts(now: _now), isEmpty);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';

final _now = DateTime(2026, 10, 16, 15);

final _saiko = PetModel(
  petId: 'p1',
  petName: 'Saïko',
  birthdate: DateTime(2023, 3, 2),
  gender: Gender.male,
  createdAt: DateTime(2026, 6, 10),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _diary = HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1');

HealthDiaryVaccineModel _vaccine(String id, DateTime? next, {String diaryId = 'd1'}) => HealthDiaryVaccineModel(
      healthDiaryVaccineId: id,
      vaccineName: 'CHPPiL',
      nextDate: next,
      recurrence: 0,
      doseNumber: 1,
      totalDoseNumber: 1,
      healthDiaryId: diaryId,
    );

VetVisitModel _visit(String id, DateTime at, {String petId = 'p1'}) =>
    VetVisitModel(vetVisitId: id, title: 'Contrôle annuel', visitedAt: at, petId: petId);

List<PlannedReminder> _plan({
  List<HealthDiaryVaccineModel> vaccines = const [],
  List<VetVisitModel> visits = const [],
  NotificationPrefsModel prefs = NotificationPrefsModel.defaults,
}) =>
    ReminderPlanner.plan(
      pets: [_saiko],
      diaries: const [_diary],
      vaccines: vaccines,
      vetVisits: visits,
      prefs: prefs,
      now: _now,
    );

void main() {
  test('a vaccine due on 12/11 rings on 05/11 and 11/11 at 10:00', () {
    final plan = _plan(vaccines: [_vaccine('v1', DateTime(2026, 11, 12))]);

    expect(plan.map((r) => r.when), [DateTime(2026, 11, 5, 10), DateTime(2026, 11, 11, 10)]);
    expect(plan.first.body, 'Rappel CHPPiL de Saïko dans 7 jours');
    expect(plan.last.body, 'Rappel CHPPiL de Saïko demain');
    expect(plan.first.kind, ReminderKind.vaccine);
    expect(plan.first.petId, 'p1');
  });

  test('a vet visit rings the day before at 10:00', () {
    final plan = _plan(visits: [_visit('w1', DateTime(2026, 10, 20, 17, 30))]);

    expect(plan.single.when, DateTime(2026, 10, 19, 10));
    expect(plan.single.body, 'Contrôle annuel pour Saïko demain');
  });

  test('nothing is planned in the past', () {
    final plan = _plan(
      vaccines: [_vaccine('late', DateTime(2026, 10, 1)), _vaccine('soon', DateTime(2026, 10, 19))],
      visits: [_visit('gone', DateTime(2026, 10, 10))],
    );

    expect(plan.map((r) => r.key), ['vaccine:soon:1']);
  });

  test('a vaccine without a next booster, or of an unknown animal, is skipped', () {
    final plan = _plan(vaccines: [
      _vaccine('unknown', null),
      _vaccine('foreign', DateTime(2026, 12, 1), diaryId: 'other'),
    ]);

    expect(plan, isEmpty);
  });

  test('the settings switches drive what is planned', () {
    final vaccines = [_vaccine('v1', DateTime(2026, 12, 1))];
    final visits = [_visit('w1', DateTime(2026, 12, 1))];

    expect(_plan(vaccines: vaccines, visits: visits, prefs: const NotificationPrefsModel(pushEnabled: false)), isEmpty);
    expect(
      _plan(vaccines: vaccines, visits: visits, prefs: const NotificationPrefsModel(vaccineReminders: false)).map((r) => r.kind).toSet(),
      {ReminderKind.vetVisit},
    );
    expect(
      _plan(vaccines: vaccines, visits: visits, prefs: const NotificationPrefsModel(vetReminders: false)).map((r) => r.kind).toSet(),
      {ReminderKind.vaccine},
    );
  });

  test('keeps the nearest when there are more than iOS can hold', () {
    final vaccines = [for (var i = 0; i < 40; i++) _vaccine('v$i', DateTime(2027, 1, 1).add(Duration(days: i)))];
    final plan = _plan(vaccines: vaccines);

    expect(plan, hasLength(ReminderPlanner.maxPending));
    expect(plan.first.key, 'vaccine:v0:7');
  });

  test('ids are stable and payloads round-trip', () {
    final reminder = _plan(vaccines: [_vaccine('v1', DateTime(2026, 11, 12))]).first;

    expect(reminder.id, notificationIdFor('vaccine:v1:7'));
    expect(reminder.id, greaterThanOrEqualTo(0));
    expect(parseReminderPayload(reminder.payload), (kind: ReminderKind.vaccine, petId: 'p1'));
    expect(parseReminderPayload('garbage'), isNull);
  });
}

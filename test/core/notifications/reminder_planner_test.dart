import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
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

VetVisitModel _visit(String id, DateTime at, {String petId = 'p1', bool? hasTime, String? report}) => VetVisitModel(
      vetVisitId: id,
      title: 'Contrôle annuel',
      visitedAt: at,
      petId: petId,
      hasTime: hasTime ?? (at.hour != 0 || at.minute != 0),
      report: report,
    );

List<PlannedReminder> _plan({
  List<HealthDiaryVaccineModel> vaccines = const [],
  List<VetVisitModel> visits = const [],
  NotificationPrefsModel prefs = const NotificationPrefsModel(anniversaryReminders: false),
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

  test('a visit with a time rings two hours before, then asks for its report at 19:00', () {
    final plan = _plan(visits: [_visit('w1', DateTime(2026, 10, 20, 17, 30))]);

    expect(plan.map((r) => r.when), [DateTime(2026, 10, 20, 15, 30), DateTime(2026, 10, 20, 19)]);
    expect(plan.first.body, "Contrôle annuel pour Saïko aujourd'hui à 17h30");
    expect(plan.first.kind, ReminderKind.vetVisit);
    expect(plan.last.kind, ReminderKind.vetVisitFollowUp);
    expect(plan.last.title, '📎 Complète la visite de Saïko');
    expect(plan.map((r) => r.targetId).toSet(), {'w1'});
  });

  test('a visit without a time rings the evening before at 19:00', () {
    final plan = _plan(visits: [_visit('w1', DateTime(2026, 10, 20))]);

    expect(plan.map((r) => r.when), [DateTime(2026, 10, 19, 19), DateTime(2026, 10, 20, 19)]);
    expect(plan.first.body, 'Contrôle annuel pour Saïko demain');
    expect(plan.first.key, 'vet:w1:1');
  });

  test('a visit booked after 18:00 is followed up an hour after it', () {
    final plan = _plan(visits: [_visit('w1', DateTime(2026, 10, 20, 19, 30))]);

    expect(plan.last.when, DateTime(2026, 10, 20, 20, 30));
  });

  test('a visit already filled in gets no follow-up', () {
    final withReport = _plan(visits: [_visit('w1', DateTime(2026, 10, 20, 17, 30), report: 'RAS')]);
    final withDocument = _plan(visits: [
      _visit('w2', DateTime(2026, 10, 20, 17, 30)).copyWith(documentCount: 1),
    ]);

    expect(withReport.map((r) => r.kind), [ReminderKind.vetVisit]);
    expect(withDocument.map((r) => r.kind), [ReminderKind.vetVisit]);
  });

  // NAN-112: booked in the evening for tomorrow, the call still comes on the day.
  test('a visit booked in the evening for tomorrow morning is still called on the day', () {
    final plan = ReminderPlanner.plan(
      pets: [_saiko],
      diaries: const [_diary],
      vaccines: const [],
      vetVisits: [_visit('w1', DateTime(2026, 10, 17, 10))],
      prefs: const NotificationPrefsModel(anniversaryReminders: false),
      now: DateTime(2026, 10, 16, 19, 32),
    );

    expect(plan.first.when, DateTime(2026, 10, 17, 8));
    expect(plan.first.key, 'vet:w1:0');
  });

  test('the same-day call never rings before 7:00, and at 8:00 at midnight', () {
    expect(ReminderPlanner.sameDayCall(DateTime(2026, 10, 20, 8)), DateTime(2026, 10, 20, 7));
    expect(ReminderPlanner.sameDayCall(DateTime(2026, 10, 20)), DateTime(2026, 10, 20, 8));
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
      {ReminderKind.vetVisit, ReminderKind.vetVisitFollowUp, ReminderKind.birthday},
    );
    expect(
      _plan(vaccines: vaccines, visits: visits, prefs: const NotificationPrefsModel(vetReminders: false, anniversaryReminders: false))
          .map((r) => r.kind)
          .toSet(),
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
    expect(parseReminderPayload(reminder.payload), (kind: ReminderKind.vaccine, petId: 'p1', targetId: null));
    expect(parseReminderPayload('garbage'), isNull);
    expect(parseReminderPayload('vetVisit|p1|w1|extra'), isNull);

    final visit = _plan(visits: [_visit('w1', DateTime(2026, 10, 20, 17, 30))]).last;
    expect(visit.payload, 'vetVisitFollowUp|p1|w1');
    expect(parseReminderPayload(visit.payload), (kind: ReminderKind.vetVisitFollowUp, petId: 'p1', targetId: 'w1'));
  });

  group('birthdays (NAN-007)', () {
    test('rings on the next birthday at 10:00 with the age', () {
      final plan = _plan(prefs: NotificationPrefsModel.defaults);

      expect(plan.single.kind, ReminderKind.birthday);
      expect(plan.single.when, DateTime(2027, 3, 2, 10));
      expect(plan.single.body, "Saïko a 4 ans aujourd'hui. Un souvenir pour marquer le jour ?");
      expect(parseReminderPayload(plan.single.payload)!.kind, ReminderKind.birthday);
    });

    test('later today still counts, earlier today moves to next year', () {
      final birthdate = DateTime(2020, 10, 16);
      expect(ReminderPlanner.nextBirthday(birthdate, now: DateTime(2026, 10, 16, 8)), DateTime(2026, 10, 16, 10));
      expect(ReminderPlanner.nextBirthday(birthdate, now: DateTime(2026, 10, 16, 11)), DateTime(2027, 10, 16, 10));
    });

    test('a 29 February is celebrated on the 28th in common years', () {
      expect(ReminderPlanner.nextBirthday(DateTime(2024, 2, 29), now: _now), DateTime(2027, 2, 28, 10));
    });

    test('says "1 an" and skips an animal not one year old yet', () {
      final baby = PetModel(
        petId: 'p2',
        petName: 'Nala',
        birthdate: DateTime(2026, 9, 1),
        gender: Gender.female,
        createdAt: DateTime(2026, 9, 2),
        petRaceId: 'r1',
        petSpeciesId: 's1',
      );
      final plan = ReminderPlanner.plan(
        pets: [baby],
        diaries: const [],
        vaccines: const [],
        vetVisits: const [],
        prefs: NotificationPrefsModel.defaults,
        now: _now,
      );
      expect(plan.single.body, startsWith('Nala a 1 an aujourd'));

      final newborn = ReminderPlanner.plan(
        pets: [baby],
        diaries: const [],
        vaccines: const [],
        vetVisits: const [],
        prefs: NotificationPrefsModel.defaults,
        now: DateTime(2026, 9, 1, 8),
      );
      expect(newborn, isEmpty);
    });

    test('the anniversaries switch turns them off', () {
      expect(_plan(prefs: const NotificationPrefsModel(anniversaryReminders: false)), isEmpty);
    });
  });

  // NAN-113: the trial screen promises a warning two days before the charge.
  group('trial end', () {
    List<PlannedReminder> planTrial(DateTime? end, {bool push = true}) => ReminderPlanner.plan(
          pets: const [],
          diaries: const [],
          vaccines: const [],
          vetVisits: const [],
          prefs: NotificationPrefsModel(pushEnabled: push, anniversaryReminders: false),
          now: _now,
          trialEndsAt: end,
        );

    test('rings two days before the end at 10:00', () {
      final plan = planTrial(DateTime(2026, 10, 30, 18));

      expect(plan.single.kind, ReminderKind.trialEnd);
      expect(plan.single.when, DateTime(2026, 10, 28, 10));
      expect(plan.single.body, contains('30/10'));
    });

    test('nothing without a running trial, or with notifications off', () {
      expect(planTrial(null), isEmpty);
      expect(planTrial(DateTime(2026, 10, 30), push: false), isEmpty);
    });
  });

  // NAN-116: « Me le rappeler plus tard » rings at the time the owner chose.
  test('a diary follow-up rings at the chosen time and names the pet', () {
    final plan = ReminderPlanner.plan(
      pets: [_saiko],
      diaries: const [],
      vaccines: const [],
      vetVisits: const [],
      prefs: const NotificationPrefsModel(anniversaryReminders: false),
      now: _now,
      followUps: [
        DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vaccines, at: DateTime(2026, 10, 20, 18, 30)),
        DiaryFollowUp(petId: 'unknown', topic: DiaryFollowUpTopic.vetVisits, at: DateTime(2026, 10, 20)),
      ],
    );

    expect(plan.single.kind, ReminderKind.diaryFollowUp);
    expect(plan.single.when, DateTime(2026, 10, 20, 18, 30));
    expect(plan.single.title, '✏️ Complète le carnet de Saïko');
  });

  test('a diary follow-up only obeys the master switch', () {
    List<PlannedReminder> plan(NotificationPrefsModel prefs) => ReminderPlanner.plan(
          pets: [_saiko],
          diaries: const [],
          vaccines: const [],
          vetVisits: const [],
          prefs: prefs,
          now: _now,
          followUps: [
            DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vaccines, at: DateTime(2026, 10, 20)),
            DiaryFollowUp(petId: 'p1', topic: DiaryFollowUpTopic.vetVisits, at: DateTime(2026, 10, 21)),
          ],
        );

    expect(plan(const NotificationPrefsModel(anniversaryReminders: false, vaccineReminders: false, vetReminders: false)), hasLength(2));
    expect(plan(const NotificationPrefsModel(pushEnabled: false)), isEmpty);
  });
  test('a deworming rings 7 days and the day before its due date', () {
    List<PlannedReminder> plan(NotificationPrefsModel prefs) => ReminderPlanner.plan(
          pets: [_saiko],
          diaries: [HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1', lastDeworming: DateTime(2026, 9, 12), dewormingIntervalMonths: 2)],
          vaccines: const [],
          vetVisits: const [],
          prefs: prefs,
          now: _now,
        );

    final reminders = plan(const NotificationPrefsModel(anniversaryReminders: false));
    expect(reminders.map((r) => r.when), [DateTime(2026, 11, 5, 10), DateTime(2026, 11, 11, 10)]);
    expect(reminders.first.kind, ReminderKind.deworming);
    expect(reminders.last.body, 'Vermifuge de Saïko demain');
    expect(plan(const NotificationPrefsModel(anniversaryReminders: false, vaccineReminders: false)), isEmpty);
  });
}

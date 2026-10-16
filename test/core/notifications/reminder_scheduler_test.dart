import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/notifications/reminder_scheduler.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';

import '../analytics/recording_analytics_service.dart';
import 'fake_notification_client.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockAuthCubit extends Mock implements AuthCubit {}

final _now = DateTime(2026, 10, 16, 15);

final _pet = PetModel(
  petId: 'p1',
  petName: 'Saïko',
  birthdate: DateTime(2023, 3, 2),
  gender: Gender.male,
  createdAt: DateTime(2026, 6, 10),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

HealthDiaryVaccineModel _vaccine(String id, DateTime next) => HealthDiaryVaccineModel(
      healthDiaryVaccineId: id,
      vaccineName: 'Rage',
      nextDate: next,
      recurrence: 0,
      doseNumber: 1,
      totalDoseNumber: 1,
      healthDiaryId: 'd1',
    );

void main() {
  late FakeNotificationClient client;
  late StreamController<List<HealthDiaryVaccineModel>> vaccines;
  late StreamController<NotificationPrefsModel> prefs;
  late StreamController<AuthState> auth;
  late _MockAuthCubit authCubit;
  late RecordingAnalyticsService recorder;
  late ReminderScheduler scheduler;

  setUp(() {
    client = FakeNotificationClient();
    vaccines = StreamController.broadcast();
    prefs = StreamController.broadcast();
    auth = StreamController.broadcast();
    recorder = RecordingAnalyticsService();
    analytics = recorder;

    final petRepository = _MockPetRepository();
    final healthRepository = _MockHealthRepository();
    final settingsRepository = _MockSettingsRepository();
    authCubit = _MockAuthCubit();

    when(() => petRepository.watchPets()).thenAnswer((_) => Stream.value([_pet]));
    when(() => healthRepository.watchAllDiaries())
        .thenAnswer((_) => Stream.value(const [HealthDiaryModel(healthDiaryId: 'd1', petId: 'p1')]));
    when(() => healthRepository.watchAllVaccines()).thenAnswer((_) => vaccines.stream);
    when(() => healthRepository.watchAllVetVisits()).thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => settingsRepository.watchNotificationPrefs()).thenAnswer((_) => prefs.stream);
    when(() => authCubit.state).thenReturn(const AuthState.authenticated());
    when(() => authCubit.stream).thenAnswer((_) => auth.stream);

    scheduler = ReminderScheduler(
      client: client,
      petRepository: petRepository,
      healthRepository: healthRepository,
      settingsRepository: settingsRepository,
      now: () => _now,
      debounce: Duration.zero,
    )..bind(authCubit);
  });

  tearDown(() async {
    analytics = const NoopAnalyticsService();
    await scheduler.dispose();
    await vaccines.close();
    await prefs.close();
    await auth.close();
  });

  Future<void> settle() async {
    await pumpEventQueue();
    await Future<void>.delayed(Duration.zero);
    await pumpEventQueue();
  }

  test('schedules from the synced data once every source has spoken', () async {
    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12))]);
    await settle();
    expect(client.pending, isEmpty, reason: 'prefs not loaded yet');

    prefs.add(NotificationPrefsModel.defaults);
    await settle();
    expect(client.pending.map((r) => r.key), ['vaccine:v1:7', 'vaccine:v1:1']);
  });

  test('editing or deleting a vaccine reschedules it', () async {
    prefs.add(NotificationPrefsModel.defaults);
    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12))]);
    await settle();

    vaccines.add([_vaccine('v1', DateTime(2026, 12, 12))]);
    await settle();
    expect(client.pending.first.when, DateTime(2026, 12, 5, 10));

    vaccines.add(const []);
    await settle();
    expect(client.pending, isEmpty);
  });

  test('turning reminders off in the settings cancels them', () async {
    prefs.add(NotificationPrefsModel.defaults);
    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12))]);
    await settle();

    prefs.add(const NotificationPrefsModel(pushEnabled: false));
    await settle();
    expect(client.pending, isEmpty);
  });

  test('logging out cancels everything', () async {
    prefs.add(NotificationPrefsModel.defaults);
    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12))]);
    await settle();

    auth.add(const AuthState.unauthenticated());
    await settle();
    expect(client.cancelAllCount, 1);
    expect(client.pending, isEmpty);
  });

  test('reports a reminder only when it is new, not the baseline', () async {
    prefs.add(NotificationPrefsModel.defaults);
    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12))]);
    await settle();
    expect(recorder.names, isNot(contains(AnalyticsEvents.reminderScheduled)));

    vaccines.add([_vaccine('v1', DateTime(2026, 11, 12)), _vaccine('v2', DateTime(2026, 12, 1))]);
    await settle();
    final scheduled = recorder.events.where((e) => e.name == AnalyticsEvents.reminderScheduled).toList();
    expect(scheduled, hasLength(2));
    expect(scheduled.first.properties[AnalyticsProperties.kind], 'vaccine');
  });
}

import 'dart:async';
import 'dart:developer' as developer;

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
import 'package:nanimo/core/monitoring/error_reporter.dart';
import 'package:nanimo/core/notifications/local_notification_client.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';

/// Keeps the pending local notifications equal to [ReminderPlanner.plan] of
/// the cached data. Rebuilt from scratch on every change: idempotent, and
/// a new phone or a reinstall gets its reminders back from the sync.
class ReminderScheduler {
  final LocalNotificationClient _client;
  final PetRepository _petRepository;
  final HealthRepository _healthRepository;
  final SettingsRepository _settingsRepository;
  final DateTime Function() _now;
  final Duration _debounce;
  final Stream<DateTime?> Function()? _trialEnd;
  final Stream<List<DiaryFollowUp>> Function()? _followUps;

  final List<StreamSubscription<Object?>> _subscriptions = [];
  StreamSubscription<AuthState>? _authSubscription;
  Timer? _timer;

  List<PetModel>? _pets;
  List<HealthDiaryModel>? _diaries;
  List<HealthDiaryVaccineModel>? _vaccines;
  List<VetVisitModel>? _vetVisits;
  NotificationPrefsModel? _prefs;
  DateTime? _trialEndsAt;
  bool _trialLoaded = false;
  List<DiaryFollowUp> _followUpList = const [];

  /// Null until the first sync of a session: that one is a baseline, not news.
  Set<String>? _scheduledKeys;

  ReminderScheduler({
    required LocalNotificationClient client,
    required PetRepository petRepository,
    required HealthRepository healthRepository,
    required SettingsRepository settingsRepository,
    DateTime Function()? now,
    Duration debounce = const Duration(milliseconds: 400),
    Stream<DateTime?> Function()? trialEnd,
    Stream<List<DiaryFollowUp>> Function()? followUps,
  })  : _trialEnd = trialEnd,
        _followUps = followUps,
        _client = client,
        _petRepository = petRepository,
        _healthRepository = healthRepository,
        _settingsRepository = settingsRepository,
        _now = now ?? DateTime.now,
        _debounce = debounce;

  void bind(AuthCubit authCubit) {
    if (authCubit.state.isAuthenticated) _start();
    _authSubscription = authCubit.stream.listen((auth) {
      if (auth.isAuthenticated) {
        _start();
      } else if (auth.isUnauthenticated) {
        _stop();
      }
    });
  }

  void _start() {
    if (_subscriptions.isNotEmpty) return;
    _subscriptions.addAll([
      _petRepository.watchPets().listen((v) => _update(() => _pets = v)),
      _healthRepository.watchAllDiaries().listen((v) => _update(() => _diaries = v)),
      _healthRepository.watchAllVaccines().listen((v) => _update(() => _vaccines = v)),
      _healthRepository.watchAllVetVisits().listen((v) => _update(() => _vetVisits = v)),
      _settingsRepository.watchNotificationPrefs().listen((v) => _update(() => _prefs = v)),
    ]);
    final followUps = _followUps;
    if (followUps != null) {
      _subscriptions.add(followUps().listen((v) => _update(() => _followUpList = v)));
    }
    final trialEnd = _trialEnd;
    if (trialEnd == null) {
      _trialLoaded = true;
    } else {
      _subscriptions.add(trialEnd().listen((v) => _update(() {
            _trialEndsAt = v;
            _trialLoaded = true;
          })));
    }
  }

  Future<void> _stop() async {
    _timer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
    _subscriptions.clear();
    _pets = _diaries = _vaccines = _vetVisits = null;
    _prefs = null;
    _trialEndsAt = null;
    _trialLoaded = false;
    _scheduledKeys = null;
    await _guard('cancel all', _client.cancelAll);
  }

  void _update(void Function() apply) {
    apply();
    _timer?.cancel();
    _timer = Timer(_debounce, sync);
  }

  bool get _ready =>
      _pets != null && _diaries != null && _vaccines != null && _vetVisits != null && _prefs != null && _trialLoaded;

  /// Public for tests; normally driven by the streams.
  Future<void> sync() async {
    if (!_ready) return;
    final planned = ReminderPlanner.plan(
      pets: _pets!,
      diaries: _diaries!,
      vaccines: _vaccines!,
      vetVisits: _vetVisits!,
      prefs: _prefs!,
      now: _now(),
      trialEndsAt: _trialEndsAt,
      followUps: _followUpList,
    );

    await _guard('cancel pending', _client.cancelPending);
    for (final reminder in planned) {
      await _guard('schedule ${reminder.key}', () => _client.schedule(reminder));
    }

    final previous = _scheduledKeys;
    if (previous != null) {
      for (final reminder in planned) {
        if (previous.contains(reminder.key)) continue;
        analytics.capture(
          AnalyticsEvents.reminderScheduled,
          properties: {AnalyticsProperties.kind: reminder.kind.name},
        );
      }
    }
    _scheduledKeys = {for (final reminder in planned) reminder.key};
    errorReporter.addBreadcrumb('${planned.length} reminders scheduled', category: 'notifications');
  }

  Future<void> dispose() async {
    await _authSubscription?.cancel();
    _timer?.cancel();
    for (final subscription in _subscriptions) {
      await subscription.cancel();
    }
  }

  /// A reminder that fails to schedule must never take the app down.
  Future<void> _guard(String action, Future<void> Function() body) async {
    try {
      await body();
    } catch (e, st) {
      developer.log('notifications $action failed', name: 'notifications', error: e, stackTrace: st);
      // NAN-112: a silent failure here is a reminder the owner never gets.
      errorReporter.captureException(e, stackTrace: st, hint: 'notifications $action failed');
    }
  }
}

import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockSubscriptionRestorer extends Mock implements SubscriptionRestorer {}

void main() {
  late _MockAuthRepository authRepository;
  late _MockSettingsRepository settingsRepository;
  late RecordingAnalyticsService recorder;
  late SettingsCubit cubit;

  setUpAll(() => registerFallbackValue(NotificationPrefsModel.defaults));

  setUp(() {
    authRepository = _MockAuthRepository();
    settingsRepository = _MockSettingsRepository();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => authRepository.watchCurrentUser())
        .thenAnswer((_) => const Stream<UserModel?>.empty());
    when(() => settingsRepository.watchNotificationPrefs())
        .thenAnswer((_) => const Stream<NotificationPrefsModel>.empty());
    when(() => settingsRepository.saveNotificationPrefs(any())).thenAnswer((_) async {});
    cubit = SettingsCubit(
      authRepository: authRepository,
      settingsRepository: settingsRepository,
      subscriptionRestorer: _MockSubscriptionRestorer(),
    );
  });

  tearDown(() async {
    analytics = const NoopAnalyticsService();
    await cubit.close();
  });

  test('load reads the stored analytics consent', () async {
    await recorder.setEnabled(false);

    cubit.load();
    await pumpEventQueue();

    expect(cubit.state.analyticsEnabled, isFalse);
  });

  test('opting out sends a last event before the SDK goes silent', () async {
    await cubit.setAnalyticsEnabled(false);

    expect(recorder.names, [AnalyticsEvents.analyticsOptedOut]);
    expect(recorder.lastEnabled, isFalse);
    expect(cubit.state.analyticsEnabled, isFalse);
  });

  test('opting back in sends nothing and re-enables the SDK', () async {
    await cubit.setAnalyticsEnabled(false);
    recorder.events.clear();

    await cubit.setAnalyticsEnabled(true);

    expect(recorder.events, isEmpty);
    expect(recorder.lastEnabled, isTrue);
  });

  test('each changed reminder category is tracked with its new value', () async {
    await cubit.updateNotificationPrefs(
      const NotificationPrefsModel(pushEnabled: false, vetReminders: false),
    );

    expect(
      recorder.events.map((e) => (
            e.properties[AnalyticsProperties.category],
            e.properties[AnalyticsProperties.enabled],
          )),
      [('all', false), ('vet', false)],
    );
    expect(recorder.personProperties[AnalyticsProperties.notificationsEnabled], isFalse);
  });

  test('a deleted account is tracked only once the server confirmed', () async {
    when(() => authRepository.deleteAccount())
        .thenThrow(const RepositoryNetworkException('offline'));
    await cubit.deleteAccount();
    expect(recorder.names, isEmpty);

    when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
    await cubit.deleteAccount();
    expect(recorder.names, [AnalyticsEvents.accountDeleted]);
  });
}

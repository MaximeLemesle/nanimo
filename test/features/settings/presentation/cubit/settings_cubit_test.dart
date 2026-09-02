import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockSubscriptionRestorer extends Mock implements SubscriptionRestorer {}

const _user = UserModel(
  userId: 'user-1',
  userName: 'Maxime',
  mail: 'max@example.com',
  subscriptionStatus: SubscriptionStatus.freemium,
);

void main() {
  late _MockAuthRepository authRepository;
  late _MockSettingsRepository settingsRepository;
  late _MockSubscriptionRestorer subscriptionRestorer;
  late StreamController<UserModel?> userEvents;
  late StreamController<NotificationPrefsModel> prefsEvents;

  setUp(() {
    authRepository = _MockAuthRepository();
    settingsRepository = _MockSettingsRepository();
    subscriptionRestorer = _MockSubscriptionRestorer();
    userEvents = StreamController<UserModel?>();
    prefsEvents = StreamController<NotificationPrefsModel>();

    when(() => authRepository.watchCurrentUser())
        .thenAnswer((_) => userEvents.stream);
    when(() => settingsRepository.watchNotificationPrefs())
        .thenAnswer((_) => prefsEvents.stream);
  });

  tearDown(() async {
    await userEvents.close();
    await prefsEvents.close();
  });

  SettingsCubit createCubit() => SettingsCubit(
        authRepository: authRepository,
        settingsRepository: settingsRepository,
        subscriptionRestorer: subscriptionRestorer,
      )..load();

  test('starts loading then exposes the streamed user and prefs', () async {
    final cubit = createCubit();
    expect(cubit.state.status, SettingsStatus.loading);

    userEvents.add(_user);
    prefsEvents.add(const NotificationPrefsModel(pushEnabled: false));
    await pumpEventQueue();

    expect(cubit.state.status, SettingsStatus.loaded);
    expect(cubit.state.user?.userName, 'Maxime');
    expect(cubit.state.prefs.pushEnabled, isFalse);
    await cubit.close();
  });

  group('updateUserName', () {
    test('trims the name, delegates and returns true', () async {
      when(() => authRepository.updateUserName('Maxime'))
          .thenAnswer((_) async {});
      final cubit = createCubit();

      final success = await cubit.updateUserName('  Maxime  ');

      expect(success, isTrue);
      verify(() => authRepository.updateUserName('Maxime')).called(1);
      expect(cubit.state.errorMessage, isNull);
      await cubit.close();
    });

    test('rejects an empty name without calling the repository', () async {
      final cubit = createCubit();

      final success = await cubit.updateUserName('   ');

      expect(success, isFalse);
      verifyNever(() => authRepository.updateUserName(any()));
      await cubit.close();
    });

    test('surfaces the repository message on failure', () async {
      when(() => authRepository.updateUserName('Maxime')).thenThrow(
        const RepositoryNetworkException('Une connexion internet est requise.'),
      );
      final cubit = createCubit();

      final success = await cubit.updateUserName('Maxime');

      expect(success, isFalse);
      expect(
        cubit.state.errorMessage,
        'Une connexion internet est requise.',
      );
      await cubit.close();
    });
  });

  group('updateNotificationPrefs', () {
    test('emits optimistically and persists', () async {
      const prefs = NotificationPrefsModel(vaccineReminders: false);
      when(() => settingsRepository.saveNotificationPrefs(prefs))
          .thenAnswer((_) async {});
      final cubit = createCubit();

      await cubit.updateNotificationPrefs(prefs);

      expect(cubit.state.prefs, prefs);
      verify(() => settingsRepository.saveNotificationPrefs(prefs)).called(1);
      await cubit.close();
    });

    test('surfaces an error when the local write fails', () async {
      const prefs = NotificationPrefsModel(pushEnabled: false);
      when(() => settingsRepository.saveNotificationPrefs(prefs))
          .thenThrow(Exception('isar'));
      final cubit = createCubit();

      await cubit.updateNotificationPrefs(prefs);

      expect(cubit.state.errorMessage, isNotNull);
      await cubit.close();
    });
  });

  group('deleteAccount', () {
    test('delegates and keeps the deleting flag on success', () async {
      when(() => authRepository.deleteAccount()).thenAnswer((_) async {});
      final cubit = createCubit();

      await cubit.deleteAccount();

      /// The auth stream signs the user out, no local reset needed
      expect(cubit.state.isDeleting, isTrue);
      verify(() => authRepository.deleteAccount()).called(1);
      await cubit.close();
    });

    test('resets the flag and surfaces the message on failure', () async {
      when(() => authRepository.deleteAccount()).thenThrow(
        const RepositoryServerException(
          'Impossible de supprimer votre compte pour le moment.',
        ),
      );
      final cubit = createCubit();

      await cubit.deleteAccount();

      expect(cubit.state.isDeleting, isFalse);
      expect(
        cubit.state.errorMessage,
        'Impossible de supprimer votre compte pour le moment.',
      );
      await cubit.close();
    });
  });

  group('restorePurchases', () {
    test('exposes the restored outcome and drops the busy flag', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer(
        (_) async => const RestoreResult(
          RestoreOutcome.restored,
          SubscriptionRestorer.restoredMessage,
        ),
      );
      final cubit = createCubit();

      await cubit.restorePurchases();

      expect(cubit.state.isRestoring, isFalse);
      expect(cubit.state.restoreResult?.outcome, RestoreOutcome.restored);
      expect(
        cubit.state.restoreResult?.message,
        SubscriptionRestorer.restoredMessage,
      );
      await cubit.close();
    });

    test('exposes the nothing found outcome as a normal answer', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer(
        (_) async => const RestoreResult(
          RestoreOutcome.nothingFound,
          SubscriptionRestorer.nothingFoundMessage,
        ),
      );
      final cubit = createCubit();

      await cubit.restorePurchases();

      expect(cubit.state.restoreResult?.outcome, RestoreOutcome.nothingFound);
      expect(cubit.state.errorMessage, isNull);
      await cubit.close();
    });

    test('exposes the failure outcome with its message', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer(
        (_) async => const RestoreResult(RestoreOutcome.failed, 'Store injoignable.'),
      );
      final cubit = createCubit();

      await cubit.restorePurchases();

      expect(cubit.state.restoreResult?.outcome, RestoreOutcome.failed);
      expect(cubit.state.restoreResult?.message, 'Store injoignable.');
      await cubit.close();
    });

    test('raises the busy flag while the store call is in flight', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const RestoreResult(RestoreOutcome.restored, 'ok');
      });
      final cubit = createCubit();

      final pending = cubit.restorePurchases();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      expect(cubit.state.isRestoring, isTrue);

      await pending;
      expect(cubit.state.isRestoring, isFalse);
      await cubit.close();
    });

    test('ignores a second tap while a restore is running', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 30));
        return const RestoreResult(RestoreOutcome.restored, 'ok');
      });
      final cubit = createCubit();

      final first = cubit.restorePurchases();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await cubit.restorePurchases();
      await first;

      verify(() => subscriptionRestorer.restore()).called(1);
      await cubit.close();
    });

    test('clearRestoreResult empties the last outcome', () async {
      when(() => subscriptionRestorer.restore()).thenAnswer(
        (_) async => const RestoreResult(RestoreOutcome.failed, 'Store injoignable.'),
      );
      final cubit = createCubit();
      await cubit.restorePurchases();
      expect(cubit.state.restoreResult, isNotNull);

      cubit.clearRestoreResult();

      expect(cubit.state.restoreResult, isNull);
      await cubit.close();
    });
  });

  test('clearError removes the current error message', () async {
    when(() => authRepository.updateUserName('Maxime'))
        .thenThrow(const RepositoryNetworkException('offline'));
    final cubit = createCubit();
    await cubit.updateUserName('Maxime');
    expect(cubit.state.errorMessage, isNotNull);

    cubit.clearError();

    expect(cubit.state.errorMessage, isNull);
    await cubit.close();
  });
}

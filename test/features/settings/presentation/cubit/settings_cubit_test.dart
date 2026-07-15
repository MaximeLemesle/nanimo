import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

const _user = UserModel(
  userId: 'user-1',
  userName: 'Maxime',
  mail: 'max@example.com',
  subscriptionStatus: SubscriptionStatus.freemium,
);

void main() {
  late _MockAuthRepository authRepository;
  late _MockSettingsRepository settingsRepository;
  late StreamController<UserModel?> userEvents;
  late StreamController<NotificationPrefsModel> prefsEvents;

  setUp(() {
    authRepository = _MockAuthRepository();
    settingsRepository = _MockSettingsRepository();
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

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/push/push_client.dart';
import 'package:nanimo/core/push/push_token_repository.dart';
import 'package:nanimo/core/push/push_token_sync.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';

class _MockRepository extends Mock implements PushTokenRepository {}

class _MockSettings extends Mock implements SettingsRepository {}

class _MockAuthCubit extends Mock implements AuthCubit {}

class _FakeClient implements PushClient {
  String? currentToken = 'token-1';
  final refreshes = StreamController<String>.broadcast();

  @override
  String get platform => 'ios';

  @override
  Future<String?> token() async => currentToken;

  @override
  Stream<String> get tokenRefreshes => refreshes.stream;
}

void main() {
  late _MockRepository repository;
  late _MockSettings settings;
  late _MockAuthCubit auth;
  late _FakeClient client;
  late StreamController<NotificationPrefsModel> prefs;
  late StreamController<AuthState> authChanges;
  late ValueNotifier<int> permissionChanges;
  late bool granted;
  late PushTokenSync sync;

  setUp(() {
    repository = _MockRepository();
    settings = _MockSettings();
    auth = _MockAuthCubit();
    client = _FakeClient();
    prefs = StreamController.broadcast();
    authChanges = StreamController.broadcast();
    permissionChanges = ValueNotifier(0);
    granted = true;

    when(() => settings.watchNotificationPrefs()).thenAnswer((_) => prefs.stream);
    when(() => auth.state).thenReturn(const AuthState.authenticated());
    when(() => auth.stream).thenAnswer((_) => authChanges.stream);
    when(() => repository.register(
          token: any(named: 'token'),
          platform: any(named: 'platform'),
          articlesEnabled: any(named: 'articlesEnabled'),
        )).thenAnswer((_) async {});
    when(() => repository.delete(any())).thenAnswer((_) async {});

    sync = PushTokenSync(
      client: client,
      repository: repository,
      settingsRepository: settings,
      isPermissionGranted: () async => granted,
      permissionChanges: permissionChanges,
    )..bind(auth);
  });

  Future<void> emitPrefs(NotificationPrefsModel value) async {
    prefs.add(value);
    await pumpEventQueue();
  }

  void verifyRegistered(String token, bool enabled, {int times = 1}) {
    verify(() => repository.register(token: token, platform: 'ios', articlesEnabled: enabled)).called(times);
  }

  test('registers the token once the permission is granted', () async {
    await emitPrefs(NotificationPrefsModel.defaults);

    verifyRegistered('token-1', true);
  });

  test('never registers without the system permission', () async {
    granted = false;

    await emitPrefs(NotificationPrefsModel.defaults);

    verifyNever(() => repository.register(
          token: any(named: 'token'),
          platform: any(named: 'platform'),
          articlesEnabled: any(named: 'articlesEnabled'),
        ));
  });

  test('skips a write identical to the last one', () async {
    await emitPrefs(NotificationPrefsModel.defaults);
    await emitPrefs(NotificationPrefsModel.defaults.copyWith(vetReminders: false));

    verifyRegistered('token-1', true);
  });

  test('the article toggle reaches the server', () async {
    await emitPrefs(NotificationPrefsModel.defaults);
    await emitPrefs(NotificationPrefsModel.defaults.copyWith(newArticles: false));

    verifyRegistered('token-1', false);
  });

  test('the master switch also cuts articles', () async {
    await emitPrefs(NotificationPrefsModel.defaults.copyWith(pushEnabled: false));

    verifyRegistered('token-1', false);
  });

  test('a refreshed token replaces the old one', () async {
    await emitPrefs(NotificationPrefsModel.defaults);
    client.currentToken = 'token-2';
    client.refreshes.add('token-2');
    await pumpEventQueue();

    verifyRegistered('token-2', true);
  });

  test('a permission granted later registers without a new launch', () async {
    granted = false;
    await emitPrefs(NotificationPrefsModel.defaults);
    granted = true;
    permissionChanges.value++;
    await pumpEventQueue();

    verifyRegistered('token-1', true);
  });

  test('a permission withdrawn in the system settings removes the token', () async {
    await emitPrefs(NotificationPrefsModel.defaults);
    granted = false;
    permissionChanges.value++;
    await pumpEventQueue();

    verify(() => repository.delete('token-1')).called(1);
  });

  test('unregister removes the token before sign-out', () async {
    await emitPrefs(NotificationPrefsModel.defaults);

    await sync.unregister();

    verify(() => repository.delete('token-1')).called(1);
  });

  test('a network failure never escapes', () async {
    when(() => repository.register(
          token: any(named: 'token'),
          platform: any(named: 'platform'),
          articlesEnabled: any(named: 'articlesEnabled'),
        )).thenThrow(Exception('offline'));

    await expectLater(sync.sync(), completes);
    await emitPrefs(NotificationPrefsModel.defaults);
  });
}

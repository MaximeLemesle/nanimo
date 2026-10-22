import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSyncService extends Mock implements SyncService {}

void main() {
  late _MockAuthRepository repository;
  late _MockSyncService syncService;
  late StreamController<supabase.AuthState> authEvents;
  late RecordingAnalyticsService recorder;

  setUp(() {
    repository = _MockAuthRepository();
    syncService = _MockSyncService();
    authEvents = StreamController<supabase.AuthState>();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => repository.authStateChanges).thenAnswer((_) => authEvents.stream);
  });

  tearDown(() {
    analytics = const NoopAnalyticsService();
    return authEvents.close();
  });

  AuthCubit createCubit() => AuthCubit(repository: repository, syncService: syncService);

  test('a first Google sign-in counts as an account creation', () async {
    when(() => repository.signInWithGoogle()).thenAnswer((_) async => true);
    final cubit = createCubit();

    await cubit.loginWithGoogle();

    expect(recorder.names, [AnalyticsEvents.accountCreated, AnalyticsEvents.authCompleted]);
    expect(recorder.lastOf(AnalyticsEvents.accountCreated)!.properties[AnalyticsProperties.method], AuthMethod.google);
    await cubit.close();
  });

  test('a returning Apple sign-in is not an account creation', () async {
    when(() => repository.signInWithApple()).thenAnswer((_) async => false);
    final cubit = createCubit();

    await cubit.loginWithApple();

    expect(recorder.names, [AnalyticsEvents.authCompleted]);
    await cubit.close();
  });

  test('a first Apple sign-in counts as an account creation', () async {
    when(() => repository.signInWithApple()).thenAnswer((_) async => true);
    final cubit = createCubit();

    await cubit.loginWithApple();

    expect(recorder.lastOf(AnalyticsEvents.accountCreated)!.properties[AnalyticsProperties.method], AuthMethod.apple);
    await cubit.close();
  });

  test('a completed sign-in records the method on the person', () async {
    when(() => repository.signInWithGoogle()).thenAnswer((_) async => false);
    final cubit = createCubit();

    await cubit.loginWithGoogle();

    expect(recorder.personProperties[AnalyticsProperties.authMethod], AuthMethod.google);
    await cubit.close();
  });

  test('a cancelled SSO sheet is told apart from a real failure', () async {
    when(() => repository.signInWithApple())
        .thenThrow(const RepositoryNetworkException('Connexion Apple annulée.'));
    when(() => repository.signInWithGoogle())
        .thenThrow(const RepositoryNetworkException('Pas de connexion.'));
    final cubit = createCubit();

    await cubit.loginWithApple();
    await cubit.loginWithGoogle();

    expect(
      recorder.events.map((e) => (e.properties[AnalyticsProperties.method], e.properties[AnalyticsProperties.reason])),
      [(AuthMethod.apple, 'cancelled'), (AuthMethod.google, 'network')],
    );
    await cubit.close();
  });

  test('a wrong password is reported by its code, never its message', () async {
    when(() => repository.login(any(), any()))
        .thenThrow(const supabase.AuthException('Invalid login credentials', statusCode: '400'));
    final cubit = createCubit();

    await cubit.login('max@example.com', 'nope');

    final failure = recorder.lastOf(AnalyticsEvents.authFailed)!;
    expect(failure.properties[AnalyticsProperties.reason], 'invalid_login_credentials');
    expect(failure.properties.values, isNot(contains('max@example.com')));
    await cubit.close();
  });

  test('an unexpected auth error keeps its status code only', () async {
    when(() => repository.register(any(), any(), any()))
        .thenThrow(const supabase.AuthException('weird server text', statusCode: '500'));
    final cubit = createCubit();

    await cubit.register('max@example.com', 'secret1', 'Max');

    expect(recorder.lastOf(AnalyticsEvents.authFailed)!.properties[AnalyticsProperties.reason], 'auth_500');
    await cubit.close();
  });

  test('logout is tracked before the session goes away', () async {
    when(() => repository.logout()).thenAnswer((_) async {});
    final cubit = createCubit();

    await cubit.logout();

    expect(recorder.names, [AnalyticsEvents.signedOut]);
    await cubit.close();
  });
}

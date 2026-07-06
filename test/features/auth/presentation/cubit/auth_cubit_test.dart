import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;

import '../../../../helpers/supabase_mocks.dart';

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSyncService extends Mock implements SyncService {}

void main() {
  late _MockAuthRepository repository;
  late _MockSyncService syncService;
  late StreamController<supabase.AuthState> authEvents;

  setUp(() {
    repository = _MockAuthRepository();
    syncService = _MockSyncService();
    authEvents = StreamController<supabase.AuthState>();

    when(() => repository.authStateChanges)
        .thenAnswer((_) => authEvents.stream);
    when(() => syncService.syncCritical()).thenAnswer((_) async {});
    when(() => syncService.clearAllCaches()).thenAnswer((_) async {});
  });

  tearDown(() => authEvents.close());

  AuthCubit createCubit() =>
      AuthCubit(repository: repository, syncService: syncService);

  test('starts in the unknown state', () async {
    final cubit = createCubit();
    expect(cubit.state.isUnknown, isTrue);
    await cubit.close();
  });

  test('runs both sync waves and authenticates on sign-in', () async {
    final cubit = createCubit();

    authEvents.add(
      supabase.AuthState(supabase.AuthChangeEvent.signedIn, MockSession()),
    );
    await pumpEventQueue();

    expect(cubit.state.isAuthenticated, isTrue);
    verify(() => syncService.syncCritical()).called(1);
    verify(() => syncService.syncSecondary()).called(1);
    verifyNever(() => syncService.clearAllCaches());
    await cubit.close();
  });

  test('still authenticates when the critical sync fails', () async {
    when(() => syncService.syncCritical()).thenThrow(Exception('offline'));
    final cubit = createCubit();

    authEvents.add(
      supabase.AuthState(
        supabase.AuthChangeEvent.initialSession,
        MockSession(),
      ),
    );
    await pumpEventQueue();

    expect(cubit.state.isAuthenticated, isTrue);
    await cubit.close();
  });

  test('does not re-sync on a token refresh', () async {
    final cubit = createCubit();

    authEvents.add(
      supabase.AuthState(
        supabase.AuthChangeEvent.tokenRefreshed,
        MockSession(),
      ),
    );
    await pumpEventQueue();

    expect(cubit.state.isAuthenticated, isTrue);
    verifyNever(() => syncService.syncCritical());
    await cubit.close();
  });

  test('clears local caches and emits unauthenticated on sign-out', () async {
    final cubit = createCubit();

    authEvents.add(
      supabase.AuthState(supabase.AuthChangeEvent.signedOut, null),
    );
    await pumpEventQueue();

    expect(cubit.state.isUnauthenticated, isTrue);
    verify(() => syncService.clearAllCaches()).called(1);
    verifyNever(() => syncService.syncCritical());
    await cubit.close();
  });

  test('emits unauthenticated even when cache clearing fails', () async {
    when(() => syncService.clearAllCaches()).thenThrow(Exception('isar'));
    final cubit = createCubit();

    authEvents.add(
      supabase.AuthState(supabase.AuthChangeEvent.signedOut, null),
    );
    await pumpEventQueue();

    expect(cubit.state.isUnauthenticated, isTrue);
    await cubit.close();
  });

  group('resync', () {
    test('re-runs both sync waves when authenticated', () async {
      final cubit = createCubit();
      authEvents.add(
        supabase.AuthState(supabase.AuthChangeEvent.signedIn, MockSession()),
      );
      await pumpEventQueue();
      clearInteractions(syncService);

      await cubit.resync();

      verify(() => syncService.syncCritical()).called(1);
      verify(() => syncService.syncSecondary()).called(1);
      await cubit.close();
    });

    test('is a no-op when signed out', () async {
      final cubit = createCubit();

      await cubit.resync();

      verifyNever(() => syncService.syncCritical());
      verifyNever(() => syncService.syncSecondary());
      await cubit.close();
    });

    test('still authenticated when the resync critical wave fails', () async {
      final cubit = createCubit();
      authEvents.add(
        supabase.AuthState(supabase.AuthChangeEvent.signedIn, MockSession()),
      );
      await pumpEventQueue();
      when(() => syncService.syncCritical()).thenThrow(Exception('offline'));

      await cubit.resync();

      expect(cubit.state.isAuthenticated, isTrue);
      await cubit.close();
    });
  });

  test('login sets isSubmitting while the request is in flight', () async {
    when(() => repository.login('a@b.fr', 'secret'))
        .thenAnswer((_) async {});
    final cubit = createCubit();

    await cubit.login('a@b.fr', 'secret');

    expect(cubit.state.isSubmitting, isTrue);
    expect(cubit.state.errorMessage, isNull);
    await cubit.close();
  });

  test('login maps a known AuthException to a french message', () async {
    when(() => repository.login('a@b.fr', 'bad'))
        .thenThrow(const supabase.AuthException('Invalid login credentials'));
    final cubit = createCubit();

    await cubit.login('a@b.fr', 'bad');

    expect(cubit.state.isSubmitting, isFalse);
    expect(cubit.state.errorMessage, 'Email ou mot de passe incorrect.');
    await cubit.close();
  });

  test('login surfaces a RepositoryNetworkException message', () async {
    when(() => repository.login('a@b.fr', 'secret')).thenThrow(
      const RepositoryNetworkException('Une connexion internet est requise.'),
    );
    final cubit = createCubit();

    await cubit.login('a@b.fr', 'secret');

    expect(cubit.state.errorMessage, 'Une connexion internet est requise.');
    await cubit.close();
  });

  test('register maps a known AuthException to a french message', () async {
    when(() => repository.register('a@b.fr', 'secret'))
        .thenThrow(const supabase.AuthException('User already registered'));
    final cubit = createCubit();

    await cubit.register('a@b.fr', 'secret');

    expect(cubit.state.errorMessage, 'Un compte existe déjà avec cet email.');
    await cubit.close();
  });

  test('loginWithGoogle surfaces repository errors', () async {
    when(() => repository.signInWithGoogle()).thenThrow(
      const RepositoryNetworkException('Connexion Google annulée.'),
    );
    final cubit = createCubit();

    await cubit.loginWithGoogle();

    expect(cubit.state.errorMessage, 'Connexion Google annulée.');
    await cubit.close();
  });

  test('loginWithApple surfaces repository errors', () async {
    when(() => repository.signInWithApple()).thenThrow(
      const RepositoryNetworkException('Connexion Apple annulée.'),
    );
    final cubit = createCubit();

    await cubit.loginWithApple();

    expect(cubit.state.errorMessage, 'Connexion Apple annulée.');
    await cubit.close();
  });

  test('logout delegates to the repository', () async {
    when(() => repository.logout()).thenAnswer((_) async {});
    final cubit = createCubit();

    await cubit.logout();

    verify(() => repository.logout()).called(1);
    await cubit.close();
  });

  test('clearError removes the current error message', () async {
    when(() => repository.login('a@b.fr', 'bad'))
        .thenThrow(const supabase.AuthException('Invalid login credentials'));
    final cubit = createCubit();
    await cubit.login('a@b.fr', 'bad');
    expect(cubit.state.errorMessage, isNotNull);

    cubit.clearError();

    expect(cubit.state.errorMessage, isNull);
    await cubit.close();
  });
}

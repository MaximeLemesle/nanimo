import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late MockGoTrueClient auth;
  late MockUser user;
  late AuthRepository repo;

  setUpAll(registerSupabaseFallbacks);

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    auth = MockGoTrueClient();
    user = MockUser();
    // Minimal auth-state plumbing so the cache-read methods can resolve
    // `currentUserId`. No Supabase data flow is exercised here.
    when(() => supabase.auth).thenReturn(auth);
    repo = AuthRepository(supabase, harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  Future<void> seedUser(UserModel model) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.userCaches.putByUserId(UserCache.fromModel(model));
    });
  }

  UserModel buildUser({String id = 'user-1'}) {
    return UserModel(
      userId: id,
      userName: 'Maxime',
      mail: 'm@example.com',
      subscriptionStatus: SubscriptionStatus.freemium,
      subscriptionConfigId: 'cfg-free',
    );
  }

  group('login', () {
    test('returns normally on success', () async {
      when(() => auth.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenAnswer((_) async => AuthResponse());

      await expectLater(repo.login('m@example.com', 'secret'), completes);
    });

    test('rethrows an AuthException untouched', () async {
      when(() => auth.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(const AuthException('Invalid login credentials'));

      await expectLater(
        repo.login('m@example.com', 'bad'),
        throwsA(isA<AuthException>()),
      );
    });

    test('maps an unexpected error to a network exception', () async {
      when(() => auth.signInWithPassword(
            email: any(named: 'email'),
            password: any(named: 'password'),
          )).thenThrow(Exception('offline'));

      await expectLater(
        repo.login('m@example.com', 'secret'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('register', () {
    test('returns normally on success', () async {
      when(() => auth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => AuthResponse());
      when(() => auth.currentUser).thenReturn(null);

      await expectLater(
        repo.register('m@example.com', 'secret', 'Maxime'),
        completes,
      );
    });

    test('passes the user name in the signUp metadata', () async {
      when(() => auth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => AuthResponse());
      when(() => auth.currentUser).thenReturn(null);

      await repo.register('m@example.com', 'secret', 'Maxime');

      verify(() => auth.signUp(
            email: 'm@example.com',
            password: 'secret',
            data: {'user_name': 'Maxime'},
          )).called(1);
    });

    test('updates the users row and the cache when a session exists',
        () async {
      when(() => auth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          )).thenAnswer((_) async => AuthResponse());
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('u1');

      final qb = MockSupabaseQueryBuilder();
      when(() => supabase.from('users')).thenAnswer((_) => qb);
      when(() => qb.update(any()))
          .thenAnswer((_) => FakePostgrestChain(() => null) as dynamic);
      when(() => qb.select(any())).thenAnswer(
        (_) => FakeSelectChain(() => {
          'id_user': 'u1',
          'user_name': 'Maxime',
          'mail': 'm@example.com',
          'subscription_status': 'freemium',
          'subscription_expires_at': null,
          'id_subscription_config': '1',
        }),
      );

      await repo.register('m@example.com', 'secret', 'Maxime');

      verify(() => qb.update({'user_name': 'Maxime'})).called(1);
      final cached = await harness.isar.userCaches.getByUserId('u1');
      expect(cached?.userName, 'Maxime');
    });

    test('rethrows an AuthException untouched', () async {
      when(() => auth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          )).thenThrow(const AuthException('User already registered'));

      await expectLater(
        repo.register('m@example.com', 'secret', 'Maxime'),
        throwsA(isA<AuthException>()),
      );
    });

    test('maps an unexpected error to a network exception', () async {
      when(() => auth.signUp(
            email: any(named: 'email'),
            password: any(named: 'password'),
            data: any(named: 'data'),
          )).thenThrow(Exception('offline'));

      await expectLater(
        repo.register('m@example.com', 'secret', 'Maxime'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('logout / session getters', () {
    test('logout delegates to Supabase signOut', () async {
      when(() => auth.signOut()).thenAnswer((_) async {});

      await repo.logout();

      verify(() => auth.signOut()).called(1);
    });

    test('currentUserId reflects the signed-in user', () {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-1');

      expect(repo.currentUserId, 'user-1');
    });

    test('currentToken reads the active session access token', () {
      final session = MockSession();
      when(() => auth.currentSession).thenReturn(session);
      when(() => session.accessToken).thenReturn('jwt-123');

      expect(repo.currentToken, 'jwt-123');
    });
  });

  group('watchCurrentUser', () {
    test('emits null when signed out', () async {
      when(() => auth.currentUser).thenReturn(null);

      final emission = await repo.watchCurrentUser().first;
      expect(emission, isNull);
    });

    test('emits the cached user when present', () async {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-1');
      await seedUser(buildUser());

      final emission = await repo.watchCurrentUser().first;
      expect(emission, isNotNull);
      expect(emission!.userId, 'user-1');
      expect(emission.mail, 'm@example.com');
    });

    test('emits null when the cache has no row for the current user',
        () async {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-1');

      final emission = await repo.watchCurrentUser().first;
      expect(emission, isNull);
    });
  });

  group('getCurrentUser', () {
    test('returns null when signed out', () async {
      when(() => auth.currentUser).thenReturn(null);

      expect(await repo.getCurrentUser(), isNull);
    });

    test('returns the cached user when present', () async {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-1');
      await seedUser(buildUser());

      final result = await repo.getCurrentUser();
      expect(result?.userId, 'user-1');
    });

    test('falls back to Supabase and caches when the cache is empty', () async {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-9');
      stubSelect(supabase, 'users', resolver: () => {
            'id_user': 'user-9',
            'user_name': 'Remote',
            'mail': 'remote@example.com',
            'subscription_status': 'free',
            'subscription_expires_at': null,
            'id_subscription_config': 'cfg-free',
          });

      final result = await repo.getCurrentUser();

      expect(result?.userId, 'user-9');
      expect(await harness.isar.userCaches.getByUserId('user-9'), isNotNull);
    });

    test('returns null when the Supabase fallback fails', () async {
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn('user-9');
      when(() => supabase.from(any()))
          .thenThrow(const PostgrestException(message: 'RLS'));

      expect(await repo.getCurrentUser(), isNull);
    });
  });

  group('signInWithGoogle', () {
    test('throws RepositoryNetworkException when Google config is missing',
        () async {
      // Repo built without googleIosClientId/googleWebClientId
      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });

    test('maps a plugin failure to a network exception', () async {
      // With config present the flow reaches the native plugin, which is
      // unavailable in tests and surfaces via the generic catch.
      final configured = AuthRepository(
        supabase,
        harness.isar,
        googleIosClientId: 'ios-id',
        googleWebClientId: 'web-id',
      );

      await expectLater(
        configured.signInWithGoogle(),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('signInWithApple', () {
    test('maps a plugin failure to a network exception', () async {
      // The Apple native plugin is unavailable in tests, so the credential
      // request fails and is mapped by the generic catch.
      await expectLater(
        repo.signInWithApple(),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });
}

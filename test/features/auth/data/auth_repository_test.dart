import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late MockGoTrueClient auth;
  late MockUser user;
  late AuthRepository repo;

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
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/isar/cache/schemas/notification_prefs_cache.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late MockGoTrueClient auth;
  late MockUser user;
  late SettingsRepository repo;

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    auth = MockGoTrueClient();
    user = MockUser();
    when(() => supabase.auth).thenReturn(auth);
    repo = SettingsRepository(supabase, harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  void signIn(String id) {
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.id).thenReturn(id);
  }

  group('watchNotificationPrefs', () {
    test('emits defaults when signed out', () async {
      when(() => auth.currentUser).thenReturn(null);

      final prefs = await repo.watchNotificationPrefs().first;

      expect(prefs, NotificationPrefsModel.defaults);
    });

    test('emits defaults when nothing is stored yet', () async {
      signIn('user-1');

      final prefs = await repo.watchNotificationPrefs().first;

      expect(prefs, NotificationPrefsModel.defaults);
      expect(prefs.pushEnabled, isTrue);
    });

    test('emits the stored prefs for the signed-in user', () async {
      signIn('user-1');
      await harness.isar.writeTxn(() async {
        await harness.isar.notificationPrefsCaches.putByUserId(
          NotificationPrefsCache.fromModel(
            'user-1',
            const NotificationPrefsModel(pushEnabled: false),
          ),
        );
      });

      final prefs = await repo.watchNotificationPrefs().first;

      expect(prefs.pushEnabled, isFalse);
      expect(prefs.vaccineReminders, isTrue);
    });

    test('ignores prefs stored for another user', () async {
      signIn('user-2');
      await harness.isar.writeTxn(() async {
        await harness.isar.notificationPrefsCaches.putByUserId(
          NotificationPrefsCache.fromModel(
            'user-1',
            const NotificationPrefsModel(pushEnabled: false),
          ),
        );
      });

      final prefs = await repo.watchNotificationPrefs().first;

      expect(prefs, NotificationPrefsModel.defaults);
    });
  });

  group('saveNotificationPrefs', () {
    test('persists and overwrites the row for the current user', () async {
      signIn('user-1');

      await repo.saveNotificationPrefs(
        const NotificationPrefsModel(vaccineReminders: false),
      );
      await repo.saveNotificationPrefs(
        const NotificationPrefsModel(
          vaccineReminders: false,
          anniversaryReminders: false,
        ),
      );

      expect(await harness.isar.notificationPrefsCaches.count(), 1);
      final row =
          await harness.isar.notificationPrefsCaches.getByUserId('user-1');
      expect(row?.vaccineReminders, isFalse);
      expect(row?.anniversaryReminders, isFalse);
    });

    test('is a no-op when signed out', () async {
      when(() => auth.currentUser).thenReturn(null);

      await repo.saveNotificationPrefs(NotificationPrefsModel.defaults);

      expect(await harness.isar.notificationPrefsCaches.count(), 0);
    });
  });
}

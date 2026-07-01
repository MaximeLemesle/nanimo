import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late SyncService syncService;

  setUp(() async {
    await harness.setUp();
    syncService = SyncService(MockSupabaseClient(), harness.isar);
  });

  tearDown(() => harness.tearDown());

  test('clearAllCaches wipes every cached collection', () async {
    await harness.isar.writeTxn(() async {
      await harness.isar.userCaches.put(
        UserCache()
          ..userId = 'u1'
          ..userName = 'Maxime'
          ..mail = 'maxime@example.com'
          ..subscriptionStatus = 'free'
          ..subscriptionConfigId = '1',
      );
      await harness.isar.petCaches.put(
        PetCache()
          ..petId = 'p1'
          ..petName = 'Yumeko'
          ..birthdate = DateTime(2024, 1, 1)
          ..gender = 'female'
          ..createdAt = DateTime(2024, 1, 1)
          ..petRaceId = 'r1'
          ..petSpeciesId = 's1',
      );
      await harness.isar.eventCaches.put(
        EventCache()
          ..eventId = 'e1'
          ..title = 'Balade'
          ..entryDate = DateTime(2025, 1, 1)
          ..createdAt = DateTime(2025, 1, 1)
          ..eventTypeId = 't1',
      );
    });

    await syncService.clearAllCaches();

    expect(await harness.isar.userCaches.count(), 0);
    expect(await harness.isar.petCaches.count(), 0);
    expect(await harness.isar.eventCaches.count(), 0);
  });
}

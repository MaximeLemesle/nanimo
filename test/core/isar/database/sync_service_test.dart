import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_type_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_species_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';
import 'package:nanimo/core/isar/database/sync_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late MockGoTrueClient auth;
  late MockUser user;
  late SyncService syncService;

  setUpAll(registerSupabaseFallbacks);

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    auth = MockGoTrueClient();
    user = MockUser();
    when(() => supabase.auth).thenReturn(auth);
    when(() => auth.currentUser).thenReturn(user);
    when(() => user.id).thenReturn('u1');
    syncService = SyncService(supabase, harness.isar);
  });

  tearDown(() => harness.tearDown());

  Future<void> seedPet(String petId) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.petCaches.put(
        PetCache()
          ..petId = petId
          ..petName = 'Yumeko'
          ..birthdate = DateTime(2024, 1, 1)
          ..gender = 'female'
          ..createdAt = DateTime(2024, 1, 1)
          ..petRaceId = 'r1'
          ..petSpeciesId = 's1',
      );
    });
  }

  Future<void> seedEvent(String eventId) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.eventCaches.put(
        EventCache()
          ..eventId = eventId
          ..title = 'Balade'
          ..entryDate = DateTime(2025, 1, 1)
          ..createdAt = DateTime(2025, 1, 1)
          ..eventTypeId = 't1',
      );
    });
  }

  group('clearAllCaches', () {
    test('wipes every cached collection', () async {
      await harness.isar.writeTxn(() async {
        await harness.isar.userCaches.put(
          UserCache()
            ..userId = 'u1'
            ..userName = 'Maxime'
            ..mail = 'maxime@example.com'
            ..subscriptionStatus = 'free'
            ..subscriptionConfigId = '1',
        );
      });
      await seedPet('p1');
      await seedEvent('e1');

      await syncService.clearAllCaches();

      expect(await harness.isar.userCaches.count(), 0);
      expect(await harness.isar.petCaches.count(), 0);
      expect(await harness.isar.eventCaches.count(), 0);
    });
  });

  group('syncCritical', () {
    test('populates the user, pet and config caches from Supabase', () async {
      stubSelect(supabase, 'users', resolver: () => {
            'id_user': 'u1',
            'user_name': 'Maxime',
            'mail': 'maxime@example.com',
            'subscription_status': 'free',
            'subscription_expires_at': null,
            'id_subscription_config': '1',
            'subscription_config': {
              'id_subscription_config': 1,
              'plan_name': 'free',
              'max_images_per_event': 1,
              'max_pets': 1,
              'max_storage_in_mb': 500,
            },
          });
      stubSelect(supabase, 'pets', resolver: () => [
            {
              'id_pet': 'p9',
              'pet_name': 'Rex',
              'birthdate': '2024-01-01',
              'gender': 'male',
              'created_at': '2024-01-01T00:00:00Z',
              'pet_race_id': 'r1',
              'pet_species_id': 's1',
            },
          ]);
      await seedPet('stale');

      await syncService.syncCritical();

      expect(await harness.isar.userCaches.getByUserId('u1'), isNotNull);
      expect(
        await harness.isar.subscriptionConfigCaches.getByConfigId('1'),
        isNotNull,
      );
      expect(await harness.isar.petCaches.count(), 1);
      expect(await harness.isar.petCaches.getByPetId('p9'), isNotNull);
    });

    test('swallows fetch failures and leaves the caches untouched', () async {
      when(() => supabase.from(any()))
          .thenThrow(const PostgrestException(message: 'RLS'));
      await seedPet('p1');

      await syncService.syncCritical();

      expect(await harness.isar.petCaches.count(), 1);
      expect(await harness.isar.userCaches.count(), 0);
    });
  });

  group('syncSecondary', () {
    test('populates every secondary cache and clears stale rows', () async {
      stubSelect(supabase, 'events', resolver: () => [
            {
              'id_event': 'e9',
              'title': 'Balade',
              'description': null,
              'created_at': '2025-01-01T00:00:00Z',
              'entry_date': '2025-01-01T00:00:00Z',
              'event_type_id': 't1',
            },
          ]);
      stubSelect(supabase, 'event_image', resolver: () => [
            {
              'id_event_image': 'i1',
              'asset_path': 'u1/e9/photo.jpg',
              'event_id': 'e9',
            },
          ]);
      stubSelect(supabase, 'pets_events', resolver: () => [
            {'pet_id': 'p1', 'event_id': 'e9'},
          ]);
      stubSelect(supabase, 'health_diary', resolver: () => [
            {
              'id_health_diary': 'h1',
              'is_sterilized': true,
              'is_chipped': false,
              'chip_number': null,
              'last_deworming_at': null,
              'last_vet_appointment': null,
              'pet_id': 'p1',
            },
          ]);
      stubSelect(supabase, 'health_diary_vaccines', resolver: () => [
            {
              'id_health_diary_vaccine': 'v1',
              'vaccine_name': 'Rage',
              'last_date': '2025-01-01',
              'next_date': '2026-01-01',
              'recurrence': 365,
              'dose_number': 1,
              'total_dose_number': 2,
              'health_diary_id': 'h1',
            },
          ]);
      stubSelect(supabase, 'health_diary_weight_log', resolver: () => [
            {
              'id_health_diary_weight_log': 'w1',
              'weight': 4.2,
              'logged_at': '2025-01-01T00:00:00Z',
              'pet_id': 'p1',
            },
          ]);
      stubSelect(supabase, 'vet_visits', resolver: () => [
            {
              'id_vet_visit': 'vv1',
              'title': 'Vaccin annuel',
              'visited_at': '2025-01-01',
              'vet_name': null,
              'clinic_name': null,
              'pet_id': 'p1',
            },
          ]);
      stubSelect(supabase, 'pet_species', resolver: () => [
            {
              'id_pet_species': 's1',
              'species_name': 'Chat',
              'weight_unit': 'kg',
              'icon_key': 'cat',
            },
          ]);
      stubSelect(supabase, 'event_type', resolver: () => [
            {
              'id_event_type': 't1',
              'name': 'Balade',
              'code': 'balade',
              'is_premium': false,
            },
          ]);
      await seedEvent('stale');

      syncService.syncSecondary();
      await _waitFor(() => harness.isar.eventTypeCaches.count());

      expect(await harness.isar.eventCaches.count(), 1);
      expect(await harness.isar.eventCaches.getByEventId('e9'), isNotNull);
      expect(
        (await harness.isar.eventCaches.getByEventId('e9'))!.eventTypeId,
        't1',
      );
      expect(await harness.isar.eventImageCaches.count(), 1);
      expect(await harness.isar.petEventCaches.count(), 1);
      expect(await harness.isar.healthDiaryCaches.count(), 1);
      expect(await harness.isar.healthDiaryVaccineCaches.count(), 1);
      expect(await harness.isar.weightLogCaches.count(), 1);
      expect(await harness.isar.vetVisitCaches.count(), 1);
      expect(await harness.isar.petSpeciesCaches.count(), 1);
      expect(await harness.isar.eventTypeCaches.count(), 1);
    });

    test('swallows fetch failures and leaves the caches untouched', () async {
      when(() => supabase.from(any())).thenThrow(Exception('offline'));
      await seedEvent('e1');

      syncService.syncSecondary();
      await Future<void>.delayed(const Duration(milliseconds: 200));

      expect(await harness.isar.eventCaches.count(), 1);
    });
  });
}

/// Polls [count] until it returns a positive value or the timeout elapses.
Future<void> _waitFor(Future<int> Function() count) async {
  final deadline = DateTime.now().add(const Duration(seconds: 5));
  while (DateTime.now().isBefore(deadline)) {
    if (await count() > 0) return;
    await Future<void>.delayed(const Duration(milliseconds: 20));
  }
}

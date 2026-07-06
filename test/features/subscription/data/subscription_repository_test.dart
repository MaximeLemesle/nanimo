import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late SubscriptionRepository repo;

  const freeConfig = SubscriptionConfigModel(
    configId: 'cfg-free',
    planName: 'free',
    maxImagesPerEvent: 1,
    maxPets: 1,
    maxStorageMb: 500,
    canAccessPremiumIcons: false,
  );

  setUpAll(registerSupabaseFallbacks);

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    repo = SubscriptionRepository(supabase, harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  Future<void> seedConfig(SubscriptionConfigModel model) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.subscriptionConfigCaches
          .putByConfigId(SubscriptionConfigCache.fromModel(model));
    });
  }

  group('watchConfigById', () {
    test('emits null when the cache is empty', () async {
      final emission = await repo.watchConfigById('cfg-free').first;
      expect(emission, isNull);
    });

    test('emits the cached config when present', () async {
      await seedConfig(freeConfig);

      final emission = await repo.watchConfigById('cfg-free').first;
      expect(emission, isNotNull);
      expect(emission!.configId, 'cfg-free');
      expect(emission.planName, 'free');
    });
  });

  group('getConfigById', () {
    test('returns null when the cache is empty', () async {
      expect(await repo.getConfigById('cfg-free'), isNull);
    });

    test('returns the cached config when present', () async {
      await seedConfig(freeConfig);

      final result = await repo.getConfigById('cfg-free');
      expect(result, isNotNull);
      expect(result!.maxStorageMb, 500);
      expect(result.canAccessPremiumIcons, isFalse);
    });
  });

  group('fetchConfigById', () {
    test('fetches from Supabase and writes through the cache', () async {
      stubSelect(supabase, 'subscription_config', resolver: () => {
            'id_subscription_config': 2,
            'plan_name': 'premium',
            'max_images_per_event': 5,
            'max_pets': 10,
            'max_storage_mb': 5000,
            'can_access_premium_icons': true,
          });

      final result = await repo.fetchConfigById('2');

      expect(result.planName, 'premium');
      expect(result.maxPets, 10);
      expect(await repo.getConfigById('2'), isNotNull);
    });

    test('throws a network exception on failure', () async {
      when(() => supabase.from(any())).thenThrow(Exception('offline'));

      await expectLater(
        repo.fetchConfigById('2'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });
}

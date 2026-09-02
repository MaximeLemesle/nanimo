import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late SubscriptionRepository repo;

  const freemiumConfig = SubscriptionConfigModel(
    configId: 'cfg-freemium',
    planName: 'freemium',
    maxImagesPerEvent: 1,
    maxPets: 1,
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
      await harness.isar.subscriptionConfigCaches.putByPlanName(SubscriptionConfigCache.fromModel(model));
    });
  }

  group('watchConfigByPlanName', () {
    test('emits null when the cache is empty', () async {
      final emission = await repo.watchConfigByPlanName('freemium').first;
      expect(emission, isNull);
    });

    test('emits the cached config when present', () async {
      await seedConfig(freemiumConfig);

      final emission = await repo.watchConfigByPlanName('freemium').first;
      expect(emission, isNotNull);
      expect(emission!.configId, 'cfg-freemium');
      expect(emission.planName, 'freemium');
    });
  });

  group('getConfigByPlanName', () {
    test('returns null when the cache is empty', () async {
      expect(await repo.getConfigByPlanName('freemium'), isNull);
    });

    test('returns the cached config when present', () async {
      await seedConfig(freemiumConfig);

      final result = await repo.getConfigByPlanName('freemium');
      expect(result, isNotNull);
    });

    test('does not leak another plan config', () async {
      await seedConfig(freemiumConfig);

      expect(await repo.getConfigByPlanName('premium'), isNull);
    });
  });

  group('fetchConfigByPlanName', () {
    test('fetches from Supabase and writes through the cache', () async {
      stubSelect(supabase, 'subscription_config',
          resolver: () => {
                'id_subscription_config': 'cfg-premium',
                'plan_name': 'premium',
                'max_images_per_event': 5,
                'max_pets': 10,
              });

      final result = await repo.fetchConfigByPlanName('premium');

      expect(result.planName, 'premium');
      expect(result.maxPets, 10);
      expect(await repo.getConfigByPlanName('premium'), isNotNull);
    });

    test('throws a network exception on failure', () async {
      when(() => supabase.from(any())).thenThrow(Exception('offline'));

      await expectLater(
        repo.fetchConfigByPlanName('premium'),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });
}

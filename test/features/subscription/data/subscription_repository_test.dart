import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/data/subscription_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

void main() {
  final harness = IsarTestHarness();
  late SubscriptionRepository repo;

  const freeConfig = SubscriptionConfigModel(
    configId: 'cfg-free',
    planName: 'free',
    maxImagesPerEvent: 1,
    maxPets: 1,
    maxStorageMb: 500,
    canAccessPremiumIcons: false,
  );

  setUp(() async {
    await harness.setUp();
    repo = SubscriptionRepository(MockSupabaseClient(), harness.isar);
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
}

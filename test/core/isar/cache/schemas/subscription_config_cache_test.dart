import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/subscription_config_cache.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

void main() {
  group('SubscriptionConfigCache.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_subscription_config': 'cfg-1',
        'plan_name': 'free',
        'max_images_per_event': 1,
        'max_pets': 1,
        'max_storage_mb': 500,
        'can_access_premium_icons': false,
      };

      final cache = SubscriptionConfigCache.fromJson(json);

      expect(cache.configId, 'cfg-1');
      expect(cache.planName, 'free');
      expect(cache.maxImagesPerEvent, 1);
      expect(cache.maxPets, 1);
      expect(cache.maxStorageMb, 500);
      expect(cache.canAccessPremiumIcons, false);
    });

    test('accepts integer id_subscription_config (SERIAL PK)', () {
      final json = {
        'id_subscription_config': 2,
        'plan_name': 'premium',
        'max_images_per_event': 5,
        'max_pets': 10,
        'max_storage_mb': 5000,
        'can_access_premium_icons': true,
      };

      final cache = SubscriptionConfigCache.fromJson(json);

      expect(cache.configId, '2');
    });
  });

  group('SubscriptionConfigCache round-trip', () {
    test('Model → Cache → Model preserves fields', () {
      final model = const SubscriptionConfigModel(
        configId: 'cfg-premium',
        planName: 'premium',
        maxImagesPerEvent: 5,
        maxPets: 10,
        maxStorageMb: 5000,
        canAccessPremiumIcons: true,
      );

      final back = SubscriptionConfigCache.fromModel(model).toModel();

      expect(back.configId, model.configId);
      expect(back.planName, model.planName);
      expect(back.maxImagesPerEvent, model.maxImagesPerEvent);
      expect(back.maxPets, model.maxPets);
      expect(back.maxStorageMb, model.maxStorageMb);
      expect(back.canAccessPremiumIcons, model.canAccessPremiumIcons);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

void main() {
  group('SubscriptionConfigModel.fromJson', () {
    test('maps all fields correctly', () {
      final json = {
        'id_subscription_config': 'cfg-1',
        'plan_name': 'free',
        'max_images_per_event': 1,
        'max_pets': 1,
        'max_storage_in_mb': 500,
      };

      final model = SubscriptionConfigModel.fromJson(json);

      expect(model.configId, 'cfg-1');
      expect(model.planName, 'free');
      expect(model.maxImagesPerEvent, 1);
      expect(model.maxPets, 1);
      expect(model.maxStorageMb, 500);
    });

    test('accepts integer id_subscription_config (SERIAL PK)', () {
      final json = {
        'id_subscription_config': 2,
        'plan_name': 'premium',
        'max_images_per_event': 5,
        'max_pets': 10,
        'max_storage_in_mb': 5000,
      };

      final model = SubscriptionConfigModel.fromJson(json);

      expect(model.configId, '2');
      expect(model.planName, 'premium');
      expect(model.maxPets, 10);
    });
  });

  group('SubscriptionConfigModel.toJson', () {
    test('round-trips through fromJson', () {
      final original = const SubscriptionConfigModel(
        configId: 'cfg-1',
        planName: 'free',
        maxImagesPerEvent: 1,
        maxPets: 1,
        maxStorageMb: 500,
      );

      final roundTripped = SubscriptionConfigModel.fromJson(original.toJson());

      expect(roundTripped.configId, original.configId);
      expect(roundTripped.planName, original.planName);
      expect(roundTripped.maxImagesPerEvent, original.maxImagesPerEvent);
      expect(roundTripped.maxPets, original.maxPets);
      expect(roundTripped.maxStorageMb, original.maxStorageMb);
    });
  });
}

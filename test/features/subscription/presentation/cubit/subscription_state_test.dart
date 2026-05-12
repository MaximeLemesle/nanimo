import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

void main() {
  const freeConfig = SubscriptionConfigModel(
    configId: 'cfg-free',
    planName: 'free',
    maxImagesPerEvent: 1,
    maxPets: 1,
    maxStorageMb: 500,
    canAccessPremiumIcons: false,
  );

  const premiumConfig = SubscriptionConfigModel(
    configId: 'cfg-premium',
    planName: 'premium',
    maxImagesPerEvent: 5,
    maxPets: 10,
    maxStorageMb: 5000,
    canAccessPremiumIcons: true,
  );

  group('SubscriptionState factories', () {
    test('unknown has no config and no error', () {
      const state = SubscriptionState.unknown();
      expect(state.status, SubscriptionStatus.unknown);
      expect(state.config, isNull);
      expect(state.errorMessage, isNull);
      expect(state.isLoaded, isFalse);
    });

    test('loading carries no config', () {
      const state = SubscriptionState.loading();
      expect(state.status, SubscriptionStatus.loading);
      expect(state.config, isNull);
    });

    test('loaded carries the config', () {
      const state = SubscriptionState.loaded(freeConfig);
      expect(state.status, SubscriptionStatus.loaded);
      expect(state.config, freeConfig);
      expect(state.isLoaded, isTrue);
    });

    test('error carries the message', () {
      const state = SubscriptionState.error('boom');
      expect(state.status, SubscriptionStatus.error);
      expect(state.errorMessage, 'boom');
      expect(state.config, isNull);
    });
  });

  group('canCreatePet', () {
    test('fail-closed when config is null', () {
      expect(const SubscriptionState.unknown().canCreatePet(0), isFalse);
    });

    test('returns true under the free limit', () {
      expect(const SubscriptionState.loaded(freeConfig).canCreatePet(0), isTrue);
    });

    test('returns false at the free limit', () {
      expect(const SubscriptionState.loaded(freeConfig).canCreatePet(1), isFalse);
    });

    test('returns true under the premium limit', () {
      expect(const SubscriptionState.loaded(premiumConfig).canCreatePet(5), isTrue);
    });
  });

  group('canAddImageToEvent', () {
    test('fail-closed when config is null', () {
      expect(const SubscriptionState.unknown().canAddImageToEvent(0), isFalse);
    });

    test('respects the limit', () {
      const state = SubscriptionState.loaded(freeConfig);
      expect(state.canAddImageToEvent(0), isTrue);
      expect(state.canAddImageToEvent(1), isFalse);
    });
  });

  group('canAccessPremiumIcons', () {
    test('fail-closed when config is null', () {
      expect(const SubscriptionState.unknown().canAccessPremiumIcons, isFalse);
    });

    test('false on free plan', () {
      expect(const SubscriptionState.loaded(freeConfig).canAccessPremiumIcons, isFalse);
    });

    test('true on premium plan', () {
      expect(const SubscriptionState.loaded(premiumConfig).canAccessPremiumIcons, isTrue);
    });
  });

  group('canUseStorage', () {
    test('fail-closed when config is null', () {
      expect(const SubscriptionState.unknown().canUseStorage(0), isFalse);
    });

    test('respects the limit', () {
      const state = SubscriptionState.loaded(freeConfig);
      expect(state.canUseStorage(499), isTrue);
      expect(state.canUseStorage(500), isFalse);
    });
  });

  group('equality', () {
    test('two loaded states with the same config are equal', () {
      expect(
        const SubscriptionState.loaded(freeConfig),
        const SubscriptionState.loaded(freeConfig),
      );
    });

    test('loaded(free) != loaded(premium)', () {
      expect(
        const SubscriptionState.loaded(freeConfig) ==
            const SubscriptionState.loaded(premiumConfig),
        isFalse,
      );
    });
  });
}

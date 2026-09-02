import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

void main() {
  const freePlan = SubscriptionState.loaded(SubscriptionConfigModel(
    configId: 'cfg-free',
    planName: 'freemium',
    maxImagesPerEvent: 1,
    maxPets: 1,
  ));

  const premiumPlan = SubscriptionState.loaded(SubscriptionConfigModel(
    configId: 'cfg-premium',
    planName: 'premium',
    maxImagesPerEvent: 5,
    maxPets: 10,
  ));

  group('offersUpgrade', () {
    test('only a loaded free plan can be lifted by going premium', () {
      expect(QuotaUpsell.offersUpgrade(freePlan), isTrue);
      expect(QuotaUpsell.offersUpgrade(premiumPlan), isFalse);
      expect(
        QuotaUpsell.offersUpgrade(const SubscriptionState.unknown()),
        isFalse,
      );
    });
  });

  group('petMessage', () {
    test('uses the premium quota', () {
      expect(QuotaUpsell.petMessage(premiumPlan), 'Limite de 10 animaux atteinte.');
    });

    test('singularises the quota', () {
      expect(QuotaUpsell.petMessage(freePlan), 'Limite de 1 animal atteinte.');
    });

    test('falls back to the degraded message when nothing is loaded', () {
      expect(
        QuotaUpsell.petMessage(const SubscriptionState.unknown()),
        subscriptionUnavailableMessage,
      );
    });
  });

  group('eventImageMessage', () {
    test('uses the premium quota', () {
      expect(
        QuotaUpsell.eventImageMessage(premiumPlan, 5),
        'Limite de 5 photos par souvenir atteinte.',
      );
    });

    test('singularises the quota', () {
      expect(
        QuotaUpsell.eventImageMessage(freePlan, 1),
        'Limite de 1 photo par souvenir atteinte.',
      );
    });

    test('falls back to the degraded message when nothing is loaded', () {
      expect(
        QuotaUpsell.eventImageMessage(const SubscriptionState.unknown(), 0),
        subscriptionUnavailableMessage,
      );
    });
  });
}

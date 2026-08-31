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

  group('petMessage', () {
    test('names the free limit and points at premium', () {
      expect(QuotaUpsell.petMessage(freePlan), contains('limité à 1 animal'));
      expect(QuotaUpsell.petMessage(freePlan), contains('Passe premium'));
    });

    test('uses the premium quota and drops the upsell', () {
      expect(QuotaUpsell.petMessage(premiumPlan), 'Limite de 10 animaux atteinte.');
    });

    test('falls back to the degraded message when nothing is loaded', () {
      expect(
        QuotaUpsell.petMessage(const SubscriptionState.unknown()),
        subscriptionUnavailableMessage,
      );
    });
  });

  group('eventImageMessage', () {
    test('names the free limit and points at premium', () {
      final message = QuotaUpsell.eventImageMessage(freePlan, 1);
      expect(message, contains('limité à 1 photo par souvenir'));
      expect(message, contains('Passe premium'));
    });

    test('uses the premium quota and drops the upsell', () {
      expect(
        QuotaUpsell.eventImageMessage(premiumPlan, 5),
        'Limite de 5 photos par souvenir atteinte.',
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

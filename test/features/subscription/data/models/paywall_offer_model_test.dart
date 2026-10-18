import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';

PaywallOfferModel _annual(String label, double price) =>
    PaywallOfferModel(packageId: 'a', period: PaywallPeriod.annual, priceLabel: label, price: price);

const _monthly = PaywallOfferModel(packageId: 'm', period: PaywallPeriod.monthly, priceLabel: '4,99 €', price: 4.99);

void main() {
  group('monthlyPriceLabel', () {
    test('divides the annual price by twelve in the store format', () {
      expect(_annual('34,99 €', 34.99).monthlyPriceLabel, '2,92 €');
      expect(_annual('\$34.99', 34.99).monthlyPriceLabel, '\$2.92');
      expect(_annual('CHF 39.00', 39).monthlyPriceLabel, 'CHF 3.25');
    });

    test('leaves a monthly plan, or an unknown price, as the store wrote it', () {
      expect(_monthly.monthlyPriceLabel, '4,99 €');
      expect(_annual('34,99 €', 0).monthlyPriceLabel, '34,99 €');
    });
  });

  group('savingsAgainst', () {
    test('compares against twelve monthly payments', () {
      expect(_annual('34,99 €', 34.99).savingsAgainst(_monthly), 42);
    });

    test('says nothing when it cannot be worked out or saves nothing', () {
      expect(_annual('34,99 €', 34.99).savingsAgainst(null), isNull);
      expect(_annual('34,99 €', 0).savingsAgainst(_monthly), isNull);
      expect(_annual('70 €', 70).savingsAgainst(_monthly), isNull);
      expect(_monthly.savingsAgainst(_monthly), isNull);
    });
  });
}

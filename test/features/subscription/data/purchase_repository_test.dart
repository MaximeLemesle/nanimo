import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_client.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';

class _MockPurchaseClient extends Mock implements PurchaseClient {}

class _MockOfferings extends Mock implements Offerings {}

class _MockOffering extends Mock implements Offering {}

class _MockPackage extends Mock implements Package {}

class _MockStoreProduct extends Mock implements StoreProduct {}

class _MockCustomerInfo extends Mock implements CustomerInfo {}

class _MockEntitlementInfos extends Mock implements EntitlementInfos {}

class _MockEntitlementInfo extends Mock implements EntitlementInfo {}

/// Builds a package the way RevenueCat hands it over.
Package _package({
  required String id,
  required PackageType type,
  required String priceString,
  IntroductoryPrice? intro,
}) {
  final product = _MockStoreProduct();
  when(() => product.priceString).thenReturn(priceString);
  when(() => product.introductoryPrice).thenReturn(intro);

  final package = _MockPackage();
  when(() => package.identifier).thenReturn(id);
  when(() => package.packageType).thenReturn(type);
  when(() => package.storeProduct).thenReturn(product);
  return package;
}

Offerings _offerings(List<Package> packages) {
  final offering = _MockOffering();
  when(() => offering.availablePackages).thenReturn(packages);

  final offerings = _MockOfferings();
  when(() => offerings.current).thenReturn(offering);
  return offerings;
}

CustomerInfo _customerInfo({required bool premium}) {
  final entitlements = _MockEntitlementInfos();
  when(() => entitlements.active).thenReturn(
    premium ? {'premium': _MockEntitlementInfo()} : {},
  );

  final info = _MockCustomerInfo();
  when(() => info.entitlements).thenReturn(entitlements);
  return info;
}

/// A free trial as the stores report it: a zero-priced introductory phase.
IntroductoryPrice _trial(int units, PeriodUnit unit) =>
    IntroductoryPrice(0, '0,00 €', 'P${units}D', 1, unit, units);

void main() {
  late _MockPurchaseClient client;
  late PurchaseRepository repository;

  final monthly = _package(
    id: '\$rc_monthly',
    type: PackageType.monthly,
    priceString: '4,99 €',
    intro: _trial(7, PeriodUnit.day),
  );
  final annual = _package(
    id: '\$rc_annual',
    type: PackageType.annual,
    priceString: '39,99 €',
  );

  setUpAll(() {
    // mocktail needs a concrete instance to stand in for `any()` on a
    // non-nullable custom type.
    registerFallbackValue(_MockPackage());
  });

  setUp(() {
    client = _MockPurchaseClient();
    repository = PurchaseRepository(client);
  });

  group('getOffers', () {
    test('maps packages to offers, monthly before annual', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([annual, monthly]));

      final offers = await repository.getOffers();

      expect(offers.map((o) => o.period),
          [PaywallPeriod.monthly, PaywallPeriod.annual]);
      expect(offers.first.priceLabel, '4,99 €');
      expect(offers.first.packageId, '\$rc_monthly');
    });

    test('reads the trial length from the store, in days', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly]));

      final offers = await repository.getOffers();

      expect(offers.single.trialDays, 7);
      expect(offers.single.hasTrial, isTrue);
    });

    test('normalises a trial expressed in weeks', () async {
      final weekly = _package(
        id: 'weekly-trial',
        type: PackageType.monthly,
        priceString: '4,99 €',
        intro: _trial(2, PeriodUnit.week),
      );
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([weekly]));

      final offers = await repository.getOffers();

      expect(offers.single.trialDays, 14);
    });

    /// A discounted first period is not a trial. Announcing "7 jours offerts"
    /// on a paid intro price would be a false claim on the paywall.
    test('a paid introductory price is not treated as a trial', () async {
      final discounted = _package(
        id: 'discounted',
        type: PackageType.monthly,
        priceString: '4,99 €',
        intro: IntroductoryPrice(1.99, '1,99 €', 'P7D', 1, PeriodUnit.day, 7),
      );
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([discounted]));

      final offers = await repository.getOffers();

      expect(offers.single.trialDays, 0);
      expect(offers.single.hasTrial, isFalse);
    });

    test('reports a clear error when the offering is empty', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([]));

      expect(
        () => repository.getOffers(),
        throwsA(isA<RepositoryServerException>()),
      );
    });

    test('maps a client failure to a repository exception', () async {
      when(() => client.getOfferings()).thenThrow(Exception('offline'));

      expect(
        () => repository.getOffers(),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('purchase', () {
    test('returns true when the entitlement is active afterwards', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly, annual]));
      when(() => client.purchasePackage(any()))
          .thenAnswer((_) async => _customerInfo(premium: true));

      final active = await repository.purchase('\$rc_annual');

      expect(active, isTrue);
      verify(() => client.purchasePackage(annual)).called(1);
    });

    /// The store can report a completed flow without granting anything, e.g. a
    /// deferred family-sharing approval. Treating that as premium would hand
    /// out paid quotas for free.
    test('returns false when no entitlement was granted', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly]));
      when(() => client.purchasePackage(any()))
          .thenAnswer((_) async => _customerInfo(premium: false));

      final active = await repository.purchase('\$rc_monthly');

      expect(active, isFalse);
    });

    test('translates a user cancellation into its own exception', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly]));
      when(() => client.purchasePackage(any())).thenThrow(
        PlatformException(code: '1', details: {'readableErrorCode': 'PURCHASE_CANCELLED'}),
      );

      expect(
        () => repository.purchase('\$rc_monthly'),
        throwsA(isA<PurchaseCancelledException>()),
      );
    });

    test('a store error surfaces a readable message', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly]));
      when(() => client.purchasePackage(any())).thenThrow(
        PlatformException(code: '2', details: {'readableErrorCode': 'STORE_PROBLEM'}),
      );

      expect(
        () => repository.purchase('\$rc_monthly'),
        throwsA(isA<RepositoryServerException>()),
      );
    });

    test('refuses a package that is no longer offered', () async {
      when(() => client.getOfferings())
          .thenAnswer((_) async => _offerings([monthly]));

      expect(
        () => repository.purchase('\$rc_annual'),
        throwsA(isA<RepositoryServerException>()),
      );
      verifyNever(() => client.purchasePackage(any()));
    });
  });

  group('restore', () {
    test('returns true when the store restores an active entitlement',
        () async {
      when(() => client.restorePurchases())
          .thenAnswer((_) async => _customerInfo(premium: true));

      expect(await repository.restore(), isTrue);
    });

    test('returns false when there is nothing to restore', () async {
      when(() => client.restorePurchases())
          .thenAnswer((_) async => _customerInfo(premium: false));

      expect(await repository.restore(), isFalse);
    });
  });

  group('identify', () {
    /// RevenueCat being unreachable must never block sign-in: every free
    /// feature has to keep working.
    test('swallows a login failure', () async {
      when(() => client.logIn(any())).thenThrow(Exception('offline'));

      await expectLater(repository.identify('user-1'), completes);
    });

    test('swallows a logout failure', () async {
      when(() => client.logOut()).thenThrow(Exception('offline'));

      await expectLater(repository.forget(), completes);
    });
  });
}

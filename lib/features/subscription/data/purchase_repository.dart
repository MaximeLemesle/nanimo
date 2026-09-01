import 'dart:developer' as developer;

import 'package:purchases_flutter/purchases_flutter.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_client.dart';

/// User closed the store sheet. Not a failure.
class PurchaseCancelledException implements Exception {
  const PurchaseCancelledException();
}

const String _unavailableMessage =
    'Les abonnements ne sont pas disponibles sur cette version de l’application.';

/// Returns the store's view of premium, used to drive the UI right after a
/// purchase. The authoritative flip is server-side, in `revenuecat-webhook`.
class PurchaseRepository {
  static const String premiumEntitlement = 'premium';

  final PurchaseClient _client;

  PurchaseRepository(this._client);

  /// Configures the SDK once at startup. [apiKey] is the platform-specific
  /// RevenueCat public key.
  Future<void> configure(String apiKey) async {
    try {
      await _client.configure(apiKey);
    } catch (e, st) {
      developer.log('RevenueCat configure failed',
          name: 'purchase', error: e, stackTrace: st);
      rethrow;
    }
  }

  /// Failing here must not block login: free features must keep working.
  Future<void> identify(String userId) async {
    try {
      await _client.logIn(userId);
    } catch (e, st) {
      developer.log('RevenueCat logIn failed',
          name: 'purchase', error: e, stackTrace: st);
    }
  }

  Future<void> forget() async {
    try {
      await _client.logOut();
    } catch (e, st) {
      developer.log('RevenueCat logOut failed',
          name: 'purchase', error: e, stackTrace: st);
    }
  }

  /// Plans of the current offering, monthly first.
  Future<List<PaywallOfferModel>> getOffers() async {
    final Offerings offerings;
    try {
      offerings = await _client.getOfferings();
    } on PurchasesUnavailableException {
      throw const RepositoryServerException(_unavailableMessage);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'getOffers',
          networkMessage:
              'Une connexion internet est requise pour afficher les formules.',
          serverMessage: 'Les formules sont indisponibles pour le moment.');
    }

    final packages = offerings.current?.availablePackages ?? const <Package>[];
    if (packages.isEmpty) {
      throw const RepositoryServerException(
          'Aucune formule n’est disponible pour le moment.');
    }

    final offers = packages.map(_toOffer).toList()
      ..sort((a, b) => a.period.index.compareTo(b.period.index));
    return offers;
  }

  /// Throws [PurchaseCancelledException] if the user backs out.
  Future<bool> purchase(String packageId) async {
    final package = await _findPackage(packageId);

    try {
      final info = await _client.purchasePackage(package);
      return _isPremiumActive(info);
    } catch (e, st) {
      if (isPurchaseCancelled(e)) throw const PurchaseCancelledException();
      throw mapRepositoryError(e, st,
          operation: 'purchase',
          networkMessage:
              'Une connexion internet est requise pour finaliser l’achat.',
          serverMessage:
              'L’achat n’a pas pu aboutir. Aucun montant n’a été débité.');
    }
  }

  /// False when there is nothing to restore, which is a normal outcome.
  Future<bool> restore() async {
    try {
      final info = await _client.restorePurchases();
      return _isPremiumActive(info);
    } on PurchasesUnavailableException {
      throw const RepositoryServerException(_unavailableMessage);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'restore',
          networkMessage:
              'Une connexion internet est requise pour restaurer vos achats.',
          serverMessage: 'La restauration n’a pas pu aboutir.');
    }
  }

  Future<Package> _findPackage(String packageId) async {
    final Offerings offerings;
    try {
      offerings = await _client.getOfferings();
    } on PurchasesUnavailableException {
      throw const RepositoryServerException(_unavailableMessage);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'findPackage',
          networkMessage:
              'Une connexion internet est requise pour lancer l’achat.');
    }

    final packages = offerings.current?.availablePackages ?? const <Package>[];
    for (final package in packages) {
      if (package.identifier == packageId) return package;
    }
    throw const RepositoryServerException(
        'Cette formule n’est plus disponible.');
  }

  bool _isPremiumActive(CustomerInfo info) =>
      info.entitlements.active.containsKey(premiumEntitlement);

  PaywallOfferModel _toOffer(Package package) {
    final product = package.storeProduct;
    return PaywallOfferModel(
      packageId: package.identifier,
      period: _periodOf(package.packageType),
      priceLabel: product.priceString,
      trialDays: _trialDaysOf(product),
    );
  }

  PaywallPeriod _periodOf(PackageType type) {
    switch (type) {
      case PackageType.monthly:
        return PaywallPeriod.monthly;
      case PackageType.annual:
        return PaywallPeriod.annual;
      default:
        return PaywallPeriod.other;
    }
  }

  /// Normalised to days so the UI has a single number to show.
  int _trialDaysOf(StoreProduct product) {
    final intro = product.introductoryPrice;
    if (intro == null || intro.price != 0) return 0;

    final count = intro.periodNumberOfUnits;
    switch (intro.periodUnit) {
      case PeriodUnit.day:
        return count;
      case PeriodUnit.week:
        return count * 7;
      case PeriodUnit.month:
        return count * 30;
      case PeriodUnit.year:
        return count * 365;
      case PeriodUnit.unknown:
        return 0;
    }
  }
}

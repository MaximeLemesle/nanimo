import 'package:purchases_flutter/purchases_flutter.dart';

/// Thin seam over the RevenueCat SDK.
///
/// `Purchases` exposes only static methods, which cannot be mocked. Everything
/// the app needs goes through this interface so [PurchaseRepository] stays
/// testable without a store sandbox.
abstract class PurchaseClient {
  Future<void> configure(String apiKey);

  /// Ties the RevenueCat account to the Supabase user id. The webhook maps
  /// `app_user_id` back to `users.id_user`, so the two must be the same value.
  Future<void> logIn(String appUserId);

  Future<void> logOut();

  Future<Offerings> getOfferings();

  Future<CustomerInfo> purchasePackage(Package package);

  Future<CustomerInfo> restorePurchases();

  Future<CustomerInfo> getCustomerInfo();
}

class RevenueCatPurchaseClient implements PurchaseClient {
  @override
  Future<void> configure(String apiKey) async {
    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.configure(PurchasesConfiguration(apiKey));
  }

  /// RevenueCat throws when logging in the id it already holds. That happens on
  /// every relaunch, and it is not an error worth surfacing.
  @override
  Future<void> logIn(String appUserId) async {
    final current = await Purchases.appUserID;
    if (current == appUserId) return;
    await Purchases.logIn(appUserId);
  }

  @override
  Future<void> logOut() async {
    if (await Purchases.isAnonymous) return;
    await Purchases.logOut();
  }

  @override
  Future<Offerings> getOfferings() => Purchases.getOfferings();

  @override
  Future<CustomerInfo> purchasePackage(Package package) =>
      Purchases.purchasePackage(package);

  @override
  Future<CustomerInfo> restorePurchases() => Purchases.restorePurchases();

  @override
  Future<CustomerInfo> getCustomerInfo() => Purchases.getCustomerInfo();
}

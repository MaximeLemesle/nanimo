import 'package:purchases_flutter/purchases_flutter.dart';

/// Seam over the static RevenueCat SDK, which cannot be mocked otherwise.
abstract class PurchaseClient {
  Future<void> configure(String apiKey);

  /// Must be the Supabase user id: the webhook maps it back to `users.id_user`.
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

  /// RevenueCat throws when logging in the id it already holds, on every relaunch.
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

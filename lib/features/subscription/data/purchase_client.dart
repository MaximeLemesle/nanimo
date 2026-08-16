import 'package:purchases_flutter/purchases_flutter.dart';

/// Raised by [DisabledPurchaseClient] instead of touching the unconfigured SDK.
class PurchasesUnavailableException implements Exception {
  const PurchasesUnavailableException();
}

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

/// Stands in when no RevenueCat key exists for the platform.
///
/// Any static call on the unconfigured SDK raises a native fatal error that no
/// Dart catch intercepts, so sign-in stays silent here and the rest throws.
class DisabledPurchaseClient implements PurchaseClient {
  @override
  Future<void> configure(String apiKey) async {}

  @override
  Future<void> logIn(String appUserId) async {}

  @override
  Future<void> logOut() async {}

  @override
  Future<Offerings> getOfferings() =>
      throw const PurchasesUnavailableException();

  @override
  Future<CustomerInfo> purchasePackage(Package package) =>
      throw const PurchasesUnavailableException();

  @override
  Future<CustomerInfo> restorePurchases() =>
      throw const PurchasesUnavailableException();

  @override
  Future<CustomerInfo> getCustomerInfo() =>
      throw const PurchasesUnavailableException();
}

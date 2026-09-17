/// What the owner picked on the onboarding paywall, shown before they had an
/// account to charge. The purchase itself waits for the signup: RevenueCat
/// would otherwise bill an anonymous id, which the webhook drops on purpose.
///
/// Memory only, mirroring `analytics`. A cold start between the two screens
/// means the choice was abandoned, and replaying it then would be a surprise.
class PendingPremiumIntent {
  String? _packageId;

  bool get isPending => _packageId != null;

  void remember(String packageId) => _packageId = packageId;

  /// Reads and forgets in one go, so a replay can never happen twice.
  String? take() {
    final packageId = _packageId;
    _packageId = null;
    return packageId;
  }

  void clear() => _packageId = null;
}

PendingPremiumIntent pendingPremiumIntent = PendingPremiumIntent();

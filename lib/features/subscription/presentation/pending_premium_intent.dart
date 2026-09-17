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

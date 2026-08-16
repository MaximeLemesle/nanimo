part of 'paywall_cubit.dart';

enum PaywallStatus {
  initial,
  loading,
  loaded,
  purchasing,
  restoring,
  purchased,
  restored,
  error,
}

class PaywallState extends Equatable {
  final PaywallStatus status;
  final List<PaywallOfferModel> offers;
  final String? selectedPackageId;
  final String? errorMessage;

  const PaywallState._({
    this.status = PaywallStatus.initial,
    this.offers = const [],
    this.selectedPackageId,
    this.errorMessage,
  });

  const PaywallState.initial() : this._();

  const PaywallState.loading() : this._(status: PaywallStatus.loading);

  const PaywallState.loaded({
    required List<PaywallOfferModel> offers,
    String? selectedPackageId,
  }) : this._(
          status: PaywallStatus.loaded,
          offers: offers,
          selectedPackageId: selectedPackageId,
        );

  const PaywallState.error(String message)
      : this._(status: PaywallStatus.error, errorMessage: message);

  /// True once the offers are on screen, whatever operation is running on top.
  bool get isLoaded => offers.isNotEmpty && status != PaywallStatus.error;

  /// True while a store call is in flight. Guards against double taps.
  bool get isBusy =>
      status == PaywallStatus.purchasing || status == PaywallStatus.restoring;

  bool get isPurchasing => status == PaywallStatus.purchasing;

  bool get isRestoring => status == PaywallStatus.restoring;

  /// True when premium was just unlocked, by purchase or by restore.
  bool get isUnlocked =>
      status == PaywallStatus.purchased || status == PaywallStatus.restored;

  PaywallOfferModel? get selectedOffer {
    for (final offer in offers) {
      if (offer.packageId == selectedPackageId) return offer;
    }
    return null;
  }

  PaywallState copyWith({
    PaywallStatus? status,
    List<PaywallOfferModel>? offers,
    String? selectedPackageId,
    String? errorMessage,
    bool clearError = false,
  }) {
    return PaywallState._(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      selectedPackageId: selectedPackageId ?? this.selectedPackageId,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, offers, selectedPackageId, errorMessage];
}

import 'package:equatable/equatable.dart';

enum PaywallPeriod { monthly, annual, other }

/// Prices come from the store: hardcoding "4,99 €" would be wrong outside the
/// euro zone.
class PaywallOfferModel extends Equatable {
  /// RevenueCat package identifier, used to start the purchase.
  final String packageId;
  final PaywallPeriod period;

  /// Store-formatted price, e.g. "4,99 €".
  final String priceLabel;

  /// Free trial length in days, 0 when the plan has none.
  final int trialDays;

  const PaywallOfferModel({
    required this.packageId,
    required this.period,
    required this.priceLabel,
    this.trialDays = 0,
  });

  bool get hasTrial => trialDays > 0;

  String get periodLabel {
    switch (period) {
      case PaywallPeriod.monthly:
        return 'par mois';
      case PaywallPeriod.annual:
        return 'par an';
      case PaywallPeriod.other:
        return '';
    }
  }

  @override
  List<Object?> get props => [packageId, period, priceLabel, trialDays];
}

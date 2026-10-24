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

  /// Raw store price, 0 when unknown. Only used for ratios between plans.
  final double price;

  /// Free trial length in days, 0 when the plan has none.
  final int trialDays;

  const PaywallOfferModel({
    required this.packageId,
    required this.period,
    required this.priceLabel,
    this.price = 0,
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

  /// "2,92 €" for "34,99 €" a year. Rewrites the store's own label so the
  /// currency and its placement stay the store's, whatever the locale.
  String get monthlyPriceLabel {
    if (period != PaywallPeriod.annual || price <= 0) return priceLabel;
    final match = _amount.firstMatch(priceLabel);
    if (match == null) return priceLabel;
    final separator = match.group(0)!.contains(',') ? ',' : '.';
    final monthly = (price / 12).toStringAsFixed(2).replaceAll('.', separator);
    return priceLabel.replaceRange(match.start, match.end, monthly);
  }

  /// Whole percent saved against paying [monthly] twelve times, null when it
  /// cannot be worked out or saves nothing.
  int? savingsAgainst(PaywallOfferModel? monthly) {
    if (period != PaywallPeriod.annual || monthly == null) return null;
    if (price <= 0 || monthly.price <= 0) return null;
    final percent = ((1 - price / (monthly.price * 12)) * 100).round();
    return percent > 0 ? percent : null;
  }

  static final _amount = RegExp(r'\d+(?:[.,]\d+)?');

  @override
  List<Object?> get props => [packageId, period, priceLabel, price, trialDays];
}

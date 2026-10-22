import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';

class PaywallOfferCardWidget extends StatelessWidget {
  final PaywallOfferModel offer;
  final bool isSelected;
  final VoidCallback onTap;

  /// The monthly plan, against which the annual one shows its savings.
  final PaywallOfferModel? monthly;

  const PaywallOfferCardWidget({
    super.key,
    required this.offer,
    required this.isSelected,
    required this.onTap,
    this.monthly,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
        isSelected ? AppColors.textPrimary : AppColors.backgroundStroke;
    final radius = BorderRadius.circular(AppRadius.md);

    return Semantics(
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          decoration: BoxDecoration(
            color: AppColors.backgroundSurface,
            borderRadius: radius,
          ),
          /// Drawn over the content so the selection never moves the layout.
          foregroundDecoration: BoxDecoration(
            borderRadius: radius,
            border: Border.all(color: borderColor, width: isSelected ? 2 : 1),
          ),
          child: ClipRRect(
            borderRadius: radius,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (offer.hasTrial) _banner(),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        isSelected
                            ? Icons.check_circle_rounded
                            : Icons.radio_button_unchecked_rounded,
                        color: isSelected
                            ? AppColors.textPrimary
                            : AppColors.backgroundStroke,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_title, style: AppTextStyles.textBold),
                            if (_subtitle case final subtitle?)
                              Text(
                                subtitle,
                                style: AppTextStyles.textSmall
                                    .copyWith(color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text(_perMonth, style: AppTextStyles.textBold),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _banner() => Container(
        color: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
        child: Text(
          '${offer.trialDays} jours gratuits'.toUpperCase(),
          textAlign: TextAlign.center,
          style: AppTextStyles.textSmallBold
              .copyWith(color: AppColors.textInvert),
        ),
      );

  String get _title {
    switch (offer.period) {
      case PaywallPeriod.monthly:
        return 'Mensuel';
      case PaywallPeriod.annual:
        return 'Annuel';
      case PaywallPeriod.other:
        return 'Premium';
    }
  }

  /// "Économise 27 %, 34,99 € par an": the yearly charge stays in sight.
  String? get _subtitle {
    if (offer.period != PaywallPeriod.annual) return null;
    final yearly = '${offer.priceLabel} ${offer.periodLabel}';
    final savings = offer.savingsAgainst(monthly);
    return savings == null ? yearly : 'Économise $savings\u00a0%, $yearly';
  }

  String get _perMonth => switch (offer.period) {
        PaywallPeriod.annual => '${offer.monthlyPriceLabel}/mois',
        PaywallPeriod.monthly => '${offer.priceLabel}/mois',
        PaywallPeriod.other => offer.priceLabel,
      };
}

import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';

/// One plan, priced per month so the two read on the same scale. A trial
/// gets a band above the card: it is the first thing the plan offers.
class PaywallOfferCardWidget extends StatelessWidget {
  final PaywallOfferModel offer;
  final bool isSelected;
  final VoidCallback onTap;

  /// Saved against twelve monthly payments, null when not worth saying.
  final int? savingsPercent;

  const PaywallOfferCardWidget({
    super.key,
    required this.offer,
    required this.isSelected,
    required this.onTap,
    this.savingsPercent,
  });

  static const _borderWidth = 2.0;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected ? AppColors.backgroundInvert : AppColors.backgroundStroke;
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
            border: Border.all(color: borderColor, width: _borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.md - _borderWidth),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (_showsTrial)
                  Container(
                    color: borderColor,
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
                    child: Text(
                      '${offer.trialDays} jours gratuits'.toUpperCase(),
                      textAlign: TextAlign.center,
                      style: AppTextStyles.textSmallBold.copyWith(
                        color: isSelected ? AppColors.textInvert : AppColors.textSecondary,
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(AppSpacing.md),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                        color: isSelected ? AppColors.backgroundInvert : AppColors.backgroundStroke,
                        size: 28,
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(_title, style: AppTextStyles.textBold),
                            if (_subtitle != null)
                              Text(
                                _subtitle!,
                                style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.sm),
                      Text('${offer.monthlyPriceLabel}/mois', style: AppTextStyles.textBold),
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

  /// The trial is sold on the annual plan only.
  bool get _showsTrial => offer.hasTrial && offer.period == PaywallPeriod.annual;

  String get _title {
    switch (offer.period) {
      case PaywallPeriod.monthly:
        return 'Mensuel';
      case PaywallPeriod.annual:
        return _showsTrial ? 'Commence gratuitement' : 'Annuel';
      case PaywallPeriod.other:
        return 'Premium';
    }
  }

  /// The saving first, then what the year actually costs.
  String? get _subtitle {
    if (offer.period != PaywallPeriod.annual) return null;
    final yearly = '${offer.priceLabel} par an';
    return savingsPercent == null ? yearly : 'Économise $savingsPercent %, $yearly';
  }
}

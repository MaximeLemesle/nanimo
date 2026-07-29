import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/label_widget.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';

class PaywallOfferCardWidget extends StatelessWidget {
  final PaywallOfferModel offer;
  final bool isSelected;
  final VoidCallback onTap;

  const PaywallOfferCardWidget({
    super.key,
    required this.offer,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      selected: isSelected,
      button: true,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.backgroundPrimary
                : AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.backgroundStroke,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Icon(
                isSelected
                    ? Icons.radio_button_checked_rounded
                    : Icons.radio_button_unchecked_rounded,
                color: isSelected ? AppColors.primary : AppColors.textSecondary,
                size: 22,
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(_title, style: AppTextStyles.textBold),
                        if (offer.hasTrial) ...[
                          const SizedBox(width: AppSpacing.sm),
                          LabelWidget(
                            label: '${offer.trialDays} j offerts',
                            backgroundColor: AppColors.backgroundTertiary,
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '${offer.priceLabel} ${offer.periodLabel}'.trim(),
                      style: AppTextStyles.textSmall
                          .copyWith(color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

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
}

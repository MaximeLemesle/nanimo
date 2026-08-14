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
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.md,
          ),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.backgroundPrimary : AppColors.backgroundSurface,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.backgroundStroke,
              width: isSelected ? 2 : 1,
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(_title, style: AppTextStyles.textBold),
                    if (offer.hasTrial) ...[
                      const SizedBox(height: AppSpacing.xs),
                      LabelWidget(
                        label: '${offer.trialDays} jours offerts',
                        backgroundColor: AppColors.backgroundTertiary,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(offer.priceLabel, style: AppTextStyles.numberBig),
                  Text(
                    offer.periodLabel,
                    style: AppTextStyles.textLabel.copyWith(color: AppColors.textSecondary),
                  ),
                ],
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

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

/// Shown on the page of an animal the plan no longer covers. Nothing is hidden
/// or deleted, the owner keeps reading the whole record.
class PetLockedBannerWidget extends StatelessWidget {
  final String petName;
  final VoidCallback onUpgradePressed;

  const PetLockedBannerWidget({
    super.key,
    required this.petName,
    required this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      backgroundColor: AppColors.backgroundTertiary,
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Semantics(
                label: 'Réservé au premium',
                child: AppIconWidget(
                  AppIcons.crown,
                  color: AppColors.tertiary,
                  size: 18,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  'La fiche de $petName est en lecture seule',
                  style: AppTextStyles.textBold,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            'Ton plan actuel ne couvre plus cet animal. Tout est conservé, '
            'et redevient modifiable avec le premium.',
            style: AppTextStyles.textSmall
                .copyWith(color: AppColors.textSecondary),
          ),
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Reprendre le premium',
            fullWidth: true,
            onPressed: onUpgradePressed,
          ),
        ],
      ),
    );
  }
}

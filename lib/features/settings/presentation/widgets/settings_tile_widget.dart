import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

class SettingsTileWidget extends StatelessWidget {
  final IconData? icon;
  final String title;
  final String? value;
  final Widget? trailing;
  final VoidCallback? onTap;

  const SettingsTileWidget({
    super.key,
    required this.title,
    this.icon,
    this.value,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      borderColor: AppColors.backgroundStroke,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.lg,
        vertical: AppSpacing.md,
      ),
      onTap: onTap,
      child: Row(
        children: [
          if (icon != null)
            Row(
              children: [
                Icon(icon, color: AppColors.textPrimary),
                const SizedBox(width: AppSpacing.md),
              ],
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.textBold),
                if (value != null) ...[
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    value!,
                    style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.sm),
            trailing!,
          ],
        ],
      ),
    );
  }
}

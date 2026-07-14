import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

class LabelWidget extends StatelessWidget {
  final String label;
  final Color backgroundColor;
  final Color? labelColor;

  const LabelWidget({
    super.key,
    required this.label,
    required this.backgroundColor,
    this.labelColor = AppColors.textPrimary,
  });

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      backgroundColor: backgroundColor,
      fullWidth: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        label,
        style: AppTextStyles.textSmall.copyWith(color: labelColor),
      ),
    );
  }
}

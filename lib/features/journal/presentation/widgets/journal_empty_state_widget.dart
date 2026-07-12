import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class JournalEmptyStateWidget extends StatelessWidget {
  static const message = "Aucun moment n'est disponible";

  const JournalEmptyStateWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
      ),
    );
  }
}

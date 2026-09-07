import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

/// Says what to do while a diary section waits for a pick.
///
/// Without it the pencil turns rows tappable with no visible change, and the
/// mode is impossible to notice or to leave.
class PetDiarySelectionHintWidget extends StatelessWidget {
  final String label;

  const PetDiarySelectionHintWidget({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          const Icon(Icons.touch_app_outlined, size: 16, color: AppColors.primary),
          const SizedBox(width: AppSpacing.xs),
          Expanded(
            child: Text(label, style: AppTextStyles.textLabel.copyWith(color: AppColors.primary)),
          ),
        ],
      ),
    );
  }
}

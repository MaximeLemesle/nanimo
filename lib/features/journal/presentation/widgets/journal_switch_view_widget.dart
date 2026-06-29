import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

class JournalSwitchViewWidget extends StatelessWidget {
  const JournalSwitchViewWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xs),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: BoxBorder.all(color: AppColors.backgroundStroke),
      ),
      child: Row(
        children: [
          Expanded(child: _segment(label: 'timeline', selected: true)),
          Expanded(child: _segment(label: 'calendrier', selected: false)),
        ],
      ),
    );
  }

  Widget _segment({required String label, required bool selected}) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        label,
        style: selected
            ? AppTextStyles.textSmallBold.copyWith(color: AppColors.textInvert)
            : AppTextStyles.textSmall,
      ),
    );
  }
}

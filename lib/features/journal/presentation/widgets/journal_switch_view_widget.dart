import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';

class JournalSwitchViewWidget extends StatelessWidget {
  final JournalViewMode selectedViewMode;
  final ValueChanged<JournalViewMode> onChanged;

  const JournalSwitchViewWidget({
    super.key,
    required this.selectedViewMode,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: AppColors.backgroundPrimary,
        borderRadius: BorderRadius.circular(AppRadius.full),
        border: BoxBorder.all(color: AppColors.backgroundStroke),
      ),
      child: Row(
        children: [
          Expanded(
            child: _segment(
              label: 'timeline',
              viewMode: JournalViewMode.timeline,
            ),
          ),
          Expanded(
            child: _segment(
              label: 'calendrier',
              viewMode: JournalViewMode.calendar,
            ),
          ),
        ],
      ),
    );
  }

  Widget _segment({
    required String label,
    required JournalViewMode viewMode,
  }) {
    final selected = selectedViewMode == viewMode;

    return Material(
      color: selected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(AppRadius.full),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.full),
        onTap: selected ? null : () => onChanged(viewMode),
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            label,
            style: selected ? AppTextStyles.textSmallBold.copyWith(color: AppColors.textInvert) : AppTextStyles.textSmall,
          ),
        ),
      ),
    );
  }
}

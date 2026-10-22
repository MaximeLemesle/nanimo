import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';

/// How often the pet is dewormed, which sets the next reminder.
class DewormingIntervalSelectorWidget extends StatelessWidget {
  final int value;
  final ValueChanged<int> onChanged;

  const DewormingIntervalSelectorWidget({super.key, required this.value, required this.onChanged});

  static String label(int months) => switch (months) {
        1 => 'Tous les mois',
        12 => 'Tous les ans',
        _ => 'Tous les $months mois',
      };

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text('Fréquence', style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary)),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final months in HealthDiaryModel.dewormingIntervals)
              ChipWidget(label: label(months), isSelected: months == value, onTap: () => onChanged(months)),
          ],
        ),
      ],
    );
  }
}

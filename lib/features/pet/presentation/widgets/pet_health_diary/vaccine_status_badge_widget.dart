import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

enum VaccineStatus { done, soon, overdue }

VaccineStatus vaccineStatusFor(DateTime nextDate, {DateTime? now}) {
  final reference = now ?? DateTime.now();
  final days = nextDate.difference(reference).inDays;
  if (days < 0) return VaccineStatus.overdue;
  if (days <= 30) return VaccineStatus.soon;
  return VaccineStatus.done;
}

class VaccineStatusBadgeWidget extends StatelessWidget {
  final DateTime nextDate;

  const VaccineStatusBadgeWidget({super.key, required this.nextDate});

  @override
  Widget build(BuildContext context) {
    final status = vaccineStatusFor(nextDate);

    late final String label;
    late final Color background;
    late final Color foreground;

    switch (status) {
      case VaccineStatus.done:
        label = 'Terminé';
        background = AppColors.primary100;
        foreground = AppColors.primary700;
      case VaccineStatus.soon:
        final days = nextDate.difference(DateTime.now()).inDays;
        label = 'Dans $days j';
        background = AppColors.tertiary100;
        foreground = AppColors.tertiary700;
      case VaccineStatus.overdue:
        label = 'Pas fait';
        background = AppColors.secondary100;
        foreground = AppColors.secondary700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: ShapeDecoration(
        color: background,
        shape: ContinuousRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg * 2),
        ),
      ),
      child: Text(
        label,
        style: AppTextStyles.textSmall.copyWith(color: foreground),
      ),
    );
  }
}

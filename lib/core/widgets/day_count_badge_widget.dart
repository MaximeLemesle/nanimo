import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

/// Counts the days left before [date]. Unlike [VaccineStatusBadgeWidget], it
/// never reads « Terminé »: a booked appointment is ahead however far away.
class DayCountBadgeWidget extends StatelessWidget {
  final DateTime date;

  final DateTime? now;

  const DayCountBadgeWidget({super.key, required this.date, this.now});

  static String labelFor(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final days = date.difference(reference).inDays;
    if (days <= 0) return "Aujourd'hui";
    if (days == 1) return 'Demain';
    return 'Dans $days j';
  }

  @override
  Widget build(BuildContext context) {
    return RoundedBorderWidget(
      backgroundColor: AppColors.tertiary100,
      fullWidth: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        labelFor(date, now: now),
        style: AppTextStyles.textSmall.copyWith(color: AppColors.tertiary700),
      ),
    );
  }
}

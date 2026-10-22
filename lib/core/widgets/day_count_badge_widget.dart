import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/calendar_days.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';

/// Counts the days left before [date]. Unlike [VaccineStatusBadgeWidget], it
/// never reads « Terminé »: a booked appointment is ahead however far away.
class DayCountBadgeWidget extends StatelessWidget {
  final DateTime date;

  final DateTime? now;

  const DayCountBadgeWidget({super.key, required this.date, this.now});

  static String labelFor(DateTime date, {DateTime? now}) {
    final reference = now ?? DateTime.now();
    final days = calendarDaysBetween(reference, date);
    if (days <= 0) return "Aujourd'hui";
    if (days == 1) return 'Demain';
    if (days <= 30) return 'Dans $days j';
    final months = _calendarMonthsBetween(reference, date);
    if (months < 12) return 'Dans ${months < 1 ? 1 : months} mois';
    final years = months ~/ 12;
    return 'Dans $years ${years == 1 ? 'an' : 'ans'}';
  }

  /// Whole calendar months: from the 22/10, the 22/01 is 3 months, the 21/01 is 2.
  static int _calendarMonthsBetween(DateTime from, DateTime to) {
    final months = (to.year - from.year) * 12 + to.month - from.month;
    return to.day < from.day ? months - 1 : months;
  }

  /// Yellow only within a month, the same window as [VaccineStatus.soon].
  static bool isSoon(DateTime date, {DateTime? now}) =>
      calendarDaysBetween(now ?? DateTime.now(), date) <= 30;

  @override
  Widget build(BuildContext context) {
    final soon = isSoon(date, now: now);
    return RoundedBorderWidget(
      backgroundColor: soon ? AppColors.tertiary100 : AppColors.primary100,
      fullWidth: false,
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      child: Text(
        labelFor(date, now: now),
        style: AppTextStyles.textSmall.copyWith(color: soon ? AppColors.tertiary700 : AppColors.primary700),
      ),
    );
  }
}

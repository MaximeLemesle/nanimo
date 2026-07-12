import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';

class CalendarDayCell extends StatelessWidget {
  final DateTime day;
  final bool hasEvents;
  final bool isToday;
  final VoidCallback? onTap;

  const CalendarDayCell({
    super.key,
    required this.day,
    required this.hasEvents,
    required this.isToday,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderRadius = BorderRadius.circular(
      hasEvents
          ? AppRadius.sm
          : isToday
              ? AppRadius.full
              : AppRadius.sm,
    );

    return Semantics(
      button: hasEvents,
      selected: isToday,
      label: DateFormatter.calendarDay(day),
      child: Material(
        color: Colors.transparent,
        borderRadius: borderRadius,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: onTap,
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: hasEvents
                  ? 44
                  : isToday
                      ? 32
                      : 44,
              height: hasEvents
                  ? 54
                  : isToday
                      ? 32
                      : 54,
              alignment: Alignment.center,
              decoration: ShapeDecoration(
                color: hasEvents
                    ? AppColors.backgroundPrimary
                    : isToday
                        ? AppColors.backgroundInvert
                        : Colors.transparent,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.md * 2),
                ),
              ),
              child: isToday
                  ? Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundInvert,
                        borderRadius: BorderRadius.circular(AppRadius.full),
                      ),
                      child: Text(
                        '${day.day}',
                        style: AppTextStyles.numberSmall.copyWith(
                          color: AppColors.textInvert,
                        ),
                      ),
                    )
                  : Text(
                      '${day.day}',
                      style: AppTextStyles.numberSmall.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

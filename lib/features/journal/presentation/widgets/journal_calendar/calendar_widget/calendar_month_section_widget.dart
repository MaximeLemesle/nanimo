import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/calendar_widget/calendar_day_cell_widget.dart';

class CalendarMonthSectionWidget extends StatelessWidget {
  final DateTime month;
  final JournalState state;
  final DateTime today;
  final ValueChanged<DateTime> onDayTap;

  const CalendarMonthSectionWidget({
    super.key,
    required this.month,
    required this.state,
    required this.today,
    required this.onDayTap,
  });

  @override
  Widget build(BuildContext context) {
    final firstDay = DateTime(month.year, month.month);
    final daysInMonth = DateTime(month.year, month.month + 1, 0).day;
    final leadingEmptyDays = firstDay.weekday - DateTime.monday;
    final cellCount = leadingEmptyDays + daysInMonth;
    final trailingEmptyDays = (DateTime.daysPerWeek - cellCount.remainder(7)).remainder(DateTime.daysPerWeek);
    final totalCells = cellCount + trailingEmptyDays;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Center(
          child: Text(
            DateFormatter.monthYear(month),
            style: AppTextStyles.title03,
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: DateTime.daysPerWeek,
            childAspectRatio: 0.9,
          ),
          itemCount: totalCells,
          itemBuilder: (context, index) {
            final dayNumber = index - leadingEmptyDays + 1;
            if (dayNumber < 1 || dayNumber > daysInMonth) {
              return const SizedBox.shrink();
            }

            final day = DateTime(month.year, month.month, dayNumber);
            return CalendarDayCell(
              day: day,
              hasEvents: state.hasEventsOnCalendarDay(day),
              isToday: JournalState.calendarDayKey(day) == today,
              onTap: state.hasEventsOnCalendarDay(day) ? () => onDayTap(day) : null,
            );
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/calendar_widget/calendar_month_section_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/journal_day_events_bottom_sheet_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_empty_state_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';

class JournalCalendarWidget extends StatefulWidget {
  final JournalState state;
  final DateTime? today;

  const JournalCalendarWidget({
    super.key,
    required this.state,
    this.today,
  });

  @override
  State<JournalCalendarWidget> createState() => _JournalCalendarWidgetState();
}

class _JournalCalendarWidgetState extends State<JournalCalendarWidget> {
  static const int _monthBatchSize = 6;
  static const double _loadMoreThreshold = 600;
  static const String _calendarEndMessage = "Vous n'avez pas d'évènement antérieur à cette date";

  final ScrollController _scrollController = ScrollController();
  int _visibleMonthCount = _monthBatchSize;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_loadMorePastMonthsIfNeeded);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_loadMorePastMonthsIfNeeded)
      ..dispose();
    super.dispose();
  }

  void _loadMorePastMonthsIfNeeded() {
    if (!_scrollController.hasClients) return;
    if (_scrollController.position.extentAfter > _loadMoreThreshold) return;
    final totalMonthCount = _totalMonthCount();
    if (_visibleMonthCount >= totalMonthCount) return;

    setState(() {
      final nextCount = _visibleMonthCount + _monthBatchSize;
      _visibleMonthCount = nextCount > totalMonthCount ? totalMonthCount : nextCount;
    });
  }

  @override
  void didUpdateWidget(covariant JournalCalendarWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.state.firstCalendarEventMonth != widget.state.firstCalendarEventMonth) {
      _visibleMonthCount = _monthBatchSize;
    }
  }

  int _totalMonthCount() {
    final firstEventMonth = widget.state.firstCalendarEventMonth;
    if (firstEventMonth == null) return 0;

    final currentMonth = _currentMonth();
    final monthDelta = (currentMonth.year - firstEventMonth.year) * 12 + currentMonth.month - firstEventMonth.month;
    if (monthDelta < 0) return 0;
    return monthDelta + 1;
  }

  DateTime _currentMonth() {
    final todayKey = JournalState.calendarDayKey(widget.today ?? DateTime.now());
    return DateTime(todayKey.year, todayKey.month);
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.calendarEventsByDay.isEmpty) {
      return const JournalEmptyStateWidget();
    }

    final todayKey = JournalState.calendarDayKey(widget.today ?? DateTime.now());
    final currentMonth = _currentMonth();
    final totalMonthCount = _totalMonthCount();
    final visibleMonthCount = _visibleMonthCount > totalMonthCount ? totalMonthCount : _visibleMonthCount;
    final months = [
      for (var index = 0; index < visibleMonthCount; index++) DateTime(currentMonth.year, currentMonth.month - index),
    ];
    final hasEndMessage = totalMonthCount > 0 && visibleMonthCount >= totalMonthCount;

    return ListView.separated(
      controller: _scrollController,
      reverse: true,
      padding: const EdgeInsets.only(
        top: AppSpacing.xl,
        bottom: AppSpacing.xxl,
      ),
      itemCount: months.length + (hasEndMessage ? 1 : 0),
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.xxl),
      itemBuilder: (context, index) {
        if (hasEndMessage && index == months.length) {
          return const _CalendarEndMessage(text: _calendarEndMessage);
        }

        return CalendarMonthSectionWidget(
          month: months[index],
          state: widget.state,
          today: todayKey,
          onDayTap: (day) => _openDayEvents(context, day),
        );
      },
    );
  }

  Future<void> _openDayEvents(BuildContext context, DateTime day) async {
    context.read<JournalCubit>().selectCalendarDay(day);
    final selectedEvent = await JournalDayEventsBottomSheetWidget.show(
      context,
      day: day,
    );
    if (!context.mounted || selectedEvent == null) return;

    await JournalEventDetailBottomSheetWidget.show(
      context,
      event: selectedEvent,
      onEdit: () => context.push(
        '${RouteNames.editEvent}/${selectedEvent.eventId}',
      ),
    );
  }
}

class _CalendarEndMessage extends StatelessWidget {
  final String text;

  const _CalendarEndMessage({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: AppTextStyles.textSmall.copyWith(
          color: AppColors.textSecondary,
        ),
      ),
    );
  }
}

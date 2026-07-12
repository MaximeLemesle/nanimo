import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/app_scaffold.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_calendar/journal_calendar_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_filter/journal_filter_list_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_switch_view_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_widget.dart';

class JournalPage extends StatelessWidget {
  const JournalPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      body: BlocBuilder<JournalCubit, JournalState>(
        builder: (context, state) {
          if (state.status == JournalStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: AppSpacing.md),
                JournalSwitchViewWidget(
                  selectedViewMode: state.viewMode,
                  onChanged: context.read<JournalCubit>().setViewMode,
                ),
                const SizedBox(height: AppSpacing.md),
                JournalFilterListWidget(state: state),
                Expanded(
                  child: state.viewMode == JournalViewMode.calendar
                      ? JournalCalendarWidget(state: state)
                      : JournalTimelineWidget(state: state),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

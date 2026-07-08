import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_empty_state_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_event_card_widget.dart';

class JournalTimelineWidget extends StatelessWidget {
  final JournalState state;

  const JournalTimelineWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final events = state.filteredEvents;

    if (events.isEmpty) {
      return const JournalEmptyStateWidget();
    }

    final cubit = context.read<JournalCubit>();

    List<String> iconKeysFor(String eventId) {
      final petIds = state.petIdsByEvent[eventId] ?? const [];
      return [
        for (final petId in petIds)
          if (state.pets
                  .where((pet) => pet.petId == petId)
                  .map((pet) => state.iconsKey[pet.petSpeciesId])
                  .firstOrNull
              case final String iconKey)
            iconKey,
      ];
    }

    return ListView.builder(
      padding: const EdgeInsets.only(top: AppSpacing.xl),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return JournalTimelineEventCardWidget(
          event: event,
          imagePaths: state.imagePathsByEvent[event.eventId] ?? const [],
          iconKeys: iconKeysFor(event.eventId),
          urlResolver: cubit.imageUrl,
          imageFirst: index.isEven,
          onTap: () => JournalEventDetailBottomSheetWidget.show(
            context,
            event: event,
            onEdit: () =>
                context.push('${RouteNames.editEvent}/${event.eventId}'),
          ),
        );
      },
    );
  }
}

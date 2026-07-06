import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_event_detail/journal_event_detail_bottom_sheet_widget.dart';
import 'package:nanimo/features/journal/presentation/widgets/journal_timeline/journal_timeline_event_card_widget.dart';

class JournalTimelineWidget extends StatelessWidget {
  final JournalState state;

  const JournalTimelineWidget({super.key, required this.state});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<JournalCubit>();
    final events = state.filteredEvents;

    if (events.isEmpty) {
      return RefreshIndicator(
        onRefresh: () => context.read<AuthCubit>().resync(),
        child: ListView(
          padding: const EdgeInsets.only(top: AppSpacing.xxl * 3),
          children: [
            Center(
              child: Text(
                'Aucun souvenir pour le moment',
                style: AppTextStyles.text
                    .copyWith(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      );
    }

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

    return RefreshIndicator(
      onRefresh: () => context.read<AuthCubit>().resync(),
      child: ListView.builder(
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
              onEdit: () => ScaffoldMessenger.of(context)
                ..clearSnackBars()
                ..showSnackBar(
                  const SnackBar(
                    content: Text('La modification arrivera bientôt.'),
                  ),
                ),
            ),
          );
        },
      ),
    );
  }
}

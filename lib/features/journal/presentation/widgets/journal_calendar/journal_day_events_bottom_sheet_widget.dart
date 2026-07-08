import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/bottom_sheet_widget.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';

class JournalDayEventsBottomSheetWidget extends StatelessWidget {
  final DateTime day;

  const JournalDayEventsBottomSheetWidget({
    super.key,
    required this.day,
  });

  static Future<EventModel?> show(
    BuildContext context, {
    required DateTime day,
  }) {
    final cubit = context.read<JournalCubit>();
    return BottomSheetWidget.show<EventModel>(
      context,
      BlocProvider.value(
        value: cubit,
        child: JournalDayEventsBottomSheetWidget(day: day),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final selectedDay = JournalState.calendarDayKey(day);

    return BlocBuilder<JournalCubit, JournalState>(
      builder: (context, state) {
        final events = state.eventsForCalendarDay(selectedDay);

        return BottomSheetWidget(
          title: DateFormatter.calendarDay(selectedDay),
          scrollable: true,
          children: [
            if (events.isEmpty)
              Text(
                'Aucun souvenir ce jour-là',
                style:
                    AppTextStyles.text.copyWith(color: AppColors.textSecondary),
              )
            else
              for (final event in events) ...[
                _DayEventRow(
                  event: event,
                  iconKeys: _iconKeysFor(state, event.eventId),
                  onTap: () => Navigator.of(context).pop(event),
                ),
                if (event != events.last) const SizedBox(height: AppSpacing.sm),
              ],
          ],
        );
      },
    );
  }

  List<String> _iconKeysFor(JournalState state, String eventId) {
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
}

class _DayEventRow extends StatelessWidget {
  final EventModel event;
  final List<String> iconKeys;
  final VoidCallback onTap;

  const _DayEventRow({
    required this.event,
    required this.iconKeys,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final entryDate = event.entryDate;

    return Material(
      color: AppColors.backgroundSurface,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.backgroundStroke),
            borderRadius: BorderRadius.circular(AppRadius.md),
          ),
          child: Row(
            children: [
              if (iconKeys.isNotEmpty) ...[
                _PetIcons(iconKeys: iconKeys),
                const SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(event.title, style: AppTextStyles.textBold),
                    if (entryDate != null) ...[
                      const SizedBox(height: AppSpacing.xs),
                      Text(
                        DateFormatter.eventHeader(entryDate),
                        style: AppTextStyles.numberSmall.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              const Icon(
                Icons.chevron_right,
                color: AppColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PetIcons extends StatelessWidget {
  final List<String> iconKeys;

  const _PetIcons({required this.iconKeys});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 34 + ((iconKeys.length - 1) * 18),
      height: 34,
      child: Stack(
        children: [
          for (var i = 0; i < iconKeys.length; i++)
            Positioned(
              left: i * 18,
              child: Container(
                width: 34,
                height: 34,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.background,
                  shape: BoxShape.circle,
                ),
                child: SpeciesIconWidget(iconKey: iconKeys[i], height: 28),
              ),
            ),
        ],
      ),
    );
  }
}

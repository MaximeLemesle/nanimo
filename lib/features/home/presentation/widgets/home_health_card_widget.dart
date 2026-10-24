import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/chip_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/core/widgets/day_count_badge_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/widgets/home_last_entry_row_widget.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/vaccine_status_badge_widget.dart';

/// « Soins à venir »: boosters and dewormings in one list, nearest first.
class HomeHealthCardWidget extends StatelessWidget {
  static const emptyMessage = 'Aucun soin de prévu';

  final List<VaccineAlert> alerts;
  final List<DewormingAlert> dewormings;

  /// Pets whose last deworming is unknown, each offered a way to note it.
  final List<PetModel> petsWithoutDeworming;
  final Map<String, PetPortrait> portraits;
  final void Function(String petId)? onAlertTap;
  final void Function(String petId)? onDewormingTap;
  final void Function(String petId)? onDewormingDone;
  final VoidCallback? onAddPressed;

  /// Shown, one line per pet, when no booster is ahead.
  final List<LastHealthEntry> lastVaccinations;

  final DateTime? now;

  const HomeHealthCardWidget({
    super.key,
    required this.alerts,
    required this.portraits,
    this.dewormings = const [],
    this.petsWithoutDeworming = const [],
    this.lastVaccinations = const [],
    this.onAlertTap,
    this.onDewormingTap,
    this.onDewormingDone,
    this.onAddPressed,
    this.now,
  });

  @override
  Widget build(BuildContext context) {
    final upcoming = <(DateTime, Widget)>[
      for (final alert in alerts)
        (
          alert.vaccine.nextDate!,
          _AlertRow(alert: alert, portrait: portraits[alert.pet?.petId], onTap: onAlertTap, now: now),
        ),
      for (final deworming in dewormings)
        (
          deworming.nextDate,
          _DewormingRow(
            deworming: deworming,
            portrait: portraits[deworming.pet.petId],
            onTap: onDewormingTap,
            onDone: onDewormingDone,
            now: now,
          ),
        ),
    ]..sort((a, b) => a.$1.compareTo(b.$1));

    final rows = [
      for (final (_, row) in upcoming) row,
      if (alerts.isEmpty)
        for (final entry in lastVaccinations)
          HomeLastEntryRowWidget(
            entry: entry,
            lead: 'Dernier vaccin',
            portrait: portraits[entry.pet.petId],
            onTap: onAlertTap,
            now: now,
          ),
      for (final pet in petsWithoutDeworming)
        _MissingDewormingRow(pet: pet, portrait: portraits[pet.petId], onTap: onDewormingTap),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Soins à venir',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        RoundedBorderWidget(
          borderColor: AppColors.backgroundStroke,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (rows.isEmpty) Text(emptyMessage, style: AppTextStyles.textBold),
              for (var i = 0; i < rows.length; i++) ...[
                if (i > 0) ...[
                  const SizedBox(height: AppSpacing.sm),
                  const Divider(color: AppColors.secondary200, height: 1),
                  const SizedBox(height: AppSpacing.sm),
                ],
                rows[i],
              ],

              /// The way in stays reachable once the list is filled.
              const SizedBox(height: AppSpacing.md),
              ButtonWidget(
                label: alerts.isEmpty ? 'Ajouter un vaccin' : 'Ajouter un vaccin à venir',
                type: ButtonType.secondary,
                icon: Icons.add,
                iconPosition: ButtonIcon.left,
                fullWidth: true,
                onPressed: onAddPressed,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Avatar, two lines of text and a trailing badge, like a booster row.
class _CareRow extends StatelessWidget {
  final PetPortrait? portrait;
  final String title;
  final String subtitle;
  final Widget? below;
  final Widget trailing;
  final VoidCallback? onTap;

  const _CareRow({
    required this.portrait,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.below,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          SizedBox.square(
            dimension: PetAvatarSize.small.dimension,
            child: portrait == null ? null : PetAvatarWidget(portrait: portrait!, size: PetAvatarSize.small),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTextStyles.textBold, maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(subtitle, style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary)),
                if (below case final below?) below,
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          trailing,
        ],
      ),
    );
  }
}

class _DewormingRow extends StatelessWidget {
  final DewormingAlert deworming;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;
  final void Function(String petId)? onDone;
  final DateTime? now;

  const _DewormingRow({required this.deworming, this.portrait, this.onTap, this.onDone, this.now});

  @override
  Widget build(BuildContext context) {
    final petId = deworming.pet.petId;
    return _CareRow(
      portrait: portrait,
      title: 'Vermifuge',
      subtitle: DateFormatter.date(deworming.nextDate),
      onTap: onTap == null ? null : () => onTap!(petId),
      /// Offered once it is due within the month, when it can really be done.
      below: deworming.status == VaccineStatus.done || onDone == null
          ? null
          : Padding(
              padding: const EdgeInsets.only(top: AppSpacing.xs),
              child: ChipWidget(label: 'C’est fait', leadingIcon: Icons.check_rounded, onTap: () => onDone!(petId)),
            ),
      trailing: deworming.status == VaccineStatus.overdue
          ? VaccineStatusBadgeWidget(nextDate: deworming.nextDate)
          : DayCountBadgeWidget(date: deworming.nextDate, now: now),
    );
  }
}

class _MissingDewormingRow extends StatelessWidget {
  final PetModel pet;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;

  const _MissingDewormingRow({required this.pet, this.portrait, this.onTap});

  @override
  Widget build(BuildContext context) {
    return _CareRow(
      portrait: portrait,
      title: 'Vermifuge',
      subtitle: 'Quand était le dernier ?',
      onTap: onTap == null ? null : () => onTap!(pet.petId),
      trailing: ChipWidget(label: 'Noter', onTap: onTap == null ? null : () => onTap!(pet.petId)),
    );
  }
}

class _AlertRow extends StatelessWidget {
  final VaccineAlert alert;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;
  final DateTime? now;

  const _AlertRow({required this.alert, this.portrait, this.onTap, this.now});

  @override
  Widget build(BuildContext context) {
    final pet = alert.pet;

    return InkWell(
      onTap: pet == null || onTap == null ? null : () => onTap!(pet.petId),
      child: Row(
        children: [
          SizedBox.square(
            dimension: PetAvatarSize.small.dimension,
            child: portrait == null
                ? null
                : PetAvatarWidget(
                    portrait: portrait!,
                    size: PetAvatarSize.small,
                  ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  alert.vaccine.vaccineName,
                  style: AppTextStyles.textBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  DateFormatter.date(alert.vaccine.nextDate!),
                  style: AppTextStyles.textSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          /// Far boosters count down instead of reading « Terminé ».
          if (alert.status == VaccineStatus.overdue)
            VaccineStatusBadgeWidget(nextDate: alert.vaccine.nextDate!)
          else
            DayCountBadgeWidget(date: alert.vaccine.nextDate!, now: now),
        ],
      ),
    );
  }
}

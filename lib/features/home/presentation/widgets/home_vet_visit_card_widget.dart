import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/day_count_badge_widget.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';

class HomeVetVisitCardWidget extends StatelessWidget {
  final List<UpcomingVetVisit> visits;
  final Map<String, PetPortrait> portraits;
  final void Function(String petId)? onVisitTap;
  final VoidCallback? onAddPressed;

  final DateTime? now;

  const HomeVetVisitCardWidget({
    super.key,
    required this.visits,
    required this.portraits,
    this.onVisitTap,
    this.onAddPressed,
    this.now,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Visites à venir',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        RoundedBorderWidget(
          borderColor: AppColors.backgroundStroke,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (visits.isEmpty)
                Text(
                  'Aucune visite chez le vétérinaire de prévue',
                  style: AppTextStyles.textBold,
                )
              else
                for (var i = 0; i < visits.length; i++) ...[
                  if (i > 0) ...[
                    const Divider(color: AppColors.secondary200, height: 1),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  _VisitRow(
                    entry: visits[i],
                    portrait: portraits[visits[i].pet.petId],
                    onTap: onVisitTap,
                    now: now,
                  ),
                  if (i < visits.length - 1) const SizedBox(height: AppSpacing.sm),
                ],
              const SizedBox(height: AppSpacing.md),
              ButtonWidget(
                label: 'Ajouter une visite à venir',
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

class _VisitRow extends StatelessWidget {
  final UpcomingVetVisit entry;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;
  final DateTime? now;

  const _VisitRow({
    required this.entry,
    this.portrait,
    this.onTap,
    this.now,
  });

  @override
  Widget build(BuildContext context) {
    final visit = entry.visit;
    final vetName = visit.vetName;
    final clinicName = visit.clinicName;
    final visitDate = DateFormatter.date(visit.visitedAt);

    return InkWell(
      onTap: onTap == null ? null : () => onTap!(entry.pet.petId),
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
                  visit.title,
                  style: AppTextStyles.textBold,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (vetName != null)
                  Text(
                    vetName,
                    style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                  ),
                if (clinicName != null)
                  Text(
                    clinicName,
                    style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                    maxLines: 2,
                  ),
                Text(
                  visitDate,
                  style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          DayCountBadgeWidget(date: visit.visitedAt, now: now),
        ],
      ),
    );
  }
}

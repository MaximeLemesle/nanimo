import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/pet_avatar_widget.dart';
import 'package:nanimo/core/widgets/rounded_border_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/vaccine_status_badge_widget.dart';

class HomeHealthCardWidget extends StatelessWidget {
  final List<VaccineAlert> alerts;
  final Map<String, PetPortrait> portraits;
  final void Function(String petId)? onAlertTap;

  const HomeHealthCardWidget({
    super.key,
    required this.alerts,
    required this.portraits,
    this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    final allClear = alerts.isEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: AppSpacing.sm,
      children: [
        Text(
          'Vaccins à venir',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        RoundedBorderWidget(
          borderColor: AppColors.backgroundStroke,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (allClear)
                Row(
                  children: [
                    const Icon(
                      Icons.check_circle_outline,
                      color: AppColors.primary600,
                      size: 24,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text('Tout est à jour !',
                          style: AppTextStyles.textBold),
                    ),
                  ],
                )
              else
                for (var i = 0; i < alerts.length; i++) ...[
                  if (i > 0)
                    const Divider(color: AppColors.secondary200, height: 1),
                  if (i > 0) const SizedBox(height: AppSpacing.sm),
                  _AlertRow(
                    alert: alerts[i],
                    portrait: portraits[alerts[i].pet?.petId],
                    onTap: onAlertTap,
                  ),
                  if (i < alerts.length - 1)
                    const SizedBox(height: AppSpacing.sm),
                ],
            ],
          ),
        ),
      ],
    );
  }
}

class _AlertRow extends StatelessWidget {
  final VaccineAlert alert;
  final PetPortrait? portrait;
  final void Function(String petId)? onTap;

  const _AlertRow({required this.alert, this.portrait, this.onTap});

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
                  DateFormatter.date(alert.vaccine.nextDate),
                  style: AppTextStyles.textSmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          VaccineStatusBadgeWidget(nextDate: alert.vaccine.nextDate),
        ],
      ),
    );
  }
}

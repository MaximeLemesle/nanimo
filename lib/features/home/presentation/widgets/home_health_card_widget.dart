import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/species_icon_widget.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/vaccine_status_badge_widget.dart';

/// Health bento tile: vaccines overdue or due soon, or an all-clear message.
class HomeHealthCardWidget extends StatelessWidget {
  final List<VaccineAlert> alerts;
  final Map<String, String> iconsKey;
  final void Function(String petId)? onAlertTap;

  const HomeHealthCardWidget({
    super.key,
    required this.alerts,
    required this.iconsKey,
    this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    final allClear = alerts.isEmpty;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: allClear
            ? AppColors.backgroundPrimary
            : AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Santé',
            style: AppTextStyles.textLabel.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          if (allClear) _buildAllClear() else ..._buildAlertRows(),
        ],
      ),
    );
  }

  Widget _buildAllClear() {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: AppColors.primary600,
          size: AppSpacing.lg,
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text('Tout est à jour !', style: AppTextStyles.textBold),
        ),
      ],
    );
  }

  List<Widget> _buildAlertRows() {
    return [
      for (var i = 0; i < alerts.length; i++) ...[
        if (i > 0) const Divider(color: AppColors.secondary200, height: 1),
        _AlertRow(
          alert: alerts[i],
          iconKey: iconsKey[alerts[i].pet?.petSpeciesId],
          onTap: onAlertTap,
        ),
      ],
    ];
  }
}

class _AlertRow extends StatelessWidget {
  final VaccineAlert alert;
  final String? iconKey;
  final void Function(String petId)? onTap;

  const _AlertRow({required this.alert, this.iconKey, this.onTap});

  @override
  Widget build(BuildContext context) {
    final pet = alert.pet;

    return InkWell(
      onTap: pet == null || onTap == null ? null : () => onTap!(pet.petId),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
        child: Row(
          children: [
            if (iconKey != null)
              SpeciesIconWidget(iconKey: iconKey!, height: AppSpacing.xl)
            else
              const Icon(
                Icons.pets,
                size: AppSpacing.lg,
                color: AppColors.textSecondary,
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
                  if (pet != null)
                    Text(
                      pet.petName,
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
      ),
    );
  }
}

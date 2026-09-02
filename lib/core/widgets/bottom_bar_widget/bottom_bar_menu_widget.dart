import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';

class BottomBarMenuWidget extends StatelessWidget {
  final bool isOpen;

  final bool isAddPetPremiumLocked;
  final VoidCallback onAddWeight;
  final VoidCallback onAddEvent;
  final VoidCallback onAddPet;

  const BottomBarMenuWidget({
    super.key,
    required this.isOpen,
    required this.onAddWeight,
    required this.onAddEvent,
    required this.onAddPet,
    this.isAddPetPremiumLocked = false,
  });

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isOpen,
      child: AnimatedSlide(
        offset: isOpen ? Offset.zero : const Offset(0, 0.15),
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        child: AnimatedOpacity(
          opacity: isOpen ? 1 : 0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              0,
              AppSpacing.lg,

              /// padding bot + bottomBarHeight + spacing
              AppSpacing.xl + 68 + AppSpacing.lg,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: ShapeDecoration(
                color: AppColors.backgroundInvert,
                shape: ContinuousRectangleBorder(
                  borderRadius: BorderRadius.circular(AppRadius.lg * 3),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _MenuActionRowWidget(
                    label: 'Ajouter un nouveau poids',
                    icon: AppIcons.addSquare,
                    onTap: onAddWeight,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _MenuActionRowWidget(
                    label: 'Ajouter un évènement',
                    icon: AppIcons.addCalendar,
                    onTap: onAddEvent,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  _MenuActionRowWidget(
                    label: 'Ajouter un animal',
                    icon: AppIcons.petPawSolid2,
                    onTap: onAddPet,
                    isPremiumLocked: isAddPetPremiumLocked,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuActionRowWidget extends StatelessWidget {
  final String label;
  final String icon;
  final VoidCallback onTap;
  final bool isPremiumLocked;

  const _MenuActionRowWidget({
    required this.label,
    required this.icon,
    required this.onTap,
    this.isPremiumLocked = false,
  });

  static const _lockedForeground = AppColors.textSecondary;
  static const _lockedTile = AppColors.neutral50;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Row(
              children: [
                Text(
                  label,
                  style: AppTextStyles.textBold.copyWith(
                    color: isPremiumLocked ? _lockedForeground : AppColors.textInvert,
                  ),
                ),
                if (isPremiumLocked) ...[
                  const SizedBox(width: AppSpacing.sm),
                  Semantics(
                    label: 'Réservé au premium',
                    child: AppIconWidget(
                      AppIcons.crown,
                      color: AppColors.tertiary,
                      size: 18,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: isPremiumLocked ? _lockedForeground : AppColors.backgroundSurface,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md * 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AppIconWidget(
                icon,
                color: isPremiumLocked ? _lockedTile : AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

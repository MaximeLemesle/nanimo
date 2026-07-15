import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';

class BottomBarMenuWidget extends StatelessWidget {
  final bool isOpen;
  final VoidCallback onAddWeight;
  final VoidCallback onAddEvent;
  final VoidCallback onAddPet;

  const BottomBarMenuWidget({
    super.key,
    required this.isOpen,
    required this.onAddWeight,
    required this.onAddEvent,
    required this.onAddPet,
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

  const _MenuActionRowWidget({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: AppTextStyles.textBold.copyWith(
                color: AppColors.textInvert,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 48,
            height: 48,
            decoration: ShapeDecoration(
              color: AppColors.backgroundSurface,
              shape: ContinuousRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.md * 2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: AppIconWidget(
                icon,
                color: AppColors.textPrimary,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

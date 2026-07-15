import 'dart:ui' show ImageFilter;

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/core/widgets/app_icon_widget.dart';

class BottomBarWidget extends StatelessWidget {
  final int currentIndex;
  final bool isCreateMenuOpen;
  final ValueChanged<int> onTabSelected;
  final VoidCallback onCreateTap;

  const BottomBarWidget({
    super.key,
    required this.currentIndex,
    required this.isCreateMenuOpen,
    required this.onTabSelected,
    required this.onCreateTap,
  });

  static const _tabIcons = [
    AppIcons.homeSolid,
    AppIcons.openBookSolid,
    AppIcons.petPawSolid,
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xl,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /// Nav bar
            Container(
              height: 68,
              decoration: ShapeDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFFFFFFFF), Color(0x95FFFFFF)],
                ),
                shape: StadiumBorder(side: BorderSide(color: AppColors.background)),
                shadows: const [
                  BoxShadow(
                    color: AppColors.shadow,
                    blurRadius: 16,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.xs),
                child: Row(
                  spacing: AppSpacing.md,
                  children: [
                    for (var i = 0; i < _tabIcons.length; i++)
                      _TabIconWidget(
                        icon: _tabIcons[i],
                        isSelected: i == currentIndex,
                        onTap: () => onTabSelected(i),
                      ),
                  ],
                ),
              ),
            ),

            /// Action button
            GestureDetector(
              onTap: onCreateTap,
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: AppColors.backgroundInvert,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.shadow,
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: AnimatedRotation(
                  turns: isCreateMenuOpen ? 0.125 : 0,
                  duration: const Duration(milliseconds: 200),
                  curve: Curves.easeOut,
                  child: const Icon(
                    Icons.add_rounded,
                    color: AppColors.textInvert,
                    size: 32,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TabIconWidget extends StatelessWidget {
  final String icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _TabIconWidget({
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: isSelected
          ? BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.background,
            )
          : null,
      child: AppIconWidget(
        icon,
        color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
        size: 28,
      ),
    );

    if (isSelected) {
      content = DecoratedBox(
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 6,
              offset: Offset(1, 2),
            ),
          ],
        ),
        child: ClipOval(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: content,
          ),
        ),
      );
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: content,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

/// Tappable chip showing an icon plus a value, for pickers that sit inline in a
/// header. The icon and the chip outline are the whole affordance: without them
/// a bare value reads as static text and users never try to tap it.
class PillFieldWidget extends StatelessWidget {
  final IconData icon;
  final Widget child;
  final VoidCallback onTap;
  final String? semanticLabel;

  const PillFieldWidget({
    super.key,
    required this.icon,
    required this.child,
    required this.onTap,
    this.semanticLabel,
  });

  @override
  Widget build(BuildContext context) {
    final shape = ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.md * 2),
    );

    Widget pill = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm + AppSpacing.xs,
      ),
      decoration: ShapeDecoration(
        color: AppColors.backgroundSurface,
        shape: shape,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: AppSpacing.md, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Flexible(child: child),
        ],
      ),
    );

    /// Same outer-squircle trick as RoundedBorderWidget: a BorderSide on a
    /// ContinuousRectangleBorder leaves whisker artifacts at the corners.
    pill = Container(
      padding: const EdgeInsets.all(1),
      decoration: ShapeDecoration(
        color: AppColors.backgroundStroke,
        shape: shape,
      ),
      child: pill,
    );

    return Semantics(
      button: true,
      label: semanticLabel,
      child: InkWell(
        onTap: onTap,
        customBorder: shape,
        child: pill,
      ),
    );
  }
}

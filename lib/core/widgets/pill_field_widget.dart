import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class PillFieldWidget extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  final String? semanticLabel;
  final bool showBorder;

  const PillFieldWidget({
    super.key,
    required this.child,
    required this.onTap,
    this.semanticLabel,
    this.showBorder = true,
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
        color: showBorder ? AppColors.backgroundSurface : Colors.transparent,
        shape: shape,
      ),
      child: Center(child: child),
    );

    if (showBorder) {
      pill = Container(
        padding: const EdgeInsets.all(1),
        decoration: ShapeDecoration(
          color: AppColors.backgroundStroke,
          shape: shape,
        ),
        child: pill,
      );
    }

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

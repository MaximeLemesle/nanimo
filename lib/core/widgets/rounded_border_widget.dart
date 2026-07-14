import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

class RoundedBorderWidget extends StatelessWidget {
  final Widget child;
  final Color backgroundColor;
  final Color borderColor;
  final double borderWidth;
  final EdgeInsetsGeometry padding;
  final bool fullWidth;
  final VoidCallback? onTap;

  const RoundedBorderWidget({
    super.key,
    required this.child,
    this.backgroundColor = AppColors.backgroundSurface,
    this.borderColor = Colors.transparent,
    this.borderWidth = 1,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.fullWidth = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final shape = ContinuousRectangleBorder(
      borderRadius: BorderRadius.circular(AppRadius.lg * 2),
    );

    Widget card = Container(
      padding: padding,
      decoration: ShapeDecoration(color: backgroundColor, shape: shape),
      child: child,
    );

    /// Border drawn as an outer filled squircle, not a BorderSide:
    /// ContinuousRectangleBorder.side leaves whisker artifacts at the corners.
    final hasBorder = borderColor != Colors.transparent && borderWidth > 0;
    if (hasBorder) {
      card = Container(
        padding: EdgeInsets.all(borderWidth),
        decoration: ShapeDecoration(color: borderColor, shape: shape),
        child: card,
      );
    }

    if (fullWidth) {
      card = SizedBox(width: double.infinity, child: card);
    }

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      customBorder: shape,
      child: card,
    );
  }
}

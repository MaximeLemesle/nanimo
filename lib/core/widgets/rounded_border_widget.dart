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
      side: BorderSide(color: borderColor, width: borderWidth),
    );

    final card = Container(
      width: fullWidth ? double.infinity : null,
      padding: padding,
      decoration: ShapeDecoration(color: backgroundColor, shape: shape),
      child: child,
    );

    if (onTap == null) return card;

    return InkWell(
      onTap: onTap,
      customBorder: shape,
      child: card,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_radius.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

enum ButtonType { primary, secondary }

enum ButtonState { normal, active, disabled }

enum ButtonIcon { none, right, left, only }

class ButtonWidget extends StatefulWidget {
  final String? label;
  final VoidCallback? onPressed;
  final ButtonType type;
  final ButtonState state;
  final ButtonIcon? iconPosition;
  final IconData? icon;
  final bool isLoading;
  final bool fullWidth;

  const ButtonWidget({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = ButtonType.primary,
    this.state = ButtonState.normal,
    this.iconPosition = ButtonIcon.none,
    this.icon = Icons.add,
    this.isLoading = false,
    this.fullWidth = false,
  });

  @override
  State<ButtonWidget> createState() => _ButtonWidgetState();
}

class _ButtonWidgetState extends State<ButtonWidget> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final effectiveState = (_isPressed && widget.state == ButtonState.normal)
        ? ButtonState.active
        : widget.state;

    late Color backgroundColor;
    late Color textColor;

    switch (widget.type) {
      case ButtonType.primary:
        switch (effectiveState) {
          case ButtonState.normal:
            backgroundColor = AppColors.primary;
            textColor = AppColors.textInvert;
            break;
          case ButtonState.active:
            backgroundColor = AppColors.primary700;
            textColor = AppColors.textInvert;
            break;
          case ButtonState.disabled:
            backgroundColor = AppColors.neutral100;
            textColor = AppColors.textSecondary;
            break;
        }

      case ButtonType.secondary:
        switch (effectiveState) {
          case ButtonState.normal:
            backgroundColor = AppColors.neutral50;
            textColor = AppColors.textPrimary;
            break;
          case ButtonState.active:
            backgroundColor = AppColors.primary100;
            textColor = AppColors.textPrimary;
            break;
          case ButtonState.disabled:
            backgroundColor = AppColors.primary50;
            textColor = AppColors.textSecondary;
            break;
        }
    }

    return Listener(
      onPointerDown: (widget.state == ButtonState.disabled || widget.isLoading)
          ? null
          : (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: SizedBox(
        width: widget.fullWidth ? double.infinity : null,
        height: 52,
        child: FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: backgroundColor,
            splashFactory: NoSplash.splashFactory,
            shape: ContinuousRectangleBorder(
              borderRadius: BorderRadius.circular(AppRadius.md * 2),
            ),
          ),
          onPressed: (widget.state == ButtonState.disabled || widget.isLoading)
              ? null
              : widget.onPressed,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: widget.fullWidth
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              widget.isLoading
                  ? SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(textColor),
                      ),
                    )
                  : _getButtonContent(context, textColor),
            ],
          ),
        ),
      ),
    );
  }

  /// Change the content depending of the icon position
  _getButtonContent(BuildContext context, Color textColor) {
    switch (widget.iconPosition) {
      case ButtonIcon.only:
        return Icon(widget.icon, color: textColor, size: AppSpacing.lg);
      case ButtonIcon.left:
        return Row(
          spacing: AppSpacing.md,
          children: [
            Icon(widget.icon, color: textColor, size: AppSpacing.lg),
            Text(
              widget.label!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: textColor),
            ),
          ],
        );
      case ButtonIcon.right:
        return Row(
          spacing: AppSpacing.md,
          children: [
            Text(
              widget.label!,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: textColor),
            ),
            Icon(widget.icon, color: textColor, size: AppSpacing.lg),
          ],
        );
      case ButtonIcon.none:
      case null:
        return Text(
          widget.label!,
          textAlign: TextAlign.center,
          style: Theme.of(context)
              .textTheme
              .titleLarge
              ?.copyWith(color: textColor),
        );
    }
  }
}

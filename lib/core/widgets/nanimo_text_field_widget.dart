import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';

/// Text field borderless nanimo style
class NanimoTextFieldWidget extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final TextCapitalization textCapitalization;

  const NanimoTextFieldWidget({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.onChanged,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.words,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          cursorHeight: 32,
          style: textTheme.displayLarge?.copyWith(
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: textTheme.displayLarge?.copyWith(
              color: AppColors.textSecondary,
            ),
            isCollapsed: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';

/// The control that puts a diary section into selection mode, and takes it out.
///
/// Shared so the diary sections cannot drift apart in icon size or placement.
class PetDiaryEditButtonWidget extends StatelessWidget {
  final bool isSelecting;
  final VoidCallback onPressed;
  final String tooltip;

  const PetDiaryEditButtonWidget({
    super.key,
    required this.onPressed,
    required this.tooltip,
    this.isSelecting = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      visualDensity: VisualDensity.compact,
      icon: Icon(isSelecting ? Icons.close_rounded : Icons.edit_outlined, size: 20),
      color: isSelecting ? AppColors.primary : AppColors.textSecondary,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

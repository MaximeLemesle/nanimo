import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';

/// The pencil that reopens a diary entry for editing.
///
/// Shared so the three diary tables cannot drift apart in size or placement.
class PetDiaryEditButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  final String tooltip;

  const PetDiaryEditButtonWidget({super.key, required this.onPressed, required this.tooltip});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
      visualDensity: VisualDensity.compact,
      icon: const Icon(Icons.edit_outlined, size: 20),
      color: AppColors.textSecondary,
      tooltip: tooltip,
      onPressed: onPressed,
    );
  }
}

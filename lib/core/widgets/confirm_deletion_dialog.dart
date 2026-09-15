import 'package:flutter/material.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';

/// Returns false on a dismissed dialog.
Future<bool> confirmDeletion(
  BuildContext context, {
  required String title,
  required String message,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.backgroundSurface,
      title: Text(title, style: AppTextStyles.title03),
      content: Text(message, style: AppTextStyles.text),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(false),
          child: Text(
            'Annuler',
            style:
                AppTextStyles.textBold.copyWith(color: AppColors.textSecondary),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(dialogContext).pop(true),
          child: Text(
            'Supprimer',
            style:
                AppTextStyles.textBold.copyWith(color: AppColors.secondary600),
          ),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}

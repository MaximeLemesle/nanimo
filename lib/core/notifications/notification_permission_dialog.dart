import 'package:flutter/material.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/widgets/button_widget.dart';

/// Saves a reminder only after the owner can actually receive it.
Future<bool> ensureReminderPermission(BuildContext context) async {
  final permission = await notificationPriming.permissionState();
  if (permission == NotificationPermissionState.granted) {
    await notificationPriming.enableReminders();
    return true;
  }
  if (!context.mounted) return false;
  final blocked = permission == NotificationPermissionState.denied;
  final accepted = await showDialog<bool>(
    context: context,
    builder: (dialogContext) => AlertDialog(
      backgroundColor: AppColors.backgroundSurface,
      title: Text('Activer les notifications', style: AppTextStyles.title02),
      content: Text(
        blocked
            ? 'Active les notifications de Nanimo dans les réglages de ton téléphone, puis reviens programmer ton rappel.'
            : 'Autorise les notifications pour recevoir ton rappel au moment choisi.',
        style: AppTextStyles.text,
      ),
      actions: [
        ButtonWidget(
          label: 'Plus tard',
          type: ButtonType.secondary,
          onPressed: () => Navigator.of(dialogContext).pop(false),
        ),
        const SizedBox(height: AppSpacing.sm),
        ButtonWidget(
          label: blocked ? 'Ouvrir les réglages' : 'Activer les notifications',
          onPressed: () => Navigator.of(dialogContext).pop(true),
        ),
      ],
    ),
  );
  if (accepted != true) return false;
  if (blocked) {
    await notificationPriming.openSystemSettings();
    return false;
  }
  return notificationPriming.accept();
}

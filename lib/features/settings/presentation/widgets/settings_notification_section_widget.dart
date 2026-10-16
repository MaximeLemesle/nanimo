import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/widgets/label_widget.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

/// NAN-070 guard, lifted by the local reminders of NAN-106.
const bool kNotificationsWired = true;

class SettingsNotificationSectionWidget extends StatelessWidget {
  static const String comingSoonMessage = 'Ça arrive bientôt';

  final NotificationPrefsModel prefs;

  const SettingsNotificationSectionWidget({super.key, required this.prefs});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(
            children: [
              Text('Notifications', style: AppTextStyles.title03),
              if (!kNotificationsWired) ...[
                const SizedBox(width: AppSpacing.sm),
                const LabelWidget(
                  label: 'Bientôt',
                  backgroundColor: AppColors.backgroundStroke,
                  labelColor: AppColors.textSecondary,
                ),
              ],
            ],
          ),
        ),
        const _BlockedBySystemTile(),
        _toggleTile(
          context,
          title: 'Tous les rappels',
          value: kNotificationsWired
              ? 'Rappels santé et anniversaires'
              : 'Rappels santé et anniversaires, on y travaille',
          isOn: prefs.pushEnabled,
          update: (enabled) => prefs.copyWith(pushEnabled: enabled),
        ),
        const SizedBox(height: AppSpacing.sm),
        _toggleTile(
          context,
          title: 'Vaccins',
          isOn: prefs.vaccineReminders,
          update: (enabled) => prefs.copyWith(vaccineReminders: enabled),
          requiresPush: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        _toggleTile(
          context,
          title: 'Visites vétérinaires',
          isOn: prefs.vetReminders,
          update: (enabled) => prefs.copyWith(vetReminders: enabled),
          requiresPush: true,
        ),
        const SizedBox(height: AppSpacing.sm),
        _toggleTile(
          context,
          title: 'Anniversaires',
          isOn: prefs.anniversaryReminders,
          update: (enabled) => prefs.copyWith(anniversaryReminders: enabled),
          requiresPush: true,
        ),
      ],
    );
  }

  Widget _toggleTile(
    BuildContext context, {
    required String title,
    required bool isOn,
    required NotificationPrefsModel Function(bool) update,
    String? value,
    bool requiresPush = false,
  }) {
    final locked = !kNotificationsWired;

    return SettingsTileWidget(
      title: title,
      value: value,
      onTap: locked ? () => _showComingSoon(context) : null,
      trailing: Opacity(
        opacity: locked ? 0.6 : 1,
        child: CupertinoSwitch(
          value: !locked && isOn,
          onChanged: locked
              ? (_) => _showComingSoon(context)
              : requiresPush && !prefs.pushEnabled
                  ? null
                  : (enabled) => context.read<SettingsCubit>().updateNotificationPrefs(update(enabled)),
          activeTrackColor: AppColors.primary,
        ),
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(const SnackBar(content: Text(comingSoonMessage)));
  }
}

/// The system prompt shows once on iOS: after a "no", only the phone's
/// settings can turn notifications back on (NAN-107).
class _BlockedBySystemTile extends StatelessWidget {
  static const title = 'Notifications bloquées sur ce téléphone';

  const _BlockedBySystemTile();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<NotificationPermissionState>(
      future: notificationPriming.permissionState(),
      builder: (context, snapshot) {
        if (snapshot.data != NotificationPermissionState.denied) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: SettingsTileWidget(
            title: title,
            value: 'Ouvrir les réglages du téléphone',
            onTap: notificationPriming.openSystemSettings,
            trailing: const Icon(Icons.open_in_new, color: AppColors.textSecondary),
          ),
        );
      },
    );
  }
}

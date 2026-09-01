import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/label_widget.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

/// NAN-070 temporary guard: nothing sends notifications yet, so the toggles
/// promise a feature that does not exist. Flip to true with the V2 FCM wiring,
/// it is the only change needed to give the section back its behaviour.
const bool kNotificationsWired = false;

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
        _toggleTile(
          context,
          title: 'Notifications push',
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
          title: 'Vermifuges',
          isOn: prefs.dewormingReminders,
          update: (enabled) => prefs.copyWith(dewormingReminders: enabled),
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

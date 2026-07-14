import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/settings/data/models/notification_prefs_model.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

class SettingsNotificationSectionWidget extends StatelessWidget {
  final NotificationPrefsModel prefs;

  const SettingsNotificationSectionWidget({super.key, required this.prefs});
  @override
  Widget build(BuildContext context) {
    final cubit = context.read<SettingsCubit>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text('Notifications', style: AppTextStyles.title03),
        ),
        SettingsTileWidget(
          title: 'Notifications push',
          value: 'Rappels santé et anniversaires',
          trailing: CupertinoSwitch(
            value: prefs.pushEnabled,
            onChanged: (value) => cubit.updateNotificationPrefs(
              prefs.copyWith(pushEnabled: value),
            ),
            activeTrackColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsTileWidget(
          title: 'Vaccins',
          trailing: CupertinoSwitch(
            value: prefs.vaccineReminders,
            onChanged: prefs.pushEnabled
                ? (value) => cubit.updateNotificationPrefs(
                      prefs.copyWith(vaccineReminders: value),
                    )
                : null,
            activeTrackColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsTileWidget(
          title: 'Visites vétérinaires',
          trailing: CupertinoSwitch(
            value: prefs.vetReminders,
            onChanged: prefs.pushEnabled
                ? (value) => cubit.updateNotificationPrefs(
                      prefs.copyWith(vetReminders: value),
                    )
                : null,
            activeTrackColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsTileWidget(
          title: 'Vermifuges',
          trailing: CupertinoSwitch(
            value: prefs.dewormingReminders,
            onChanged: prefs.pushEnabled
                ? (value) => cubit.updateNotificationPrefs(
                      prefs.copyWith(dewormingReminders: value),
                    )
                : null,
            activeTrackColor: AppColors.primary,
          ),
        ),
        const SizedBox(height: AppSpacing.sm),
        SettingsTileWidget(
          title: 'Anniversaires',
          trailing: CupertinoSwitch(
            value: prefs.anniversaryReminders,
            onChanged: prefs.pushEnabled
                ? (value) => cubit.updateNotificationPrefs(
                      prefs.copyWith(anniversaryReminders: value),
                    )
                : null,
            activeTrackColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

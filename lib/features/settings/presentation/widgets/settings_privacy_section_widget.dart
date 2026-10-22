import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

class SettingsPrivacySectionWidget extends StatelessWidget {
  static const String toggleTitle = 'Statistiques d\'usage';

  final bool analyticsEnabled;

  const SettingsPrivacySectionWidget({super.key, required this.analyticsEnabled});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text('Confidentialité', style: AppTextStyles.title03),
        ),
        SettingsTileWidget(
          title: toggleTitle,
          value: 'Aide à améliorer Nanimo, sans le contenu de vos souvenirs',
          trailing: CupertinoSwitch(
            value: analyticsEnabled,
            onChanged: context.read<SettingsCubit>().setAnalyticsEnabled,
            activeTrackColor: AppColors.primary,
          ),
        ),
      ],
    );
  }
}

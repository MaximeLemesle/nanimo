import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/label_widget.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_footer_widget.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_notification_section_widget.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_edit_name_bottom_sheet_widget.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SettingsCubit, SettingsState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage && current.errorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        context.read<SettingsCubit>().clearError();
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            title: Text('Paramètres', style: AppTextStyles.title03),
          ),
          body: state.status == SettingsStatus.loading
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text('Mon compte', style: AppTextStyles.title03),
                    ),
                    SettingsTileWidget(
                      title: 'Prénom',
                      value: state.user?.userName.trim(),
                      trailing: const Icon(
                        Icons.edit_rounded,
                        size: 20,
                        color: AppColors.textSecondary,
                      ),
                      onTap: () => SettingsEditNameBottomSheetWidget.show(
                        context,
                        initialName: state.user?.userName ?? '',
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    SettingsTileWidget(
                      title: 'Email',
                      value: state.user?.mail ?? '—',
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Text('Abonnement', style: AppTextStyles.title03),
                    ),
                    SettingsTileWidget(
                      title: 'Formule',
                      value: state.user?.subscriptionStatus != SubscriptionStatus.premium
                          ? 'Gratuite'
                          : state.user?.subscriptionExpiresAt == null
                              ? 'Active'
                              : 'Jusqu\'au ${DateFormatter.date(state.user!.subscriptionExpiresAt!)}',
                      trailing: LabelWidget(
                        label: state.user?.subscriptionStatus == SubscriptionStatus.premium ? 'Premium' : 'Freemium',
                        backgroundColor: state.user?.subscriptionStatus == SubscriptionStatus.premium
                            ? AppColors.tertiary100
                            : AppColors.backgroundStroke,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SettingsNotificationSectionWidget(prefs: state.prefs),
                    const SizedBox(height: AppSpacing.xl),
                    ButtonWidget(
                      type: ButtonType.secondary,
                      icon: Icons.logout_rounded,
                      iconPosition: ButtonIcon.left,
                      label: 'Se déconnecter',
                      onPressed: () => context.read<AuthCubit>().logout(),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    ButtonWidget(
                      type: ButtonType.delete,
                      icon: Icons.delete_outline_rounded,
                      iconPosition: ButtonIcon.left,
                      label: 'Supprimer mon compte',
                      onPressed: () => _confirmDeletion(context),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    SettingsFooterWidget(),
                  ],
                ),
        );
      },
    );
  }

  Future<void> _confirmDeletion(BuildContext context) async {
    final cubit = context.read<SettingsCubit>();
    if (cubit.state.isDeleting) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.backgroundSurface,
        title: Text('Supprimer votre compte ?', style: AppTextStyles.title03),
        content: Text(
          'Vos animaux, souvenirs et données de santé seront définitivement supprimés. Cette action est irréversible.',
          style: AppTextStyles.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: Text('Annuler', style: AppTextStyles.textBold),
          ),
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            child: Text(
              'Supprimer',
              style: AppTextStyles.textBold.copyWith(color: AppColors.secondary600),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) await cubit.deleteAccount();
  }
}

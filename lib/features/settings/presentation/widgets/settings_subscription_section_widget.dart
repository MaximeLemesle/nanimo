import 'dart:developer' as developer;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/core/widgets/label_widget.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/widgets/settings_tile_widget.dart';

const String appStoreSubscriptionsUrl =
    'https://apps.apple.com/account/subscriptions';

const String playStoreSubscriptionsUrl =
    'https://play.google.com/store/account/subscriptions';

class SettingsSubscriptionSectionWidget extends StatelessWidget {
  final SettingsState state;

  /// Injected by the tests, which have no store app to hand over to.
  final Future<bool> Function(Uri url)? onOpenStore;

  const SettingsSubscriptionSectionWidget({
    super.key,
    required this.state,
    this.onOpenStore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.md),
          child: Text('Abonnement', style: AppTextStyles.title03),
        ),
        SettingsTileWidget(
          title: 'Formule',
          value: _planValue(),
          trailing: LabelWidget(
            label: state.isPremium ? 'Premium' : 'Freemium',
            backgroundColor: state.isPremium
                ? AppColors.tertiary100
                : AppColors.backgroundStroke,
          ),
        ),
        if (state.isSubscriptionLoaded && state.isPremium) ...[
          const SizedBox(height: AppSpacing.sm),
          SettingsTileWidget(
            title: 'Gérer mon abonnement',
            value: 'Changer de formule ou résilier',
            trailing: const Icon(
              Icons.open_in_new_rounded,
              size: 20,
              color: AppColors.textSecondary,
            ),
            onTap: () => _openStore(context),
          ),
        ],
        if (state.isSubscriptionLoaded && !state.isPremium) ...[
          const SizedBox(height: AppSpacing.md),
          ButtonWidget(
            label: 'Passer premium',
            fullWidth: true,
            onPressed: () => context.push(RouteNames.paywall),
          ),
        ],
        const SizedBox(height: AppSpacing.md),
        SettingsTileWidget(
          title: 'Restaurer mes achats',
          value: 'Retrouve un abonnement déjà payé',
          trailing: state.isRestoring
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Icon(
                  Icons.restore_rounded,
                  size: 20,
                  color: AppColors.textSecondary,
                ),
          onTap: state.isRestoring
              ? null
              : () => context.read<SettingsCubit>().restorePurchases(),
        ),
      ],
    );
  }

  String _planValue() {
    if (!state.isPremium) return 'Gratuite';
    final expiresAt = state.user?.subscriptionExpiresAt;
    if (expiresAt == null) return 'Active';
    return 'Jusqu\'au ${DateFormatter.date(expiresAt)}';
  }

  Uri _storeUri(BuildContext context) {
    final isIos = Theme.of(context).platform == TargetPlatform.iOS;
    return Uri.parse(isIos ? appStoreSubscriptionsUrl : playStoreSubscriptionsUrl);
  }

  Future<void> _openStore(BuildContext context) async {
    final uri = _storeUri(context);
    final open = onOpenStore ??
        (Uri target) => launchUrl(target, mode: LaunchMode.externalApplication);

    bool opened;
    try {
      opened = await open(uri);
    } catch (e, st) {
      developer.log('could not open $uri',
          name: 'settings', error: e, stackTrace: st);
      opened = false;
    }

    if (opened || !context.mounted) return;
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        const SnackBar(
          content: Text('Impossible d’ouvrir les réglages d’abonnement.'),
        ),
      );
  }
}

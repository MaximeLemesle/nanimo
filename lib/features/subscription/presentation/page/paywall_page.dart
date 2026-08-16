import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_legal_links_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_offer_card_widget.dart';

class PaywallPage extends StatelessWidget {
  final Future<bool> Function(Uri url)? onOpenLegalLink;

  const PaywallPage({super.key, this.onOpenLegalLink});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage || previous.status != current.status,
      listener: (context, state) {
        if (state.errorMessage != null && state.status != PaywallStatus.error) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<PaywallCubit>().clearError();
        }

        if (state.isUnlocked) {
          final message = state.status == PaywallStatus.restored ? 'Ton abonnement a été restauré.' : 'Bienvenue dans Nanimo Premium.';
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(child: _body(context, state)),
        );
      },
    );
  }

  Widget _body(BuildContext context, PaywallState state) {
    if (state.status == PaywallStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PaywallStatus.error) {
      return _errorView(context, state);
    }

    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                0,
                AppSpacing.lg,
                AppSpacing.sm,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close_rounded),
                      color: AppColors.textPrimary,
                      tooltip: 'Fermer',
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const PaywallMemoriesWidget(),
                  const Spacer(),
                  Text(paywallTitle, style: AppTextStyles.title02),
                  Text(
                    paywallTagline,
                    style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  ...paywallBenefits.map(
                    (benefit) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Text.rich(
                        TextSpan(
                          text: '- ${benefit.subtitle} ',
                          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                          children: [
                            TextSpan(
                              text: benefit.title,
                              style: AppTextStyles.textBold,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ...state.offers.map(
                    (offer) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: PaywallOfferCardWidget(
                        offer: offer,
                        isSelected: offer.packageId == state.selectedPackageId,
                        onTap: () => context.read<PaywallCubit>().selectOffer(offer.packageId),
                      ),
                    ),
                  ),
                  const Spacer(),
                  ButtonWidget(
                    label: _ctaLabel(state.selectedOffer),
                    fullWidth: true,
                    isLoading: state.isPurchasing,
                    state: state.isBusy ? ButtonState.disabled : ButtonState.normal,
                    onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().purchase(),
                  ),
                  _restoreLink(context, state),
                  Text(
                    paywallLegalNotice,
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textSmall.copyWith(
                      fontSize: 10,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  PaywallLegalLinksWidget(onOpen: onOpenLegalLink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _restoreLink(BuildContext context, PaywallState state) {
    return TextButton(
      onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().restore(),
      child: state.isRestoring
          ? const SizedBox(
              height: 16,
              width: 16,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(
              'Restaurer mes achats',
              style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
            ),
    );
  }

  Widget _errorView(BuildContext context, PaywallState state) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topLeft,
          child: IconButton(
            icon: const Icon(Icons.close_rounded),
            color: AppColors.textPrimary,
            tooltip: 'Fermer',
            onPressed: () => Navigator.of(context).maybePop(),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  state.errorMessage ?? 'Les formules sont indisponibles.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: AppSpacing.lg),
                ButtonWidget(
                  label: 'Réessayer',
                  onPressed: () => context.read<PaywallCubit>().loadOffers(),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// A trial changes what the button promises: the user is not paying today.
  String _ctaLabel(PaywallOfferModel? offer) {
    if (offer == null) return 'Passer premium';
    if (offer.hasTrial) return 'Essayer ${offer.trialDays} jours gratuitement';
    return 'Passer premium';
  }
}

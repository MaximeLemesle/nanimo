import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/presentation/pending_premium_intent.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_confirming_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_legal_links_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_offer_card_widget.dart';

class PaywallPage extends StatefulWidget {
  final Future<bool> Function(Uri url)? onOpenLegalLink;

  /// NAN-093: pushed during the onboarding, before there is an account. The
  /// offer is shown but nothing can be charged, so the page sends to the signup
  /// and the choice is replayed there. Set by the route, never guessed.
  final bool isPreview;

  const PaywallPage({
    super.key,
    this.onOpenLegalLink,
    this.isPreview = false,
  });

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  bool _intentReplayed = false;

  bool get _isPreview => widget.isPreview;

  /// The owner asked to subscribe a few screens ago and now has an account.
  /// Apple's own sheet is the confirmation, so nothing is taken silently.
  void _replayPendingIntent(BuildContext context, PaywallState state) {
    if (_intentReplayed || _isPreview || !state.isLoaded) return;
    if (!pendingPremiumIntent.isPending) return;

    final packageId = pendingPremiumIntent.take();
    if (packageId == null) return;
    _intentReplayed = true;

    final cubit = context.read<PaywallCubit>();
    cubit.selectOffer(packageId);
    cubit.purchase();
  }

  void _rememberAndSignUp(BuildContext context, PaywallState state) {
    final packageId = state.selectedPackageId;
    if (packageId != null) pendingPremiumIntent.remember(packageId);
    context.go(RouteNames.signup);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) => previous.errorMessage != current.errorMessage || previous.status != current.status,
      listener: (context, state) {
        _replayPendingIntent(context, state);

        if (state.errorMessage != null && state.status != PaywallStatus.error) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<PaywallCubit>().clearError();
        }

        /// Restoring is not buying: no celebration, just say it and step aside.
        if (state.isRestored) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(content: Text('Ton abonnement a été restauré.')),
            );
          Navigator.of(context).maybePop();
        }

        /// Replaces the paywall instead of stacking on it, so the back gesture
        /// from the welcome page never lands back on the offers.
        if (state.isPurchaseComplete) {
          ScaffoldMessenger.of(context).clearSnackBars();
          GoRouter.of(context).pushReplacement(RouteNames.premiumWelcome);
        }
      },
      builder: (context, state) {
        return PopScope(
          /// The purchase is already paid for and in flight. Letting the user
          /// leave here would strand them between the store and the server.
          canPop: !state.isCompletingPurchase,
          child: Scaffold(
            backgroundColor: AppColors.background,
            body: SafeArea(
              child: state.isCompletingPurchase
                  ? const PaywallConfirmingWidget()
                  : _body(context, state),
            ),
          ),
        );
      },
    );
  }

  /// In preview the paywall was pushed over the onboarding, which the owner is
  /// leaving either way: dismissing it means "not now", not "go back a step".
  void _close(BuildContext context) {
    if (_isPreview) {
      pendingPremiumIntent.clear();
      context.go(RouteNames.signup);
      return;
    }
    Navigator.of(context).maybePop();
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
                      onPressed: () => _close(context),
                    ),
                  ),
                  const PaywallMemoriesWidget(isAnimated: true),
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
                    onPressed: state.isBusy
                        ? null
                        : () => _isPreview
                            ? _rememberAndSignUp(context, state)
                            : context.read<PaywallCubit>().purchase(),
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
                  PaywallLegalLinksWidget(onOpen: widget.onOpenLegalLink),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// Apple wants the restore reachable from any screen that sells. Without an
  /// account there is nothing to restore onto yet, so it leads to the login.
  Widget _restoreLink(BuildContext context, PaywallState state) {
    if (_isPreview) {
      return TextButton(
        onPressed: () => context.go(RouteNames.login),
        child: Text(
          'J\'ai déjà un abonnement',
          style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
        ),
      );
    }

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
            onPressed: () => _close(context),
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

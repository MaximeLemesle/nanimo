import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_confirming_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_legal_links_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_memories_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_offer_card_widget.dart';

class PaywallPage extends StatefulWidget {
  final Future<bool> Function(Uri url)? onOpenLegalLink;

  /// Last screen of the onboarding trial flow (NAN-113): it steps back to the
  /// reminder screen, and "Non merci" goes on to the app.
  final bool isOnboarding;

  const PaywallPage({
    super.key,
    this.onOpenLegalLink,
    this.isOnboarding = false,
  });

  @override
  State<PaywallPage> createState() => _PaywallPageState();
}

class _PaywallPageState extends State<PaywallPage> {
  bool get _isOnboarding => widget.isOnboarding;

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

        /// Restoring is not buying: no celebration, just say it and step aside.
        if (state.isRestored) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(
              const SnackBar(content: Text('Ton abonnement a été restauré.')),
            );
          _leave(context);
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

  /// The onboarding flow sits on top of the home page: leaving it for good
  /// means the app, not the trial screens under it.
  void _leave(BuildContext context) {
    if (_isOnboarding) {
      context.go(RouteNames.home);
      return;
    }
    Navigator.of(context).maybePop();
  }

  void _dismiss(BuildContext context, String reason) {
    analytics.capture(AnalyticsEvents.paywallDismissed, properties: {
      AnalyticsProperties.reason: reason,
      if (_isOnboarding) AnalyticsProperties.trigger: PaywallTrigger.onboarding,
    });
    _leave(context);
  }

  Widget _topButton(BuildContext context) {
    if (_isOnboarding) {
      return IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.arrow_back_rounded),
        color: AppColors.textPrimary,
        tooltip: 'Retour',
        onPressed: () => Navigator.of(context).maybePop(),
      );
    }
    return IconButton(
      padding: EdgeInsets.zero,
      icon: const Icon(Icons.close_rounded),
      color: AppColors.textPrimary,
      tooltip: 'Fermer',
      onPressed: () => _dismiss(context, 'close'),
    );
  }

  Widget _body(BuildContext context, PaywallState state) {
    if (state.status == PaywallStatus.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.status == PaywallStatus.error) {
      return _errorView(context, state);
    }

    final monthly = _offerOf(state, PaywallPeriod.monthly);
    final offers = [...state.offers]..sort((a, b) => _rank(a).compareTo(_rank(b)));

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
                  Align(alignment: Alignment.centerLeft, child: _topButton(context)),
                  const PaywallMemoriesWidget(isAnimated: true),
                  const SizedBox(height: AppSpacing.lg),
                  const Spacer(),
                  _title(_offerOf(state, PaywallPeriod.annual)),
                  const SizedBox(height: AppSpacing.md),
                  ...offers.map(
                    (offer) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: PaywallOfferCardWidget(
                        offer: offer,
                        isSelected: offer.packageId == state.selectedPackageId,
                        savingsPercent: offer.savingsAgainst(monthly),
                        onTap: () => context.read<PaywallCubit>().selectOffer(offer.packageId),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ButtonWidget(
                    label: paywallCta,
                    fullWidth: true,
                    isLoading: state.isPurchasing,
                    state: state.isBusy ? ButtonState.disabled : ButtonState.normal,
                    onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().purchase(),
                  ),
                  if (_isOnboarding)
                    TextButton(
                      onPressed: () => _dismiss(context, 'no_thanks'),
                      child: Text(
                        paywallNoThanks,
                        style: AppTextStyles.textBold.copyWith(color: AppColors.textSecondary),
                      ),
                    )
                  else
                    const SizedBox(height: AppSpacing.sm),
                  Text(
                    paywallLegalNotice(state.selectedOffer),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.textSmall.copyWith(
                      fontSize: 10,
                      height: 1.35,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  if (state.isRestoring)
                    const Padding(
                      padding: EdgeInsets.all(AppSpacing.sm),
                      child: Center(
                        child: SizedBox(height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2)),
                      ),
                    )
                  else
                    PaywallLegalLinksWidget(
                      onOpen: widget.onOpenLegalLink,
                      onRestore: state.isBusy ? null : () => context.read<PaywallCubit>().restore(),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// "Commence tes 14 jours gratuits", the trial in the brand colour. Without
  /// a trial on the annual plan, the plain product name.
  Widget _title(PaywallOfferModel? annual) {
    if (annual == null || !annual.hasTrial) {
      return Text(paywallTitle, textAlign: TextAlign.center, style: AppTextStyles.title02);
    }
    return Text.rich(
      TextSpan(
        text: 'Commence tes ',
        children: [
          TextSpan(
            text: '${annual.trialDays} jours gratuits',
            style: const TextStyle(color: AppColors.primary),
          ),
        ],
      ),
      textAlign: TextAlign.center,
      style: AppTextStyles.title02,
    );
  }

  /// Annual first: it is the plan that carries the trial.
  static int _rank(PaywallOfferModel offer) => switch (offer.period) {
        PaywallPeriod.annual => 0,
        PaywallPeriod.monthly => 1,
        PaywallPeriod.other => 2,
      };

  static PaywallOfferModel? _offerOf(PaywallState state, PaywallPeriod period) {
    for (final offer in state.offers) {
      if (offer.period == period) return offer;
    }
    return null;
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
            onPressed: () => _dismiss(context, 'close'),
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
}

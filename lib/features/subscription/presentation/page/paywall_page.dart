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

  /// At the end of onboarding, closing the standard paywall reaches the home.
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
              child: state.isCompletingPurchase ? const PaywallConfirmingWidget() : _body(context, state),
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

  Widget _topButton(BuildContext context) => IconButton(
        padding: EdgeInsets.zero,
        icon: const Icon(Icons.close_rounded),
        color: AppColors.textPrimary,
        tooltip: 'Fermer',
        onPressed: () => _dismiss(context, 'close'),
      );

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
                  Align(alignment: Alignment.centerRight, child: _topButton(context)),
                  const PaywallMemoriesWidget(isAnimated: true),
                  const Spacer(),
                  _title(state.offers),
                  const SizedBox(height: AppSpacing.md),
                  for (final line in [
                    ...paywallLines,
                    if (state.offers.any((offer) => offer.hasTrial)) paywallTrialReminder,
                  ])
                    Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(line.icon, style: AppTextStyles.text),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text.rich(TextSpan(
                              text: line.text,
                              style: AppTextStyles.text,
                              children: [
                                TextSpan(text: line.bold, style: AppTextStyles.textBold),
                              ],
                            )),
                          ),
                        ],
                      ),
                    ),
                  const Spacer(),
                  const SizedBox(height: AppSpacing.md),
                  ..._annualFirst(state.offers).map(
                    (offer) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                      child: PaywallOfferCardWidget(
                        offer: offer,
                        monthly: _monthly(state.offers),
                        isSelected: offer.packageId == state.selectedPackageId,
                        onTap: () => context.read<PaywallCubit>().selectOffer(offer.packageId),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  ButtonWidget(
                    label: _ctaLabel(state.selectedOffer),
                    fullWidth: true,
                    isLoading: state.isPurchasing,
                    state: state.isBusy ? ButtonState.disabled : ButtonState.normal,
                    onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().purchase(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SizedBox(
                    height: _legalHeight(context, state.offers, constraints.maxWidth - AppSpacing.lg * 2),
                    child: _legalNotice(state.selectedOffer),
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

  Widget _title(List<PaywallOfferModel> offers) {
    final trial = offers.where((offer) => offer.hasTrial).firstOrNull;
    return Text.rich(
      TextSpan(
        text: trial == null ? paywallTitle : paywallTrialTitleStart,
        children: [
          if (trial != null)
            TextSpan(
              text: paywallTrialTitleDays(trial.trialDays),
              style: const TextStyle(color: AppColors.primary),
            ),
        ],
      ),
      textAlign: TextAlign.center,
      style: AppTextStyles.title02,
    );
  }

  List<PaywallOfferModel> _annualFirst(List<PaywallOfferModel> offers) => [
        ...offers.where((offer) => offer.period == PaywallPeriod.annual),
        ...offers.where((offer) => offer.period != PaywallPeriod.annual),
      ];

  PaywallOfferModel? _monthly(List<PaywallOfferModel> offers) {
    for (final offer in offers) {
      if (offer.period == PaywallPeriod.monthly) return offer;
    }
    return null;
  }

  double _legalHeight(BuildContext context, List<PaywallOfferModel> offers, double width) {
    var height = 0.0;
    for (final offer in offers) {
      final painter = TextPainter(
        text: TextSpan(text: paywallLegalNotice(offer), style: _legalStyle),
        textDirection: Directionality.of(context),
        textScaler: MediaQuery.textScalerOf(context),
      )..layout(maxWidth: width);
      if (painter.height > height) height = painter.height;
      painter.dispose();
    }
    return height.ceilToDouble() + 2;
  }

  TextStyle get _legalStyle => AppTextStyles.textSmall.copyWith(fontSize: 10, height: 1.35, color: AppColors.textSecondary);

  Widget _legalNotice(PaywallOfferModel? offer) => Text(
        paywallLegalNotice(offer),
        textAlign: TextAlign.center,
        style: _legalStyle,
      );

  String _ctaLabel(PaywallOfferModel? offer) =>
      offer?.hasTrial == true ? 'Essayer ${offer!.trialDays} jours gratuitement' : 'Passer premium';

  Widget _errorView(BuildContext context, PaywallState state) {
    return Stack(
      children: [
        Align(
          alignment: Alignment.topRight,
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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/config/theme/app_colors.dart';
import 'package:nanimo/config/theme/app_spacing.dart';
import 'package:nanimo/config/theme/app_text_styles.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_benefit_widget.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_offer_card_widget.dart';

class PaywallPage extends StatelessWidget {
  const PaywallPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PaywallCubit, PaywallState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.status != current.status,
      listener: (context, state) {
        if (state.errorMessage != null && state.status != PaywallStatus.error) {
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(state.errorMessage!)));
          context.read<PaywallCubit>().clearError();
        }

        if (state.isUnlocked) {
          final message = state.status == PaywallStatus.restored
              ? 'Votre abonnement a été restauré.'
              : 'Bienvenue dans Nanimo Premium.';
          ScaffoldMessenger.of(context)
            ..clearSnackBars()
            ..showSnackBar(SnackBar(content: Text(message)));
          Navigator.of(context).maybePop();
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          appBar: AppBar(
            backgroundColor: AppColors.background,
            leading: IconButton(
              icon: const Icon(Icons.close_rounded),
              tooltip: 'Fermer',
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          body: _body(context, state),
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

    return ListView(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.lg,
        0,
        AppSpacing.lg,
        AppSpacing.xl,
      ),
      children: [
        Text('Nanimo Premium', style: AppTextStyles.title01),
        const SizedBox(height: AppSpacing.sm),
        Text(
          'Gardez chaque moment de tous vos animaux, sans limite qui vous arrête en plein souvenir.',
          style: AppTextStyles.text.copyWith(color: AppColors.textSecondary),
        ),
        const SizedBox(height: AppSpacing.xl),
        ...paywallBenefits.map((b) => PaywallBenefitWidget(benefit: b)),
        const SizedBox(height: AppSpacing.md),
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
        const SizedBox(height: AppSpacing.md),
        ButtonWidget(
          label: _ctaLabel(state.selectedOffer),
          fullWidth: true,
          isLoading: state.isPurchasing,
          state: state.isBusy ? ButtonState.disabled : ButtonState.normal,
          onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().purchase(),
        ),
        const SizedBox(height: AppSpacing.sm),
        ButtonWidget(
          type: ButtonType.secondary,
          label: 'Restaurer mes achats',
          fullWidth: true,
          isLoading: state.isRestoring,
          state: state.isBusy ? ButtonState.disabled : ButtonState.normal,
          onPressed: state.isBusy ? null : () => context.read<PaywallCubit>().restore(),
        ),
        const SizedBox(height: AppSpacing.lg),
        Text(
          paywallLegalNotice,
          style: AppTextStyles.textSmall.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _errorView(BuildContext context, PaywallState state) {
    return Center(
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
    );
  }

  /// A trial changes what the button promises: the user is not paying today.
  String _ctaLabel(PaywallOfferModel? offer) {
    if (offer == null) return 'Passer premium';
    if (offer.hasTrial) return 'Essayer ${offer.trialDays} jours gratuitement';
    return 'Passer premium';
  }
}

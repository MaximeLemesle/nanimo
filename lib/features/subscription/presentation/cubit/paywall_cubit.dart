import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

part 'paywall_state.dart';

class PaywallCubit extends Cubit<PaywallState> {
  final PurchaseRepository _purchaseRepository;
  final SubscriptionRestorer _restorer;

  PaywallCubit({
    required PurchaseRepository purchaseRepository,
    required AuthRepository authRepository,
    Duration confirmationTimeout = const Duration(seconds: 25),
    Duration pollInterval = const Duration(seconds: 2),
  })  : _purchaseRepository = purchaseRepository,
        _restorer = SubscriptionRestorer(
          purchaseRepository: purchaseRepository,
          authRepository: authRepository,
          confirmationTimeout: confirmationTimeout,
          pollInterval: pollInterval,
        ),
        super(const PaywallState.initial());

  Future<void> loadOffers() async {
    emit(const PaywallState.loading());
    try {
      final offers = await _purchaseRepository.getOffers();
      emit(PaywallState.loaded(
        offers: offers,
        selectedPackageId: _defaultSelection(offers),
      ));
    } catch (e, st) {
      developer.log('loadOffers failed', name: 'paywall', error: e, stackTrace: st);
      emit(PaywallState.error(e.toString()));
    }
  }

  void selectOffer(String packageId) {
    if (!state.isLoaded) return;
    analytics.capture(
      AnalyticsEvents.paywallOfferSelected,
      properties: {AnalyticsProperties.plan: _planOf(packageId)},
    );
    emit(state.copyWith(selectedPackageId: packageId));
  }

  Future<void> purchase() async {
    final packageId = state.selectedPackageId;
    if (!state.isLoaded || packageId == null || state.isBusy) return;

    final plan = _planOf(packageId);
    emit(state.copyWith(status: PaywallStatus.purchasing, clearError: true));
    analytics.capture(
      AnalyticsEvents.purchaseStarted,
      properties: {AnalyticsProperties.plan: plan},
    );

    try {
      final active = await _purchaseRepository.purchase(packageId);
      if (!active) {
        _trackPurchaseFailed(plan, 'not_active');
        emit(state.copyWith(
          status: PaywallStatus.loaded,
          errorMessage: 'L’achat n’a pas pu être confirmé. Aucun montant n’a été débité.',
        ));
        return;
      }

      /// From here the money is taken. Nothing below may emit an error state.
      emit(state.copyWith(status: PaywallStatus.confirming, clearError: true));

      final confirmed = await _restorer.awaitPremiumConfirmation();
      analytics.capture(AnalyticsEvents.purchaseCompleted, properties: {
        AnalyticsProperties.plan: plan,
        AnalyticsProperties.confirmed: confirmed,
      });
      if (!confirmed) {
        analytics.capture(AnalyticsEvents.premiumConfirmationTimeout);
      }
      emit(state.copyWith(
        status: confirmed ? PaywallStatus.purchased : PaywallStatus.purchasedPendingSync,
        clearError: true,
      ));
    } on PurchaseCancelledException {
      analytics.capture(
        AnalyticsEvents.purchaseCancelled,
        properties: {AnalyticsProperties.plan: plan},
      );
      emit(state.copyWith(status: PaywallStatus.loaded, clearError: true));
    } catch (e, st) {
      developer.log('purchase failed', name: 'paywall', error: e, stackTrace: st);
      _trackPurchaseFailed(plan, e.runtimeType.toString());
      emit(state.copyWith(
        status: PaywallStatus.loaded,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> restore() async {
    if (state.isBusy) return;
    emit(state.copyWith(status: PaywallStatus.restoring, clearError: true));
    analytics.capture(AnalyticsEvents.restoreStarted);

    final result = await _restorer.restore();
    analytics.capture(
      AnalyticsEvents.restoreFinished,
      properties: {AnalyticsProperties.restored: result.isRestored},
    );
    if (result.isRestored) {
      emit(state.copyWith(status: PaywallStatus.restored, clearError: true));
      return;
    }

    emit(state.copyWith(
      status: PaywallStatus.loaded,
      errorMessage: result.message,
    ));
  }

  /// Annual is the better deal, when offered.
  String? _defaultSelection(List<PaywallOfferModel> offers) {
    if (offers.isEmpty) return null;
    for (final offer in offers) {
      if (offer.period == PaywallPeriod.annual) return offer.packageId;
    }
    return offers.first.packageId;
  }

  void _trackPurchaseFailed(String plan, String reason) {
    analytics.capture(AnalyticsEvents.purchaseFailed, properties: {
      AnalyticsProperties.plan: plan,
      AnalyticsProperties.reason: reason,
    });
  }

  /// Reported as the plan family, never the raw package id, so the funnel
  /// survives a package being renamed in RevenueCat.
  String _planOf(String packageId) {
    for (final offer in state.offers) {
      if (offer.packageId == packageId) return offer.period.name;
    }
    return PaywallPeriod.other.name;
  }

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(clearError: true));
  }
}

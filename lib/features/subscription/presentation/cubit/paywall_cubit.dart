import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    Duration confirmationTimeout = const Duration(seconds: 12),
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
    emit(state.copyWith(selectedPackageId: packageId));
  }

  Future<void> purchase() async {
    final packageId = state.selectedPackageId;
    if (!state.isLoaded || packageId == null || state.isBusy) return;

    emit(state.copyWith(status: PaywallStatus.purchasing, clearError: true));

    try {
      final active = await _purchaseRepository.purchase(packageId);
      if (!active) {
        emit(state.copyWith(
          status: PaywallStatus.loaded,
          errorMessage:
              'L’achat n’a pas pu être confirmé. Aucun montant n’a été débité.',
        ));
        return;
      }
      await _restorer.awaitPremiumConfirmation();
      emit(state.copyWith(status: PaywallStatus.purchased, clearError: true));
    } on PurchaseCancelledException {
      emit(state.copyWith(status: PaywallStatus.loaded, clearError: true));
    } catch (e, st) {
      developer.log('purchase failed', name: 'paywall', error: e, stackTrace: st);
      emit(state.copyWith(
        status: PaywallStatus.loaded,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> restore() async {
    if (state.isBusy) return;
    emit(state.copyWith(status: PaywallStatus.restoring, clearError: true));

    final result = await _restorer.restore();
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

  void clearError() {
    if (state.errorMessage == null) return;
    emit(state.copyWith(clearError: true));
  }
}

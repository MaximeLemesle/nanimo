import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';

part 'paywall_state.dart';

class PaywallCubit extends Cubit<PaywallState> {
  final PurchaseRepository _purchaseRepository;
  final AuthRepository _authRepository;

  /// How long to wait for the webhook to flip the status server-side before
  /// unlocking the UI anyway. The store already confirmed the purchase at that
  /// point, so making the user wait longer would punish them for our latency.
  final Duration _confirmationTimeout;
  final Duration _pollInterval;

  PaywallCubit({
    required PurchaseRepository purchaseRepository,
    required AuthRepository authRepository,
    Duration confirmationTimeout = const Duration(seconds: 12),
    Duration pollInterval = const Duration(seconds: 2),
  })  : _purchaseRepository = purchaseRepository,
        _authRepository = authRepository,
        _confirmationTimeout = confirmationTimeout,
        _pollInterval = pollInterval,
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
      await _awaitServerConfirmation();
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

    try {
      final active = await _purchaseRepository.restore();
      if (!active) {
        emit(state.copyWith(
          status: PaywallStatus.loaded,
          errorMessage: 'Aucun abonnement à restaurer sur ce compte.',
        ));
        return;
      }
      await _awaitServerConfirmation();
      emit(state.copyWith(status: PaywallStatus.restored, clearError: true));
    } catch (e, st) {
      developer.log('restore failed', name: 'paywall', error: e, stackTrace: st);
      emit(state.copyWith(
        status: PaywallStatus.loaded,
        errorMessage: e.toString(),
      ));
    }
  }

  /// Polls the server until it reports premium, or until the timeout expires.
  ///
  /// The webhook usually lands in under a second, but it is out of our control.
  /// Each refresh write-throughs the Isar cache, so a success here is what makes
  /// the rest of the app switch to premium quotas.
  Future<void> _awaitServerConfirmation() async {
    final deadline = DateTime.now().add(_confirmationTimeout);

    while (DateTime.now().isBefore(deadline)) {
      try {
        final user = await _authRepository.refreshCurrentUser();
        if (user?.subscriptionStatus == SubscriptionStatus.premium) return;
      } catch (e, st) {
        developer.log('status refresh failed, retrying',
            name: 'paywall', error: e, stackTrace: st);
      }
      await Future<void>.delayed(_pollInterval);
    }

    developer.log('premium not confirmed server-side before timeout',
        name: 'paywall');
  }

  /// Annual is the better deal and the one worth defaulting to, but only if it
  /// is actually offered.
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

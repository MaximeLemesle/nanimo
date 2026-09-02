import 'dart:async';
import 'dart:developer' as developer;

import 'package:equatable/equatable.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';

enum RestoreOutcome { restored, nothingFound, failed }

class RestoreResult extends Equatable {
  final RestoreOutcome outcome;
  final String message;

  const RestoreResult(this.outcome, this.message);

  bool get isRestored => outcome == RestoreOutcome.restored;

  @override
  List<Object?> get props => [outcome, message];
}

/// Single restore path for the paywall and the settings screen, so both entry
/// points behave the same and say the same thing.
class SubscriptionRestorer {
  static const String restoredMessage = 'Ton abonnement a été restauré.';

  static const String nothingFoundMessage =
      'Aucun abonnement à restaurer sur ce compte.';

  static const String failureMessage =
      'La restauration a échoué. Réessaye dans un instant.';

  final PurchaseRepository _purchaseRepository;
  final AuthRepository _authRepository;

  /// After this, unlock anyway: the store already confirmed the purchase.
  final Duration _confirmationTimeout;
  final Duration _pollInterval;

  const SubscriptionRestorer({
    required PurchaseRepository purchaseRepository,
    required AuthRepository authRepository,
    Duration confirmationTimeout = const Duration(seconds: 12),
    Duration pollInterval = const Duration(seconds: 2),
  })  : _purchaseRepository = purchaseRepository,
        _authRepository = authRepository,
        _confirmationTimeout = confirmationTimeout,
        _pollInterval = pollInterval;

  /// An account that owns nothing is not an error: RevenueCat answers with a
  /// CustomerInfo carrying no active entitlement, hence [RestoreOutcome.nothingFound].
  Future<RestoreResult> restore() async {
    try {
      final active = await _purchaseRepository.restore();
      if (!active) {
        return const RestoreResult(
          RestoreOutcome.nothingFound,
          nothingFoundMessage,
        );
      }

      await awaitPremiumConfirmation();
      return const RestoreResult(RestoreOutcome.restored, restoredMessage);
    } catch (e, st) {
      developer.log('restore failed',
          name: 'subscription', error: e, stackTrace: st);
      return RestoreResult(
        RestoreOutcome.failed,
        e is RepositoryException ? e.message : failureMessage,
      );
    }
  }

  /// Each refresh write-throughs the Isar cache, which is what switches the
  /// rest of the app to premium quotas.
  Future<void> awaitPremiumConfirmation() async {
    final deadline = DateTime.now().add(_confirmationTimeout);

    while (DateTime.now().isBefore(deadline)) {
      try {
        final user = await _authRepository.refreshCurrentUser();
        if (user?.subscriptionStatus == SubscriptionStatus.premium) return;
      } catch (e, st) {
        developer.log('status refresh failed, retrying',
            name: 'subscription', error: e, stackTrace: st);
      }
      await Future<void>.delayed(_pollInterval);
    }

    developer.log('premium not confirmed server-side before timeout',
        name: 'subscription');
  }
}

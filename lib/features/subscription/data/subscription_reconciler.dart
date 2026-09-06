import 'dart:developer' as developer;

import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

/// Repairs the case where a purchase went through at the store but the
/// RevenueCat webhook never reached `users.subscription_status`.
///
/// That mismatch is not cosmetic: the quota triggers of
/// `0004_freemium_quota_triggers.sql` join `subscription_config` on that
/// column, so the user is refused a second pet by PostgreSQL despite having
/// paid. [PaywallCubit] gives the webhook 25 seconds before letting the user
/// go; this picks up whatever landed after that, on every resume and every
/// launch, until the two agree.
///
/// Nothing is persisted for this. The RevenueCat SDK already caches the
/// entitlement locally and that cache survives a relaunch, so the mismatch is
/// derivable at any time. It also means this repairs users who never went
/// through the paywall in this install, such as a reinstall on a new device.
class SubscriptionReconciler {
  final PurchaseRepository _purchaseRepository;
  final AuthRepository _authRepository;
  final SubscriptionRestorer _restorer;

  /// A resume can fire while a previous pass is still polling. Without this,
  /// backgrounding the app repeatedly would stack overlapping poll loops.
  bool _isRunning = false;

  SubscriptionReconciler({
    required PurchaseRepository purchaseRepository,
    required AuthRepository authRepository,
    Duration confirmationTimeout = const Duration(seconds: 25),
    Duration pollInterval = const Duration(seconds: 1),
  })  : _purchaseRepository = purchaseRepository,
        _authRepository = authRepository,
        _restorer = SubscriptionRestorer(
          purchaseRepository: purchaseRepository,
          authRepository: authRepository,
          confirmationTimeout: confirmationTimeout,
          pollInterval: pollInterval,
        );

  /// Silent by design: it runs on resume, so it must never surface a message.
  /// Whatever it fixes shows up through the usual cache stream.
  Future<void> reconcile() async {
    if (_isRunning) return;
    _isRunning = true;

    try {
      if (_authRepository.currentUserId == null) return;

      final user = await _authRepository.getCurrentUser();
      if (user == null) return;
      if (user.subscriptionStatus == SubscriptionStatus.premium) return;

      if (!await _purchaseRepository.isPremiumActive()) return;

      developer.log(
        'store holds premium but the server does not, re-checking',
        name: 'subscription',
      );
      final confirmed = await _restorer.awaitPremiumConfirmation();
      if (!confirmed) {
        developer.log(
          'premium still unconfirmed after reconciliation pass',
          name: 'subscription',
        );
      }
    } catch (e, st) {
      developer.log('reconciliation failed',
          name: 'subscription', error: e, stackTrace: st);
    } finally {
      _isRunning = false;
    }
  }
}

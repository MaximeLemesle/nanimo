import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_reconciler.dart';

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

UserModel _user(SubscriptionStatus status) => UserModel(
      userId: 'user-1',
      userName: 'Maxime',
      mail: 'maxime@example.com',
      subscriptionStatus: status,
    );

void main() {
  late _MockPurchaseRepository purchaseRepository;
  late _MockAuthRepository authRepository;

  SubscriptionReconciler buildReconciler() => SubscriptionReconciler(
        purchaseRepository: purchaseRepository,
        authRepository: authRepository,
        confirmationTimeout: const Duration(milliseconds: 40),
        pollInterval: const Duration(milliseconds: 10),
      );

  setUp(() {
    purchaseRepository = _MockPurchaseRepository();
    authRepository = _MockAuthRepository();
    when(() => authRepository.currentUserId).thenReturn('user-1');
  });

  test('does nothing when nobody is signed in', () async {
    when(() => authRepository.currentUserId).thenReturn(null);

    await buildReconciler().reconcile();

    verifyNever(() => purchaseRepository.isPremiumActive());
    verifyNever(() => authRepository.refreshCurrentUser());
  });

  /// The common case by far. It runs on every resume, so it must not spend a
  /// network round trip when the two sides already agree.
  test('does nothing when the server already says premium', () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    await buildReconciler().reconcile();

    verifyNever(() => purchaseRepository.isPremiumActive());
    verifyNever(() => authRepository.refreshCurrentUser());
  });

  test('does nothing for a freemium user the store agrees is freemium',
      () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));
    when(() => purchaseRepository.isPremiumActive())
        .thenAnswer((_) async => false);

    await buildReconciler().reconcile();

    verifyNever(() => authRepository.refreshCurrentUser());
  });

  /// The whole reason this class exists: the purchase went through, the
  /// webhook did not land, and the quota triggers would refuse the user the
  /// premium they paid for.
  test('re-polls when the store holds premium but the server does not',
      () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));
    when(() => purchaseRepository.isPremiumActive())
        .thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    await buildReconciler().reconcile();

    verify(() => authRepository.refreshCurrentUser()).called(1);
  });

  test('swallows a failure instead of surfacing it on resume', () async {
    when(() => authRepository.getCurrentUser()).thenThrow(Exception('offline'));

    await expectLater(buildReconciler().reconcile(), completes);
  });

  /// Backgrounding the app repeatedly must not stack overlapping poll loops.
  test('ignores a second pass while the first is still running', () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));
    when(() => purchaseRepository.isPremiumActive()).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 30));
      return true;
    });
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    final reconciler = buildReconciler();
    final first = reconciler.reconcile();
    final second = reconciler.reconcile();
    await Future.wait([first, second]);

    verify(() => purchaseRepository.isPremiumActive()).called(1);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_restorer.dart';

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

  SubscriptionRestorer buildRestorer() => SubscriptionRestorer(
        purchaseRepository: purchaseRepository,
        authRepository: authRepository,
        // Keeps the confirmation poll instant in tests.
        confirmationTimeout: const Duration(milliseconds: 60),
        pollInterval: const Duration(milliseconds: 10),
      );

  setUp(() {
    purchaseRepository = _MockPurchaseRepository();
    authRepository = _MockAuthRepository();
  });

  test('reports a restored subscription once the server confirms it', () async {
    when(() => purchaseRepository.restore()).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.restored);
    expect(result.isRestored, isTrue);
    expect(result.message, SubscriptionRestorer.restoredMessage);
    verify(() => authRepository.refreshCurrentUser()).called(1);
  });

  /// RevenueCat answers with an empty entitlement instead of throwing.
  test('reports nothing found without polling the server', () async {
    when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.nothingFound);
    expect(result.isRestored, isFalse);
    expect(result.message, SubscriptionRestorer.nothingFoundMessage);
    verifyNever(() => authRepository.refreshCurrentUser());
  });

  test('reports a failure with the repository message', () async {
    when(() => purchaseRepository.restore()).thenThrow(
        const RepositoryNetworkException('Une connexion internet est requise.'));

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.failed);
    expect(result.message, 'Une connexion internet est requise.');
  });

  test('reports a failure with a generic message on an untyped error', () async {
    when(() => purchaseRepository.restore()).thenThrow(Exception('boom'));

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.failed);
    expect(result.message, SubscriptionRestorer.failureMessage);
  });

  test('gives up polling after the timeout and still reports a restore',
      () async {
    when(() => purchaseRepository.restore()).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.restored);
    verify(() => authRepository.refreshCurrentUser()).called(greaterThan(1));
  });

  test('a refresh that throws does not abort the confirmation', () async {
    when(() => purchaseRepository.restore()).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser()).thenThrow(Exception('offline'));

    final result = await buildRestorer().restore();

    expect(result.outcome, RestoreOutcome.restored);
  });

  test('two identical results compare equal', () {
    expect(
      const RestoreResult(RestoreOutcome.restored, 'a'),
      const RestoreResult(RestoreOutcome.restored, 'a'),
    );
    expect(
      const RestoreResult(RestoreOutcome.restored, 'a'),
      isNot(const RestoreResult(RestoreOutcome.failed, 'a')),
    );
  });
}

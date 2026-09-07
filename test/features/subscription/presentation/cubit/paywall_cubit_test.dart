import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

const _monthly = PaywallOfferModel(
  packageId: '\$rc_monthly',
  period: PaywallPeriod.monthly,
  priceLabel: '4,99 €',
  trialDays: 7,
);

const _annual = PaywallOfferModel(
  packageId: '\$rc_annual',
  period: PaywallPeriod.annual,
  priceLabel: '39,99 €',
  trialDays: 7,
);

UserModel _user(SubscriptionStatus status) => UserModel(
      userId: 'user-1',
      userName: 'Maxime',
      mail: 'maxime@example.com',
      subscriptionStatus: status,
    );

void main() {
  late _MockPurchaseRepository purchaseRepository;
  late _MockAuthRepository authRepository;

  PaywallCubit buildCubit() => PaywallCubit(
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

  group('loadOffers', () {
    test('exposes the offers and preselects the annual plan', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_monthly, _annual]);

      final cubit = buildCubit();
      await cubit.loadOffers();

      expect(cubit.state.status, PaywallStatus.loaded);
      expect(cubit.state.offers, [_monthly, _annual]);
      expect(cubit.state.selectedPackageId, _annual.packageId);
    });

    test('falls back to the first offer when there is no annual plan', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_monthly]);

      final cubit = buildCubit();
      await cubit.loadOffers();

      expect(cubit.state.selectedPackageId, _monthly.packageId);
    });

    test('surfaces an error state when the store is unreachable', () async {
      when(() => purchaseRepository.getOffers()).thenThrow(
          const RepositoryNetworkException('Pas de connexion internet.'));

      final cubit = buildCubit();
      await cubit.loadOffers();

      expect(cubit.state.status, PaywallStatus.error);
      expect(cubit.state.errorMessage, contains('connexion'));
    });
  });

  group('purchase', () {
    test('unlocks premium once the server confirms the new status', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_monthly, _annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.purchased);
      expect(cubit.state.isUnlocked, isTrue);
      verify(() => purchaseRepository.purchase(_annual.packageId)).called(1);
    });

    test('buys the plan the user selected, not the default', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_monthly, _annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      cubit.selectOffer(_monthly.packageId);
      await cubit.purchase();

      verify(() => purchaseRepository.purchase(_monthly.packageId)).called(1);
      verifyNever(() => purchaseRepository.purchase(_annual.packageId));
    });

    test('a cancelled purchase leaves no error on screen', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenThrow(const PurchaseCancelledException());

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.loaded);
      expect(cubit.state.errorMessage, isNull);
      expect(cubit.state.isUnlocked, isFalse);
    });

    test('a store failure keeps the user on the paywall with a message',
        () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any())).thenThrow(
          const RepositoryServerException('Le store est indisponible.'));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.loaded);
      expect(cubit.state.errorMessage, contains('store'));
      expect(cubit.state.isUnlocked, isFalse);
    });

    /// The store charged the user but the webhook never landed. This must not
    /// come out as a plain `purchased`: the quota triggers read
    /// `users.subscription_status`, so the app would promise premium and then
    /// let PostgreSQL refuse the very next premium action.
    test('separates a paid purchase the server has not confirmed', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.freemium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.purchasedPendingSync);
      expect(cubit.state.isPremiumConfirmed, isFalse);
      verify(() => authRepository.refreshCurrentUser()).called(greaterThan(1));
    });

    /// Both outcomes reach the welcome page. Never an error state: the money is
    /// taken either way, and telling the user otherwise invites a double
    /// purchase or a support ticket.
    test('a pending confirmation still counts as a completed purchase',
        () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.freemium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.isPurchaseComplete, isTrue);
      expect(cubit.state.errorMessage, isNull);
    });

    test('a refresh that throws does not abort the confirmation', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenThrow(Exception('offline'));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.purchasedPendingSync);
    });

    test('confirms premium when the server flips in time', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.purchase();

      expect(cubit.state.status, PaywallStatus.purchased);
      expect(cubit.state.isPremiumConfirmed, isTrue);
    });

    /// The phase the waiting screen hangs off. Without it the paywall cannot
    /// tell "the store sheet is up" from "we are waiting on our own server".
    test('passes through confirming between the store and the server',
        () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any()))
          .thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();

      final seen = <PaywallStatus>[];
      final sub = cubit.stream.listen((state) => seen.add(state.status));
      await cubit.purchase();

      /// Cubit emissions land asynchronously: without this the last one is
      /// still in flight when the subscription is torn down.
      await Future<void>.delayed(Duration.zero);
      await sub.cancel();

      expect(seen, containsAllInOrder([
        PaywallStatus.purchasing,
        PaywallStatus.confirming,
        PaywallStatus.purchased,
      ]));
    });

    test('ignores a second tap while the store sheet is open', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.purchase(any())).thenAnswer((_) async {
        await Future<void>.delayed(const Duration(milliseconds: 40));
        return true;
      });
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();

      final first = cubit.purchase();
      await Future<void>.delayed(const Duration(milliseconds: 5));
      await cubit.purchase();
      await first;

      verify(() => purchaseRepository.purchase(any())).called(1);
    });
  });

  group('restore', () {
    test('unlocks premium when the store has an active subscription', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.restore()).thenAnswer((_) async => true);
      when(() => authRepository.refreshCurrentUser())
          .thenAnswer((_) async => _user(SubscriptionStatus.premium));

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.restore();

      expect(cubit.state.status, PaywallStatus.restored);
      expect(cubit.state.isUnlocked, isTrue);
    });

    test('explains when there is nothing to restore', () async {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_annual]);
      when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

      final cubit = buildCubit();
      await cubit.loadOffers();
      await cubit.restore();

      expect(cubit.state.status, PaywallStatus.loaded);
      expect(cubit.state.errorMessage, contains('restaurer'));
      verifyNever(() => authRepository.refreshCurrentUser());
    });
  });
}

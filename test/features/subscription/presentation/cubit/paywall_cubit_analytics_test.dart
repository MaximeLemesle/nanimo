import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

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
  late RecordingAnalyticsService recorder;

  PaywallCubit buildCubit() => PaywallCubit(
        purchaseRepository: purchaseRepository,
        authRepository: authRepository,
        confirmationTimeout: const Duration(milliseconds: 60),
        pollInterval: const Duration(milliseconds: 10),
      );

  Future<PaywallCubit> loadedCubit() async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);
    final cubit = buildCubit();
    await cubit.loadOffers();
    return cubit;
  }

  setUp(() {
    purchaseRepository = _MockPurchaseRepository();
    authRepository = _MockAuthRepository();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
  });

  tearDown(() => analytics = const NoopAnalyticsService());

  test('a completed purchase reports the plan family, not the package id', () async {
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    final cubit = await loadedCubit();
    await cubit.purchase();

    expect(recorder.names, contains(AnalyticsEvents.purchaseStarted));
    final started = recorder.lastOf(AnalyticsEvents.purchaseStarted)!;
    expect(started.properties[AnalyticsProperties.plan], 'annual');

    final completed = recorder.lastOf(AnalyticsEvents.purchaseCompleted)!;
    expect(completed.properties[AnalyticsProperties.plan], 'annual');
    expect(completed.properties[AnalyticsProperties.confirmed], isTrue);
    expect(recorder.names, isNot(contains(AnalyticsEvents.premiumConfirmationTimeout)));
  });

  /// The money is taken but the webhook never landed. Without this event the
  /// case is invisible in production, which is how it shipped once already.
  test('a purchase the server never confirms is reported as a timeout', () async {
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));

    final cubit = await loadedCubit();
    await cubit.purchase();

    final completed = recorder.lastOf(AnalyticsEvents.purchaseCompleted)!;
    expect(completed.properties[AnalyticsProperties.confirmed], isFalse);
    expect(recorder.names, contains(AnalyticsEvents.premiumConfirmationTimeout));
  });

  test('a cancellation is not reported as a failure', () async {
    when(() => purchaseRepository.purchase(any()))
        .thenThrow(const PurchaseCancelledException());

    final cubit = await loadedCubit();
    await cubit.purchase();

    expect(recorder.names, contains(AnalyticsEvents.purchaseCancelled));
    expect(recorder.names, isNot(contains(AnalyticsEvents.purchaseFailed)));
  });

  test('a failure carries a reason and never the user-facing message', () async {
    when(() => purchaseRepository.purchase(any()))
        .thenAnswer((_) async => false);

    final cubit = await loadedCubit();
    await cubit.purchase();

    final failed = recorder.lastOf(AnalyticsEvents.purchaseFailed)!;
    expect(failed.properties[AnalyticsProperties.reason], 'not_active');
    expect(failed.properties[AnalyticsProperties.plan], 'annual');
  });

  test('selecting the monthly plan reports it', () async {
    final cubit = await loadedCubit();
    cubit.selectOffer(_monthly.packageId);

    final selected = recorder.lastOf(AnalyticsEvents.paywallOfferSelected)!;
    expect(selected.properties[AnalyticsProperties.plan], 'monthly');
  });

  test('a restore reports its outcome', () async {
    when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

    final cubit = await loadedCubit();
    await cubit.restore();

    expect(recorder.names, contains(AnalyticsEvents.restoreStarted));
    final finished = recorder.lastOf(AnalyticsEvents.restoreFinished)!;
    expect(finished.properties[AnalyticsProperties.restored], isFalse);
  });
}

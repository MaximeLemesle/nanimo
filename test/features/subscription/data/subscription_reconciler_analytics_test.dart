import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/data/subscription_reconciler.dart';

import '../../../core/analytics/recording_analytics_service.dart';

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
  late RecordingAnalyticsService recorder;

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
    recorder = RecordingAnalyticsService();
    analytics = recorder;
  });

  tearDown(() => analytics = const NoopAnalyticsService());

  /// The pass that repairs a late webhook. Counting it is what tells us how
  /// often the store and the server actually disagree in production.
  test('a repaired purchase is reported as recovered', () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));
    when(() => purchaseRepository.isPremiumActive()).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    await buildReconciler().reconcile();

    expect(recorder.names, contains(AnalyticsEvents.premiumConfirmationRecovered));
    expect(recorder.names, isNot(contains(AnalyticsEvents.premiumConfirmationTimeout)));
  });

  test('a purchase still unconfirmed after the pass is reported as a timeout', () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));
    when(() => purchaseRepository.isPremiumActive()).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.freemium));

    await buildReconciler().reconcile();

    expect(recorder.names, contains(AnalyticsEvents.premiumConfirmationTimeout));
  });

  /// Runs on every resume, so the quiet path must stay silent or it would
  /// swamp every other event in the project.
  test('the agreeing case reports nothing', () async {
    when(() => authRepository.getCurrentUser())
        .thenAnswer((_) async => _user(SubscriptionStatus.premium));

    await buildReconciler().reconcile();

    expect(recorder.events, isEmpty);
  });

  test('a signed-out user reports nothing', () async {
    when(() => authRepository.currentUserId).thenReturn(null);

    await buildReconciler().reconcile();

    expect(recorder.events, isEmpty);
  });
}

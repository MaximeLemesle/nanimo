import 'package:flutter/material.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/page/paywall_page.dart';
import 'package:nanimo/features/subscription/presentation/page/premium_welcome_page.dart';
import 'package:nanimo/features/subscription/presentation/widgets/paywall_confirming_widget.dart';
import 'package:nanimo/features/subscription/presentation/paywall_content.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

const _monthly = PaywallOfferModel(
  packageId: '\$rc_monthly',
  period: PaywallPeriod.monthly,
  priceLabel: '4,99 €',
  price: 4.99,
);

const _annual = PaywallOfferModel(
  packageId: '\$rc_annual',
  period: PaywallPeriod.annual,
  priceLabel: '34,99 €',
  price: 34.99,
  trialDays: 14,
);

void main() {
  late _MockPurchaseRepository purchaseRepository;
  late _MockAuthRepository authRepository;

  setUpAll(() async {
    for (final entry in {
      'Geologica': [
        'Geologica-Light.ttf',
        'Geologica-Regular.ttf',
        'Geologica-Medium.ttf'
      ],
      'Gluten': ['Gluten-ExtraBold.ttf'],
      'Comfortaa': ['Comfortaa-Bold.ttf'],
    }.entries) {
      final loader = FontLoader(entry.key);
      for (final file in entry.value) {
        loader.addFont(rootBundle.load('assets/fonts/$file'));
      }
      await loader.load();
    }
  });

  setUp(() {
    purchaseRepository = _MockPurchaseRepository();
    authRepository = _MockAuthRepository();
  });

  /// Bounded pumps everywhere, never `pumpAndSettle`. Two animations on these
  /// screens loop forever by design, the drifting polaroids of
  /// `PaywallMemoriesWidget` and the confetti of the welcome page, so no frame
  /// here is ever a settled one.
  Future<void> settle(WidgetTester tester) async {
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
  }

  /// A real router, because the page now leaves by `pushReplacement` instead
  /// of a bare `maybePop`, and `GoRouter.of` throws without one.
  Future<void> pumpPaywall(WidgetTester tester,
      {Future<bool> Function(Uri)? onOpenLegalLink,
      bool isOnboarding = false,
      Duration confirmationTimeout = const Duration(milliseconds: 30)}) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: RouteNames.paywall,
      routes: [
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => BlocProvider(
            create: (_) => PaywallCubit(
              purchaseRepository: purchaseRepository,
              authRepository: authRepository,
              confirmationTimeout: confirmationTimeout,
              pollInterval: const Duration(milliseconds: 10),
            )..loadOffers(),
            child: PaywallPage(
              onOpenLegalLink: onOpenLegalLink,
              isOnboarding: isOnboarding,
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.home,
          builder: (_, __) => const Scaffold(body: Text('home-stub')),
        ),
        GoRoute(
          path: RouteNames.login,
          builder: (_, __) => const Scaffold(body: Text('login-stub')),
        ),
        GoRoute(
          path: RouteNames.premiumWelcome,
          builder: (_, __) => PremiumWelcomePage(
            onPrimary: () {},
            onSecondary: () {},
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await settle(tester);
  }

  /// NAN-113: the annual plan leads with its trial and a price per month,
  /// so both plans read on the same scale.
  testWidgets('shows the trial title, its three lines and the annual plan first',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);
    await pumpPaywall(tester);
    expect(find.text('Commence tes 14 jours gratuits'), findsOneWidget);
    for (final line in [...paywallLines, paywallTrialReminder]) {
      expect(find.text(line.plainText), findsOneWidget);
    }
    expect(find.text('14 JOURS GRATUITS'), findsOneWidget);
    expect(find.text('Annuel'), findsOneWidget);
    expect(find.text('Économise 42\u00a0%, 34,99 € par an'), findsOneWidget);
    expect(find.text('2,92 €/mois'), findsOneWidget);
    expect(find.text('4,99 €/mois'), findsOneWidget);
    expect(find.text('Essayer 14 jours gratuitement'), findsOneWidget);
    expect(tester.getTopLeft(find.text('Annuel')).dy,
        lessThan(tester.getTopLeft(find.text('Mensuel')).dy));
  });

  testWidgets('changing the legal notice keeps the offers and CTA anchored',
      (tester) async {
    const annual = PaywallOfferModel(
        packageId: 'annual',
        period: PaywallPeriod.annual,
        priceLabel: '34,99 \$US',
        price: 34.99,
        trialDays: 14);
    const monthly = PaywallOfferModel(
        packageId: 'monthly',
        period: PaywallPeriod.monthly,
        priceLabel: '4,99 \$US',
        price: 4.99);
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [monthly, annual]);
    await pumpPaywall(tester);
    for (final width in [320.0, 375.0, 390.0, 430.0]) {
      tester.view.physicalSize = Size(width, 932);
      await settle(tester);
      await tester.tap(find.text('14 JOURS GRATUITS'));
      await settle(tester);
      final offerBefore = tester.getTopLeft(find.text('Annuel'));
      final ctaBefore = tester.getTopLeft(find.byType(ButtonWidget).first);
      await tester.tap(find.text('Mensuel'));
      await settle(tester);
      expect(tester.getTopLeft(find.text('Annuel')), offerBefore,
          reason: 'offer at width $width');
      expect(tester.getTopLeft(find.byType(ButtonWidget).first), ctaBefore,
          reason: 'CTA at width $width');
    }
  });

  testWidgets(
      'without a trial the annual plan says what it saves, nothing more',
      (tester) async {
    when(() => purchaseRepository.getOffers()).thenAnswer((_) async => [
          _monthly,
          const PaywallOfferModel(
              packageId: 'a',
              period: PaywallPeriod.annual,
              priceLabel: '34,99 €',
              price: 34.99),
        ]);

    await pumpPaywall(tester);

    expect(find.text(paywallTitle), findsOneWidget);
    expect(find.text('Annuel'), findsOneWidget);
    expect(find.text('Économise 42\u00a0%, 34,99 € par an'), findsOneWidget);
    expect(find.text('14 JOURS GRATUITS'), findsNothing);
    expect(find.text(paywallTrialReminder.plainText), findsNothing);
  });

  testWidgets('shows the auto-renewal notice required by the stores',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    expect(find.textContaining('14 jours gratuits, puis 34,99 € par an.'),
        findsOneWidget);
    expect(find.textContaining('Renouvelé automatiquement'), findsOneWidget);
    expect(find.textContaining('résiliable à tout moment'), findsOneWidget);
  });

  /// Apple rejects a subscription screen without both links.
  testWidgets('always shows the terms and privacy links', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    expect(find.text('Conditions'), findsOneWidget);
    expect(find.text('Confidentialité'), findsOneWidget);
  });

  testWidgets('the legal links point at the published pages', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    final opened = <Uri>[];
    await pumpPaywall(tester, onOpenLegalLink: (uri) async {
      opened.add(uri);
      return true;
    });

    await tester.tap(find.text('Conditions'));
    await settle(tester);
    await tester.tap(find.text('Confidentialité'));
    await settle(tester);

    expect(opened, hasLength(2));
    // Must be the publicly reachable notion.site pages: the private
    // app.notion.com URLs would open a login wall for a reviewer.
    expect(opened.every((uri) => uri.host.endsWith('notion.site')), isTrue);
    expect(opened.first.toString(), contains('Conditions'));
    expect(opened.last.toString(), contains('Politique'));
  });

  testWidgets('warns when a legal page cannot be opened', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester, onOpenLegalLink: (_) async => false);

    await tester.tap(find.text('Conditions'));
    await settle(tester);

    expect(find.textContaining('Impossible d’ouvrir'), findsOneWidget);
  });

  testWidgets('tapping a plan selects it and buys that one', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        userId: 'u1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
      ),
    );

    await pumpPaywall(tester);

    // Annual is preselected, so tapping monthly must change the purchase target.
    await tester.tap(find.text('Mensuel'));
    await settle(tester);
    await tester.tap(find.text('Passer premium'));
    await settle(tester);

    verify(() => purchaseRepository.purchase('\$rc_monthly')).called(1);
  });

  /// Covers the RevenueCat verification window too, not just our own poll:
  /// this is what used to look like a frozen paywall in sandbox.
  testWidgets('holds a waiting screen from the store sheet to the server',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenAnswer((_) async => true);

    /// Never flips, so the page stays in the confirming phase for the whole
    /// timeout and the waiting screen is observable.
    when(() => authRepository.refreshCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        userId: 'u1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.freemium,
      ),
    );

    await pumpPaywall(tester);
    await tester.tap(find.text('Essayer 14 jours gratuitement'));
    await tester.pump();

    /// Already up on the very first frame, before `purchase()` resolves.
    expect(find.byType(PaywallConfirmingWidget), findsOneWidget);

    await tester.pump();
    expect(find.byType(PaywallConfirmingWidget), findsOneWidget);
    expect(find.text(premiumConfirmingTitle), findsOneWidget);
    expect(find.text('Essayer 14 jours gratuitement'), findsNothing);

    await settle(tester);
  });

  testWidgets('a confirmed purchase lands on the welcome page', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        userId: 'u1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
      ),
    );

    await pumpPaywall(tester);
    await tester.tap(find.text('Essayer 14 jours gratuitement'));
    await settle(tester);

    expect(find.byType(PremiumWelcomePage), findsOneWidget);
    expect(find.text(premiumWelcomeTitle), findsOneWidget);
    expect(find.text(premiumWelcomeCta), findsOneWidget);
    expect(find.text(premiumWelcomeNotice), findsOneWidget);

    /// The paywall is replaced, not covered.
    expect(find.byType(PaywallPage), findsNothing);
  });

  /// Paid but unconfirmed reaches the same page, never an error state: the
  /// money is taken either way. The relaunch notice carries the difference.
  testWidgets('an unconfirmed purchase lands on the same welcome page',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        userId: 'u1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.freemium,
      ),
    );

    /// Zero, deliberately. `SubscriptionRestorer` bounds its loop with
    /// `DateTime.now()`, which the test clock does not fake, so a non-zero
    /// timeout here would spin against real wall time and make the test flaky.
    /// Zero exits the loop on the first check, which is the branch under test.
    await pumpPaywall(tester, confirmationTimeout: Duration.zero);
    await tester.tap(find.text('Essayer 14 jours gratuitement'));
    await settle(tester);

    expect(find.byType(PremiumWelcomePage), findsOneWidget);
    expect(find.text(premiumWelcomeTitle), findsOneWidget);
    expect(find.text(premiumWelcomeNotice), findsOneWidget);
  });

  testWidgets('offers a retry when the offers cannot be loaded',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenThrow(const RepositoryNetworkException('Pas de connexion.'));

    await pumpPaywall(tester);

    expect(find.text('Réessayer'), findsOneWidget);
    expect(find.textContaining('connexion'), findsOneWidget);

    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    await tester.tap(find.text('Réessayer'));
    await settle(tester);

    expect(find.text('34,99 € par an'), findsOneWidget);
  });

  testWidgets('surfaces a failed purchase without unlocking premium',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any())).thenThrow(
        const RepositoryServerException('Le store est indisponible.'));

    await pumpPaywall(tester);
    await tester.tap(find.text('Essayer 14 jours gratuitement'));
    await settle(tester);

    expect(find.text('Le store est indisponible.'), findsOneWidget);
    verifyNever(() => authRepository.refreshCurrentUser());
  });

  testWidgets('a cancelled purchase shows nothing at all', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenThrow(const PurchaseCancelledException());

    await pumpPaywall(tester);
    await tester.tap(find.text('Essayer 14 jours gratuitement'));
    await settle(tester);

    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Essayer 14 jours gratuitement'), findsOneWidget);
  });

  testWidgets('restoring with nothing to restore explains why', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

    await pumpPaywall(tester);
    await tester.tap(find.text('Restaurer'));
    await settle(tester);

    expect(find.textContaining('Aucun abonnement à restaurer'), findsOneWidget);
  });

  /// NAN-113: last screen of the trial flow, after the account exists.
  group('onboarding', () {
    setUp(() {
      when(() => purchaseRepository.getOffers())
          .thenAnswer((_) async => [_monthly, _annual]);
    });

    testWidgets('buys for real: the account already exists', (tester) async {
      when(() => purchaseRepository.purchase(any()))
          .thenThrow(const PurchaseCancelledException());
      await pumpPaywall(tester, isOnboarding: true);

      await tester.tap(find.text('Essayer 14 jours gratuitement'));
      await settle(tester);

      verify(() => purchaseRepository.purchase('\$rc_annual')).called(1);
    });

    testWidgets('closing the onboarding paywall reaches the home directly',
        (tester) async {
      final recorder = RecordingAnalyticsService();
      analytics = recorder;
      addTearDown(() => analytics = const NoopAnalyticsService());
      await pumpPaywall(tester, isOnboarding: true);
      expect(find.byTooltip('Retour'), findsNothing);
      await tester.tap(find.byTooltip('Fermer'));
      await settle(tester);
      verifyNever(() => purchaseRepository.purchase(any()));
      expect(find.text('home-stub'), findsOneWidget);
      expect(
          recorder
              .lastOf(AnalyticsEvents.paywallDismissed)!
              .properties[AnalyticsProperties.reason],
          'close');
    });
  });

  testWidgets('closes from the top right only, no "Non merci"',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    await pumpPaywall(tester);

    final width = tester.view.physicalSize.width / tester.view.devicePixelRatio;
    expect(tester.getCenter(find.byTooltip('Fermer')).dx, greaterThan(width / 2));
    expect(find.text(paywallNoThanks), findsNothing);
  });
}

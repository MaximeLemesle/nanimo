import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
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
);

void main() {
  late _MockPurchaseRepository purchaseRepository;
  late _MockAuthRepository authRepository;

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
            child: PaywallPage(onOpenLegalLink: onOpenLegalLink),
          ),
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


  testWidgets('lists the benefits and both plans with their store prices',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);

    await pumpPaywall(tester);

    expect(find.text(paywallTitle), findsOneWidget);
    expect(find.text(paywallTagline), findsOneWidget);
    expect(
      find.textContaining('Ne rate aucun instant avec 5 photos', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Agrandis ta famille jusqu’à 10 animaux', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Mensuel'), findsOneWidget);
    expect(find.text('Annuel'), findsOneWidget);
    expect(find.textContaining('4,99 €'), findsOneWidget);
    expect(find.textContaining('39,99 €'), findsOneWidget);
  });

  /// A single-pet owner is the common case, so the photo benefit sells first.
  testWidgets('leads with the photo benefit, not the pet quota', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    final photos = tester.getTopLeft(
      find.textContaining('Ne rate aucun instant', findRichText: true),
    );
    final pets = tester.getTopLeft(
      find.textContaining('Agrandis ta famille', findRichText: true),
    );
    expect(photos.dy, lessThan(pets.dy));
  });

  testWidgets('shows the auto-renewal notice required by the stores',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    expect(find.textContaining('renouvelé automatiquement '), findsOneWidget);
    expect(find.textContaining('résilier à tout moment'), findsOneWidget);
  });

  /// Apple rejects a subscription screen without both links.
  testWidgets('always shows the terms and privacy links', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    expect(find.text('Conditions d’utilisation'), findsOneWidget);
    expect(find.text('Politique de confidentialité'), findsOneWidget);
  });

  testWidgets('the legal links point at the published pages', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    final opened = <Uri>[];
    await pumpPaywall(tester, onOpenLegalLink: (uri) async {
      opened.add(uri);
      return true;
    });

    await tester.tap(find.text('Conditions d’utilisation'));
    await settle(tester);
    await tester.tap(find.text('Politique de confidentialité'));
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

    await tester.tap(find.text('Conditions d’utilisation'));
    await settle(tester);

    expect(find.textContaining('Impossible d’ouvrir'), findsOneWidget);
  });

  testWidgets('the call to action announces the trial when there is one',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly]);

    await pumpPaywall(tester);

    expect(find.text('Essayer 7 jours gratuitement'), findsOneWidget);
  });

  testWidgets('the call to action stays plain without a trial', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);

    await pumpPaywall(tester);

    expect(find.text('Passer premium'), findsOneWidget);
  });

  testWidgets('tapping a plan selects it and buys that one', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);
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
    await tester.tap(find.text('Essayer 7 jours gratuitement'));
    await settle(tester);

    verify(() => purchaseRepository.purchase('\$rc_monthly')).called(1);
  });

  /// Covers the RevenueCat verification window too, not just our own poll:
  /// this is what used to look like a frozen paywall in sandbox.
  testWidgets('holds a waiting screen from the store sheet to the server',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);

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
    await tester.tap(find.text('Passer premium'));
    await tester.pump();

    /// Already up on the very first frame, before `purchase()` resolves.
    expect(find.byType(PaywallConfirmingWidget), findsOneWidget);

    await tester.pump();
    expect(find.byType(PaywallConfirmingWidget), findsOneWidget);
    expect(find.text(premiumConfirmingTitle), findsOneWidget);
    expect(find.text('Passer premium'), findsNothing);

    await settle(tester);
  });

  testWidgets('a confirmed purchase lands on the welcome page',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);
    when(() => authRepository.refreshCurrentUser()).thenAnswer(
      (_) async => const UserModel(
        userId: 'u1',
        userName: 'Maxime',
        mail: 'maxime@example.com',
        subscriptionStatus: SubscriptionStatus.premium,
      ),
    );

    await pumpPaywall(tester);
    await tester.tap(find.text('Passer premium'));
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
    when(() => purchaseRepository.purchase(any())).thenAnswer((_) async => true);
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
    await tester.tap(find.text('Passer premium'));
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

    expect(find.text('Annuel'), findsOneWidget);
  });

  testWidgets('surfaces a failed purchase without unlocking premium',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.purchase(any()))
        .thenThrow(const RepositoryServerException('Le store est indisponible.'));

    await pumpPaywall(tester);
    await tester.tap(find.text('Passer premium'));
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
    await tester.tap(find.text('Passer premium'));
    await settle(tester);

    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Passer premium'), findsOneWidget);
  });

  testWidgets('restoring with nothing to restore explains why', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

    await pumpPaywall(tester);
    await tester.tap(find.text('Restaurer mes achats'));
    await settle(tester);

    expect(find.textContaining('Aucun abonnement à restaurer'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/page/paywall_page.dart';
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

  Future<void> pumpPaywall(WidgetTester tester,
      {Future<bool> Function(Uri)? onOpenLegalLink}) async {
    tester.view.physicalSize = const Size(1000, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => PaywallCubit(
            purchaseRepository: purchaseRepository,
            authRepository: authRepository,
            confirmationTimeout: const Duration(milliseconds: 30),
            pollInterval: const Duration(milliseconds: 10),
          )..loadOffers(),
          child: PaywallPage(onOpenLegalLink: onOpenLegalLink),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  testWidgets('lists the benefits and both plans with their store prices',
      (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_monthly, _annual]);

    await pumpPaywall(tester);

    expect(find.text(paywallTitle), findsOneWidget);
    expect(
      find.textContaining('Agrandis ta famille jusqu’à 10 animaux', findRichText: true),
      findsOneWidget,
    );
    expect(
      find.textContaining('Créer des souvenirs avec 5 photos', findRichText: true),
      findsOneWidget,
    );
    expect(find.text('Mensuel'), findsOneWidget);
    expect(find.text('Annuel'), findsOneWidget);
    expect(find.textContaining('4,99 €'), findsOneWidget);
    expect(find.textContaining('39,99 €'), findsOneWidget);
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
    await tester.pumpAndSettle();
    await tester.tap(find.text('Politique de confidentialité'));
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();
    await tester.tap(find.text('Essayer 7 jours gratuitement'));
    await tester.pumpAndSettle();

    verify(() => purchaseRepository.purchase('\$rc_monthly')).called(1);
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
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

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
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('Passer premium'), findsOneWidget);
  });

  testWidgets('restoring with nothing to restore explains why', (tester) async {
    when(() => purchaseRepository.getOffers())
        .thenAnswer((_) async => [_annual]);
    when(() => purchaseRepository.restore()).thenAnswer((_) async => false);

    await pumpPaywall(tester);
    await tester.tap(find.text('Restaurer mes achats'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Aucun abonnement à restaurer'), findsOneWidget);
  });
}

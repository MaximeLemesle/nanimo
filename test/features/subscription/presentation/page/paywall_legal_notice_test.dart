import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/config/theme/app_theme.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
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
  priceLabel: '\$3.99',
  price: 3.99,
);

const _annual = PaywallOfferModel(
  packageId: '\$rc_annual',
  period: PaywallPeriod.annual,
  priceLabel: '\$34.99',
  price: 34.99,
  trialDays: 14,
);

void main() {
  setUpAll(() async {
    for (final entry in {
      'Geologica': ['Geologica-Light.ttf', 'Geologica-Regular.ttf', 'Geologica-Medium.ttf'],
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

  Future<void> pumpPaywall(WidgetTester tester, Size screen, double textScale) async {
    tester.view.physicalSize = screen * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final purchaseRepository = _MockPurchaseRepository();
    when(() => purchaseRepository.getOffers()).thenAnswer((_) async => [_monthly, _annual]);
    final router = GoRouter(
      initialLocation: RouteNames.paywall,
      routes: [
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => BlocProvider(
            create: (_) => PaywallCubit(
              purchaseRepository: purchaseRepository,
              authRepository: _MockAuthRepository(),
            )..loadOffers(),
            child: const PaywallPage(),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(
      theme: AppTheme.light,
      routerConfig: router,
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(textScale)),
        child: child!,
      ),
    ));
    for (var i = 0; i < 40; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
  }

  /// NAN-128: on TestFlight the notice stopped at « la période en ».
  testWidgets('the renewal notice is never cut, the links sit below it', (tester) async {
    for (final screen in const [Size(375, 667), Size(393, 852), Size(430, 932)]) {
      for (final scale in const [1.0, 1.15, 1.3]) {
        await pumpPaywall(tester, screen, scale);
        final notice = find.text(paywallLegalNotice(_annual));
        final paragraph = tester.renderObject<RenderParagraph>(notice);
        final needed = paragraph.getMaxIntrinsicHeight(paragraph.size.width);
        expect(paragraph.size.height, greaterThanOrEqualTo(needed), reason: '$screen at ×$scale');
        expect(tester.getTopLeft(find.text('Conditions')).dy, greaterThanOrEqualTo(tester.getBottomLeft(notice).dy),
            reason: '$screen at ×$scale');
        expect(tester.takeException(), isNull);
      }
    }
  });
}

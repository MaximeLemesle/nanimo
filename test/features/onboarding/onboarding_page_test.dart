import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/features/onboarding/presentation/page/onboarding_page.dart';

import '../../core/analytics/recording_analytics_service.dart';

void main() {
  late RecordingAnalyticsService recorder;

  setUp(() {
    recorder = RecordingAnalyticsService();
    analytics = recorder;
  });
  tearDown(() => analytics = const NoopAnalyticsService());

  Future<void> pumpOnboarding(WidgetTester tester, {Size size = const Size(375, 667)}) async {
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));
    final router = GoRouter(
      initialLocation: RouteNames.onboarding,
      routes: [
        GoRoute(path: RouteNames.onboarding, builder: (_, __) => const OnboardingPage()),
        GoRoute(path: RouteNames.createPet, builder: (_, __) => const Text('create-pet')),
        GoRoute(path: RouteNames.login, builder: (_, __) => const Text('login')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pump();
  }

  Future<void> next(WidgetTester tester, String label) async {
    await tester.tap(find.text(label));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
  }

  /// NAN-114: the welcome screen keeps only the name and the tagline.
  testWidgets('welcomes with the name, the tagline and « Découvrir »', (tester) async {
    await pumpOnboarding(tester);

    expect(find.text('Chaque moment compte.'), findsOneWidget);
    expect(find.text('Découvrir'), findsOneWidget);
    expect(find.text('Ne rate plus un rappel de vaccin'), findsNothing);
    expect(find.text('J\'ai déjà un compte'), findsOneWidget);
  });

  testWidgets('walks the four slides, then starts the pet creation', (tester) async {
    await pumpOnboarding(tester);

    await next(tester, 'Découvrir');
    expect(find.textContaining('Le carnet de santé de ton animal'), findsOneWidget);
    await next(tester, 'Continuer');
    expect(find.text('Leur histoire mérite d\'être gardée.'), findsOneWidget);
    await next(tester, 'Continuer');
    expect(find.text('Ne manque plus rien.'), findsOneWidget);
    await next(tester, 'Continuer');
    expect(find.textContaining('ajoute ton premier', findRichText: true), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'every slide fits an iPhone SE');

    await next(tester, 'Commencer');
    expect(find.text('create-pet'), findsOneWidget);
    expect(
      recorder.events.where((e) => e.name == AnalyticsEvents.onboardingSlideViewed).map((e) => e.properties[AnalyticsProperties.step]),
      [1, 2, 3, 4],
    );
  });

  testWidgets('steps back through the slides to the welcome screen', (tester) async {
    await pumpOnboarding(tester);
    await next(tester, 'Découvrir');
    await next(tester, 'Continuer');

    await tester.tap(find.byTooltip('Retour'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
    expect(find.textContaining('Le carnet de santé de ton animal'), findsOneWidget);

    await tester.tap(find.byTooltip('Retour'));
    for (var i = 0; i < 20; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
    expect(find.text('Découvrir'), findsOneWidget);
  });
}

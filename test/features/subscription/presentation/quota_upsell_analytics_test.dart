import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/quota_upsell.dart';

import '../../../core/analytics/recording_analytics_service.dart';

const _freePlan = SubscriptionState.loaded(SubscriptionConfigModel(
  configId: 'cfg-free',
  planName: 'freemium',
  maxImagesPerEvent: 1,
  maxPets: 1,
));

const _premiumPlan = SubscriptionState.loaded(SubscriptionConfigModel(
  configId: 'cfg-premium',
  planName: 'premium',
  maxImagesPerEvent: 5,
  maxPets: 10,
));

void main() {
  late RecordingAnalyticsService recorder;

  setUp(() {
    recorder = RecordingAnalyticsService();
    analytics = recorder;
  });

  tearDown(() => analytics = const NoopAnalyticsService());

  Future<void> pumpAndBlock(
    WidgetTester tester,
    void Function(BuildContext context) block,
  ) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (context, _) => Scaffold(
            body: Builder(
              builder: (inner) => TextButton(
                onPressed: () => block(inner),
                child: const Text('block'),
              ),
            ),
          ),
        ),
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => const Scaffold(body: Text('paywall')),
        ),
      ],
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.tap(find.text('block'));
    await tester.pumpAndSettle();
  }

  testWidgets('the pet limit reports its own trigger', (tester) async {
    await pumpAndBlock(
      tester,
      (context) => QuotaUpsell.petQuotaReached(context, _freePlan),
    );

    final opened = recorder.lastOf(AnalyticsEvents.paywallOpened)!;
    expect(opened.properties[AnalyticsProperties.trigger], PaywallTrigger.addPet);
    expect(find.text('paywall'), findsOneWidget);
  });

  testWidgets('the photo limit reports a different trigger', (tester) async {
    await pumpAndBlock(
      tester,
      (context) => QuotaUpsell.eventImageQuotaReached(context, _freePlan, 1),
    );

    final opened = recorder.lastOf(AnalyticsEvents.paywallOpened)!;
    expect(opened.properties[AnalyticsProperties.trigger], PaywallTrigger.addPhoto);
  });

  /// A premium user hitting their own ceiling sees a message, not the paywall,
  /// so counting it as an upsell would inflate every conversion rate.
  testWidgets('a premium ceiling opens nothing and reports nothing', (tester) async {
    await pumpAndBlock(
      tester,
      (context) => QuotaUpsell.petQuotaReached(context, _premiumPlan),
    );

    expect(recorder.names, isNot(contains(AnalyticsEvents.paywallOpened)));
    expect(find.text('paywall'), findsNothing);
  });

  testWidgets('an unknown plan opens nothing and reports nothing', (tester) async {
    await pumpAndBlock(
      tester,
      (context) => QuotaUpsell.petQuotaReached(
        context,
        const SubscriptionState.unknown(),
      ),
    );

    expect(recorder.names, isNot(contains(AnalyticsEvents.paywallOpened)));
    expect(find.text('paywall'), findsNothing);
  });
}

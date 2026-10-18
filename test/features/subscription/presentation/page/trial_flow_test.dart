import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/features/subscription/presentation/page/trial_intro_page.dart';
import 'package:nanimo/features/subscription/presentation/page/trial_reminder_page.dart';

import '../../../../core/analytics/recording_analytics_service.dart';
import '../../../../core/notifications/fake_notification_client.dart';

void main() {
  late FakeNotificationClient client;
  late MemoryPrimingStore store;
  late RecordingAnalyticsService recorder;
  late NotificationPriming previous;

  setUp(() {
    client = FakeNotificationClient();
    store = MemoryPrimingStore();
    previous = notificationPriming;
    notificationPriming = NotificationPriming(client: () => client, store: store);
    recorder = RecordingAnalyticsService();
    analytics = recorder;
  });

  tearDown(() {
    notificationPriming = previous;
    analytics = const NoopAnalyticsService();
  });

  Future<void> pumpFlow(WidgetTester tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    final router = GoRouter(
      initialLocation: RouteNames.trialIntro,
      routes: [
        GoRoute(path: RouteNames.trialIntro, builder: (_, __) => const TrialIntroPage()),
        GoRoute(path: RouteNames.trialReminder, builder: (_, __) => const TrialReminderPage()),
        GoRoute(path: RouteNames.paywall, builder: (_, state) => Text('paywall ${state.uri.query}')),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
  }

  testWidgets('the intro promises the trial and leads to the reminder', (tester) async {
    await pumpFlow(tester);

    expect(find.text('Aucun paiement maintenant'), findsOneWidget);
    expect(tester.takeException(), isNull, reason: 'the showcase fits the smallest phone');
    expect(recorder.lastOf(AnalyticsEvents.trialIntroViewed), isNotNull);

    await tester.tap(find.text('Essaie Nanimo gratuitement'));
    await tester.pumpAndSettle();

    expect(find.text('On te prévient 2 jours avant la fin de ton essai'), findsOneWidget);
    expect(recorder.lastOf(AnalyticsEvents.trialReminderViewed), isNotNull);
  });

  testWidgets('the reminder asks for notifications, then opens the onboarding paywall', (tester) async {
    await pumpFlow(tester);
    await tester.tap(find.text('Essaie Nanimo gratuitement'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continuer gratuitement'));
    await tester.pumpAndSettle();

    expect(client.requestCount, 1);
    expect(find.text('paywall onboarding=1'), findsOneWidget);
    expect(recorder.lastOf(AnalyticsEvents.paywallOpened)!.properties[AnalyticsProperties.trigger], PaywallTrigger.onboarding);
  });

  testWidgets('a permission already answered is not asked again', (tester) async {
    store.shown = true;
    await pumpFlow(tester);
    await tester.tap(find.text('Essaie Nanimo gratuitement'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continuer gratuitement'));
    await tester.pumpAndSettle();

    expect(client.requestCount, 0);
    expect(find.text('paywall onboarding=1'), findsOneWidget);
  });
}

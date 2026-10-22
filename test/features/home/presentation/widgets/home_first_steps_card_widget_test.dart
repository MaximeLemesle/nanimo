import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/features/home/presentation/widgets/home_first_steps_card_widget.dart';

import '../../../../core/analytics/recording_analytics_service.dart';
import '../../../../core/notifications/fake_notification_client.dart';

/// NAN-108: the "Premiers pas" card on the home.
void main() {
  late FakeNotificationClient client;
  late MemoryPrimingStore primingStore;
  late MemoryFirstStepsStore store;
  late RecordingAnalyticsService recorder;
  late NotificationPriming previousPriming;
  late FirstStepsStore previousStore;

  setUp(() {
    client = FakeNotificationClient();
    primingStore = MemoryPrimingStore();
    store = MemoryFirstStepsStore();
    recorder = RecordingAnalyticsService();
    previousPriming = notificationPriming;
    previousStore = firstStepsStore;
    notificationPriming =
        NotificationPriming(client: () => client, store: primingStore);
    firstStepsStore = store;
    analytics = recorder;
  });

  tearDown(() {
    notificationPriming = previousPriming;
    firstStepsStore = previousStore;
    analytics = const NoopAnalyticsService();
  });

  Widget card(
          {bool hasDiary = false,
          bool hasMemory = false,
          VoidCallback? onCompleteDiary,
          VoidCallback? onAddMemory,
          VoidCallback? onCompleted,
          bool isOnScreen = true}) =>
      MaterialApp(
        home: Scaffold(
          body: TickerMode(
            enabled: isOnScreen,
            child: HomeFirstStepsCardWidget(
              petName: 'Dobby',
              hasDiary: hasDiary,
              hasMemory: hasMemory,
              onCompleteDiary: onCompleteDiary ?? () {},
              onAddMemory: onAddMemory ?? () {},
              onCompleted: onCompleted,
            ),
          ),
        ),
      );

  double progress(WidgetTester tester) => tester
      .widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator))
      .value!;

  test(
      'dismissal belongs to one account and ignores the old automatic hiding flag',
      () async {
    SharedPreferences.setMockInitialValues({'first_steps_dismissed': true});
    var userId = 'user-a';
    final persistent = SharedPreferencesFirstStepsStore(userId: () => userId);
    expect(await persistent.isDismissed(), isFalse);
    await persistent.dismiss();
    expect(await persistent.isDismissed(), isTrue);
    userId = 'user-b';
    expect(await persistent.isDismissed(), isFalse);
    userId = 'user-a';
    expect(await persistent.isDismissed(), isTrue);
  });

  testWidgets('a new user sees four steps, the profile already ticked',
      (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    // NAN-116: the first two steps speak of the animal.
    for (final label in [
      'Premier Nanimo ajouté',
      'Compléter le carnet de Dobby',
      'Activer les rappels',
      'Ajouter un premier souvenir'
    ]) {
      expect(find.text(label), findsOneWidget);
    }
    expect(progress(tester), 0.25);
  });

  testWidgets('each open step leads to its screen', (tester) async {
    var diary = false;
    var memory = false;
    await tester.pumpWidget(card(
        onCompleteDiary: () => diary = true, onAddMemory: () => memory = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Compléter le carnet de Dobby'));
    await tester.tap(find.text('Ajouter un premier souvenir'));
    await tester.tap(find.text('Activer les rappels'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Activer les notifications'));
    await tester.pumpAndSettle();

    expect(diary, isTrue);
    expect(memory, isTrue);
    expect(client.requestCount, 1);
    expect(progress(tester), 0.5);
  });

  testWidgets('after a refusal, the reminders step opens the phone settings',
      (tester) async {
    primingStore.shown = true;
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Activer les rappels'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ouvrir les réglages'));
    await tester.pumpAndSettle();

    expect(client.requestCount, 0);
    expect(client.openSettingsCount, 1);
  });

  testWidgets('the reminders step shows the benefits before any prompt',
      (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Activer les rappels'));
    await tester.pumpAndSettle();

    expect(find.text('Ne rate rien !'), findsOneWidget);
    expect(client.requestCount, 0);

    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();

    expect(find.text('Ne rate rien !'), findsNothing);
    expect(client.requestCount, 0);
    expect(progress(tester), 0.25);
  });

  testWidgets('steps tick themselves from the data and are reported once',
      (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpWidget(card(hasDiary: true));
    await tester.pumpAndSettle();

    expect(progress(tester), 0.5);
    expect(
        recorder
            .lastOf(AnalyticsEvents.checklistItemCompleted)!
            .properties[AnalyticsProperties.item],
        'diary');
  });

  testWidgets(
      'a previously completed checklist retires without replaying the celebration',
      (tester) async {
    client.granted = true;
    await tester.pumpWidget(card(hasDiary: true, hasMemory: true));
    await tester.pumpAndSettle();

    expect(find.text('Premiers pas'), findsNothing);
    expect(store.dismissed, isTrue);
  });

  testWidgets('the last step celebrates once and hides the card for good',
      (tester) async {
    var celebrations = 0;
    await tester.pumpWidget(card(onCompleted: () => celebrations++));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpWidget(card(
        hasDiary: true, hasMemory: true, onCompleted: () => celebrations++));
    await tester.pumpAndSettle();
    await notificationPriming.accept();
    await tester.pumpAndSettle();

    /// The completed card stays a beat, then folds away and celebrates.
    expect(find.text('Premiers pas'), findsOneWidget);
    expect(celebrations, 0);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    expect(celebrations, 1);
    expect(find.text('Premiers pas'), findsNothing);
    expect(store.dismissed, isTrue);
    await tester.pumpWidget(card(
        hasDiary: true, hasMemory: true, onCompleted: () => celebrations++));
    await tester.pumpAndSettle();
    expect(celebrations, 1);
  });

  testWidgets('completed behind another page, it waits to be seen',
      (tester) async {
    var celebrations = 0;
    await tester.pumpWidget(card(onCompleted: () => celebrations++));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));
    await notificationPriming.accept();
    await tester.pumpWidget(card(
        hasDiary: true,
        hasMemory: true,
        isOnScreen: false,
        onCompleted: () => celebrations++));
    await tester.pump(const Duration(seconds: 3));
    expect(celebrations, 0);
    expect(store.dismissed, isFalse);

    await tester.pumpWidget(card(
        hasDiary: true, hasMemory: true, onCompleted: () => celebrations++));
    await tester.pump();
    expect(find.text('Premiers pas'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 800));
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 400));
    expect(celebrations, 1);
    expect(store.dismissed, isTrue);
  });

  testWidgets(
      'permission granted in the diary immediately updates the checklist',
      (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();
    expect(progress(tester), 0.25);

    await notificationPriming.accept();
    await tester.pumpAndSettle();
    expect(progress(tester), 0.5);
  });

  testWidgets('the cross hides it for good', (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    await tester.tap(find.byTooltip('Masquer'));
    await tester.pumpAndSettle();

    expect(find.text('Premiers pas'), findsNothing);
    expect(store.dismissed, isTrue);
  });
}

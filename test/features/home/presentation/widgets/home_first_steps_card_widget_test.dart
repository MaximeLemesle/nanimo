import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
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
    notificationPriming = NotificationPriming(client: () => client, store: primingStore);
    firstStepsStore = store;
    analytics = recorder;
  });

  tearDown(() {
    notificationPriming = previousPriming;
    firstStepsStore = previousStore;
    analytics = const NoopAnalyticsService();
  });

  Widget card({bool hasDiary = false, bool hasMemory = false, VoidCallback? onCompleteDiary, VoidCallback? onAddMemory}) =>
      MaterialApp(
        home: Scaffold(
          body: HomeFirstStepsCardWidget(
            petName: 'Dobby',
            hasDiary: hasDiary,
            hasMemory: hasMemory,
            onCompleteDiary: onCompleteDiary ?? () {},
            onAddMemory: onAddMemory ?? () {},
          ),
        ),
      );

  double progress(WidgetTester tester) => tester.widget<LinearProgressIndicator>(find.byType(LinearProgressIndicator)).value!;

  testWidgets('a new user sees four steps, the profile already ticked', (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    // NAN-116: the first two steps speak of the animal.
    for (final label in ['Premier Nanimo ajouté', 'Compléter le carnet de Dobby', 'Activer les rappels', 'Ajouter un premier souvenir']) {
      expect(find.text(label), findsOneWidget);
    }
    expect(progress(tester), 0.25);
  });

  testWidgets('each open step leads to its screen', (tester) async {
    var diary = false;
    var memory = false;
    await tester.pumpWidget(card(onCompleteDiary: () => diary = true, onAddMemory: () => memory = true));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Compléter le carnet de Dobby'));
    await tester.tap(find.text('Ajouter un premier souvenir'));
    await tester.tap(find.text('Activer les rappels'));
    await tester.pumpAndSettle();

    expect(diary, isTrue);
    expect(memory, isTrue);
    expect(client.requestCount, 1);
    expect(progress(tester), 0.5);
  });

  testWidgets('after a refusal, the reminders step opens the phone settings', (tester) async {
    primingStore.shown = true;
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();

    await tester.tap(find.text('Activer les rappels'));
    await tester.pumpAndSettle();

    expect(client.requestCount, 0);
    expect(client.openSettingsCount, 1);
  });

  testWidgets('steps tick themselves from the data and are reported once', (tester) async {
    await tester.pumpWidget(card());
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 2));

    await tester.pumpWidget(card(hasDiary: true));
    await tester.pumpAndSettle();

    expect(progress(tester), 0.5);
    expect(recorder.lastOf(AnalyticsEvents.checklistItemCompleted)!.properties[AnalyticsProperties.item], 'diary');
  });

  testWidgets('all four done: the card leaves for good', (tester) async {
    client.granted = true;
    await tester.pumpWidget(card(hasDiary: true, hasMemory: true));
    await tester.pumpAndSettle();

    expect(find.text('Premiers pas'), findsNothing);
    expect(store.dismissed, isTrue);
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

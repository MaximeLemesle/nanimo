import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notification_priming_sheet.dart';

import '../analytics/recording_analytics_service.dart';
import 'fake_notification_client.dart';

void main() {
  late FakeNotificationClient client;
  late MemoryPrimingStore store;
  late RecordingAnalyticsService recorder;
  var now = DateTime(2026, 10, 16, 15);

  NotificationPriming build() => NotificationPriming(client: () => client, store: store, now: () => now);

  final offer = PrimingOffer(petName: 'Saïko', dueDate: DateTime(2026, 11, 12));

  setUp(() {
    client = FakeNotificationClient();
    store = MemoryPrimingStore();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    now = DateTime(2026, 10, 16, 15);
  });

  tearDown(() => analytics = const NoopAnalyticsService());

  test('offers after a reminder ahead, when never asked', () async {
    final priming = build();
    await priming.offerFor(offer);
    expect(priming.offer.value, same(offer));
  });

  test('never offers for a date already gone', () async {
    final priming = build();
    await priming.offerFor(PrimingOffer(petName: 'Saïko', dueDate: DateTime(2026, 10, 1)));
    expect(priming.offer.value, isNull);
  });

  test('stays silent once the system already granted or refused', () async {
    client.granted = true;
    final granted = build();
    await granted.offerFor(offer);
    expect(granted.offer.value, isNull);

    client.granted = false;
    store.shown = true;
    final denied = build();
    await denied.offerFor(offer);
    expect(denied.offer.value, isNull);
    expect(await denied.permissionState(), NotificationPermissionState.denied);
  });

  test('"Oui" shows the system prompt and reports the answer', () async {
    final priming = build();
    await priming.offerFor(offer);

    expect(await priming.accept(), isTrue);
    expect(client.requestCount, 1);
    expect(store.shown, isTrue);
    expect(priming.offer.value, isNull);
    expect(recorder.lastOf(AnalyticsEvents.notificationPermission)!.properties[AnalyticsProperties.result], 'granted');

    client.grantOnRequest = false;
    await build().accept();
    expect(recorder.lastOf(AnalyticsEvents.notificationPermission)!.properties[AnalyticsProperties.result], 'denied');
  });

  test('"Plus tard" never shows the system prompt and comes back after 7 days', () async {
    final priming = build();
    await priming.offerFor(offer);
    await priming.postpone();

    expect(client.requestCount, 0);
    expect(recorder.lastOf(AnalyticsEvents.notificationPermission)!.properties[AnalyticsProperties.result], 'later');

    now = now.add(const Duration(days: 6));
    await priming.offerFor(offer);
    expect(priming.offer.value, isNull);

    now = now.add(const Duration(days: 2));
    await priming.offerFor(PrimingOffer(petName: 'Saïko', dueDate: DateTime(2026, 12, 12)));
    expect(priming.offer.value, isNotNull);
  });

  testWidgets('the sheet names the animal and the date', (tester) async {
    await tester.binding.setSurfaceSize(const Size(400, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    bool? result;
    await tester.pumpWidget(MaterialApp(
      home: Builder(
        builder: (context) => TextButton(
          onPressed: () async => result = await showModalBottomSheet<bool>(
            context: context,
            isScrollControlled: true,
            builder: (_) => NotificationPrimingSheet(offer: offer),
          ),
          child: const Text('open'),
        ),
      ),
    ));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(find.text('On te prévient avant le rappel de Saïko du 12/11 ?'), findsOneWidget);
    await tester.tap(find.text('Plus tard'));
    await tester.pumpAndSettle();
    expect(result, isFalse);

    expect(
      NotificationPrimingSheet.question(PrimingOffer(petName: 'Saïko', dueDate: DateTime(2026, 10, 20), isVetVisit: true)),
      'On te prévient la veille de la visite de Saïko du 20/10 ?',
    );
  });
}

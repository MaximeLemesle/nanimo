import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/analytics/posthog_analytics_service.dart';

class _MockPosthog extends Mock implements Posthog {}

void main() {
  late _MockPosthog posthog;
  late PostHogAnalyticsService service;

  setUp(() {
    posthog = _MockPosthog();
    service = PostHogAnalyticsService(posthog: posthog);
  });

  test('forwards the event name and its properties', () async {
    when(() => posthog.capture(
          eventName: any(named: 'eventName'),
          properties: any(named: 'properties'),
        )).thenAnswer((_) async {});

    await service.capture('paywall_opened', properties: {'trigger': 'add_pet'});

    verify(() => posthog.capture(
          eventName: 'paywall_opened',
          properties: {'trigger': 'add_pet'},
        )).called(1);
  });

  /// A dropped metric costs nothing, a crash on a metric costs a user. Every
  /// call site is fire-and-forget, so a throw here would surface unhandled.
  test('a failing SDK never propagates', () async {
    when(() => posthog.capture(
          eventName: any(named: 'eventName'),
          properties: any(named: 'properties'),
        )).thenThrow(Exception('sdk down'));
    when(() => posthog.screen(screenName: any(named: 'screenName')))
        .thenThrow(Exception('sdk down'));
    when(() => posthog.reset()).thenThrow(Exception('sdk down'));

    await expectLater(service.capture('anything'), completes);
    await expectLater(service.screen('/home'), completes);
    await expectLater(service.forgetUser(), completes);
  });

  test('identify carries the account id', () async {
    when(() => posthog.identify(
          userId: any(named: 'userId'),
          userProperties: any(named: 'userProperties'),
        )).thenAnswer((_) async {});

    await service.identifyUser('user-1');

    verify(() => posthog.identify(userId: 'user-1', userProperties: null))
        .called(1);
  });

  test('setEnabled maps onto the SDK opt-in and opt-out', () async {
    when(() => posthog.enable()).thenAnswer((_) async {});
    when(() => posthog.disable()).thenAnswer((_) async {});

    await service.setEnabled(true);
    verify(() => posthog.enable()).called(1);

    await service.setEnabled(false);
    verify(() => posthog.disable()).called(1);
  });

  group('NoopAnalyticsService', () {
    test('every call is a no-op that completes', () async {
      const noop = NoopAnalyticsService();

      await expectLater(noop.capture('x', properties: {'a': 1}), completes);
      await expectLater(noop.screen('/home'), completes);
      await expectLater(noop.identifyUser('user-1'), completes);
      await expectLater(noop.forgetUser(), completes);
      await expectLater(noop.setEnabled(true), completes);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:nanimo/core/monitoring/sentry_monitoring_service.dart';

/// Records what happened instead of contacting Sentry.
SentryMonitoringService _service({
  bool throwOnInit = false,
  List<String>? calls,
}) {
  return SentryMonitoringService(
    dsn: 'https://key@o0.ingest.sentry.io/1',
    release: 'nanimo@0.14.0+1',
    environment: 'production',
    initializer: (configure, appRunner) async {
      calls?.add('init');
      if (throwOnInit) throw Exception('no network');
      await appRunner();
    },
  );
}

SentryFlutterOptions _configuredOptions() {
  final options = SentryFlutterOptions();
  _service().configure(options);
  return options;
}

void main() {
  group('start', () {
    test('runs the app inside the reporter', () async {
      final calls = <String>[];
      await _service(calls: calls).start(() => calls.add('app'));

      expect(calls, ['init', 'app']);
    });

    /// A broken accessory must never prevent the app from starting.
    test('still runs the app when the reporter cannot start', () async {
      var ran = false;
      await _service(throwOnInit: true).start(() => ran = true);

      expect(ran, isTrue);
    });
  });

  group('configure', () {
    test('applies the DSN, release and environment', () {
      final options = _configuredOptions();

      expect(options.dsn, 'https://key@o0.ingest.sentry.io/1');
      expect(options.release, 'nanimo@0.14.0+1');
      expect(options.environment, 'production');
    });

    /// Screens show private photos and health records.
    test('never attaches screenshots or the view hierarchy', () {
      final options = _configuredOptions();

      expect(options.attachScreenshot, isFalse);
      expect(options.attachViewHierarchy, isFalse);
      expect(options.sendDefaultPii, isFalse);
    });

    test('keeps performance tracing off', () {
      expect(_configuredOptions().tracesSampleRate, 0.0);
    });

    /// Sessions produce the crash-free rate.
    test('tracks sessions', () {
      expect(_configuredOptions().enableAutoSessionTracking, isTrue);
    });
  });

  group('beforeSend', () {
    Future<SentryEvent?> send(SentryEvent event) async {
      final options = _configuredOptions();
      return await options.beforeSend!(event, Hint());
    }

    test('keeps the account id but drops every way to reach the user',
        () async {
      final event = SentryEvent(
        user: SentryUser(
          id: 'user-42',
          email: 'maxime@example.com',
          ipAddress: '90.12.34.56',
          username: 'maxime',
        ),
      );

      final sent = await send(event);

      expect(sent!.user!.id, 'user-42');
      expect(sent.user!.email, isNull);
      expect(sent.user!.ipAddress, isNull);
      expect(sent.user!.username, isNull);
    });

    test('leaves an event without a user untouched', () async {
      final sent = await send(SentryEvent());

      expect(sent, isNotNull);
      expect(sent!.user, isNull);
    });

    /// Supabase URLs carry access tokens in the query string.
    test('strips query strings from breadcrumb data', () async {
      final event = SentryEvent(
        breadcrumbs: [
          Breadcrumb(
            message: 'GET',
            data: {
              'url': 'https://x.supabase.co/rest/v1/pets?apikey=secret-token',
              'status_code': 200,
            },
          ),
        ],
      );

      final sent = await send(event);
      final data = sent!.breadcrumbs!.single.data!;

      expect(data['url'], 'https://x.supabase.co/rest/v1/pets?[filtré]');
      expect(data['url'], isNot(contains('secret-token')));
      // Non-string values must survive untouched.
      expect(data['status_code'], 200);
    });

    test('leaves a URL without a query string alone', () async {
      final event = SentryEvent(
        breadcrumbs: [
          Breadcrumb(data: {'url': 'https://x.supabase.co/rest/v1/pets'}),
        ],
      );

      final sent = await send(event);

      expect(sent!.breadcrumbs!.single.data!['url'],
          'https://x.supabase.co/rest/v1/pets');
    });

    test('leaves a breadcrumb without data alone', () async {
      final event = SentryEvent(breadcrumbs: [Breadcrumb(message: 'tap')]);

      final sent = await send(event);

      expect(sent!.breadcrumbs!.single.message, 'tap');
      expect(sent.breadcrumbs!.single.data, isNull);
    });
  });
}

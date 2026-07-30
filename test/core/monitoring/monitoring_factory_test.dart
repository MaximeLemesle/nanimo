import 'package:flutter_test/flutter_test.dart';

import 'package:nanimo/core/monitoring/monitoring_factory.dart';
import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:nanimo/core/monitoring/sentry_monitoring_service.dart';

void main() {
  group('createMonitoringService', () {
    test('reports when a DSN is set on a release build', () {
      final service = createMonitoringService(
        dsn: 'https://key@o0.ingest.sentry.io/1',
        appVersion: '0.14.0+1',
        isReleaseBuild: true,
      );

      expect(service, isA<SentryMonitoringService>());
    });

    /// Debug builds must stay silent: hot-reload exceptions would bury the real
    /// production signal and eat the quota.
    test('stays silent on a debug build even with a DSN', () {
      final service = createMonitoringService(
        dsn: 'https://key@o0.ingest.sentry.io/1',
        appVersion: '0.14.0+1',
        isReleaseBuild: false,
      );

      expect(service, isA<NoopMonitoringService>());
    });

    test('stays silent when the DSN is missing', () {
      expect(
        createMonitoringService(
          dsn: null,
          appVersion: '0.14.0+1',
          isReleaseBuild: true,
        ),
        isA<NoopMonitoringService>(),
      );
    });

    /// An empty variable in .env is the same as no variable at all. Passing it
    /// straight to Sentry would raise at startup.
    test('treats an empty DSN as disabled', () {
      expect(
        createMonitoringService(
          dsn: '',
          appVersion: '0.14.0+1',
          isReleaseBuild: true,
        ),
        isA<NoopMonitoringService>(),
      );
    });
  });

  group('NoopMonitoringService', () {
    /// The app must boot whether monitoring is on or off. Forgetting to call
    /// appRunner here would ship a black screen.
    test('still runs the app', () async {
      var ran = false;
      await const NoopMonitoringService().start(() => ran = true);

      expect(ran, isTrue);
    });

    test('every other call is harmless', () async {
      const service = NoopMonitoringService();

      await expectLater(
        Future.wait([
          service.captureException(Exception('boom')),
          service.identifyUser('user-1'),
          service.forgetUser(),
          service.addBreadcrumb('tap'),
        ]),
        completes,
      );
    });
  });
}

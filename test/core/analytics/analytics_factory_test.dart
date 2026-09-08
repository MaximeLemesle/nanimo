import 'package:flutter_test/flutter_test.dart';

import 'package:nanimo/core/analytics/analytics_factory.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';

void main() {
  group('createAnalyticsService', () {
    test('stays inert without a key', () async {
      final service = await createAnalyticsService(
        apiKey: null,
        host: null,
        isReleaseBuild: true,
      );

      expect(service, isA<NoopAnalyticsService>());
    });

    test('stays inert on an empty key', () async {
      final service = await createAnalyticsService(
        apiKey: '',
        host: null,
        isReleaseBuild: true,
      );

      expect(service, isA<NoopAnalyticsService>());
    });

    /// Hot-reload traffic would land in the same funnels as production and
    /// make every conversion rate wrong.
    test('stays inert in a debug build even with a key', () async {
      final service = await createAnalyticsService(
        apiKey: 'phc_test',
        host: null,
        isReleaseBuild: false,
      );

      expect(service, isA<NoopAnalyticsService>());
    });

    test('defaults to the EU region', () {
      expect(defaultPostHogHost, 'https://eu.i.posthog.com');
    });
  });
}

import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/analytics/posthog_analytics_service.dart';

const String defaultPostHogHost = 'https://eu.i.posthog.com';

/// Debug builds stay silent, exactly like Sentry: hot-reload noise would
/// pollute the funnels the release build is measured on.
Future<AnalyticsService> createAnalyticsService({
  required String? apiKey,
  required String? host,
  required bool isReleaseBuild,
}) async {
  if (apiKey == null || apiKey.isEmpty || !isReleaseBuild) {
    return const NoopAnalyticsService();
  }

  await PostHogAnalyticsService.configure(
    apiKey: apiKey,
    host: (host == null || host.isEmpty) ? defaultPostHogHost : host,
  );
  return PostHogAnalyticsService();
}

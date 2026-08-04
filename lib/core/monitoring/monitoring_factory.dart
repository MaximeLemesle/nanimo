import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:nanimo/core/monitoring/sentry_monitoring_service.dart';

/// Decides whether crash reporting runs, and under which release.
MonitoringService createMonitoringService({
  required String? dsn,
  required String appVersion,
  required bool isReleaseBuild,
}) {
  if (dsn == null || dsn.isEmpty || !isReleaseBuild) {
    return const NoopMonitoringService();
  }

  return SentryMonitoringService(
    dsn: dsn,
    // Must match the format used when uploading debug symbols, otherwise
    // stack traces stay obfuscated on Android.
    release: 'nanimo@$appVersion',
    environment: 'production',
  );
}

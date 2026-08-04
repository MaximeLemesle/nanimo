import 'package:nanimo/core/monitoring/monitoring_service.dart';
import 'package:nanimo/core/monitoring/sentry_monitoring_service.dart';

/// Debug builds stay silent: hot-reload exceptions would bury the production
/// signal and burn the quota.
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
    // Must match the release used when uploading debug symbols.
    release: 'nanimo@$appVersion',
    environment: 'production',
  );
}

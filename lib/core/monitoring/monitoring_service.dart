import 'dart:async';

/// Crash reporting seam. The app depends on this, never on Sentry directly.
abstract class MonitoringService {
  /// Must call [appRunner] exactly once, even when reporting is disabled.
  Future<void> start(FutureOr<void> Function() appRunner);

  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? hint,
  });

  /// Account id only, never the e-mail.
  Future<void> identifyUser(String userId);

  Future<void> forgetUser();

  Future<void> addBreadcrumb(String message, {String? category});
}

/// Used when no DSN is configured, and in tests.
class NoopMonitoringService implements MonitoringService {
  const NoopMonitoringService();

  @override
  Future<void> start(FutureOr<void> Function() appRunner) async {
    await appRunner();
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? hint,
  }) async {}

  @override
  Future<void> identifyUser(String userId) async {}

  @override
  Future<void> forgetUser() async {}

  @override
  Future<void> addBreadcrumb(String message, {String? category}) async {}
}

import 'dart:async';

abstract class MonitoringService {
  /// [appRunner] must be called exactly once, even when reporting is disabled:
  /// a monitoring failure must never stop the app from starting.
  Future<void> start(FutureOr<void> Function() appRunner);

  /// Reports an error the app caught and handled itself.
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? hint,
  });

  /// Attaches the signed-in user id so an anomaly can be traced back to a support request
  Future<void> identifyUser(String userId);

  Future<void> forgetUser();

  /// Records a step in the user journey, to reconstruct what led to a crash
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

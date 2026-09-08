/// Product analytics seam. The app depends on this, never on PostHog directly.
abstract class AnalyticsService {
  Future<void> capture(String event, {Map<String, Object>? properties});

  Future<void> screen(String name);

  /// Account id only, never the e-mail.
  Future<void> identifyUser(String userId, {Map<String, Object>? properties});

  Future<void> forgetUser();

  /// Opt-out must survive a restart, so the SDK owns the flag, not the caller.
  Future<void> setEnabled(bool enabled);
}

/// Used when no key is configured, in debug builds, and in tests.
class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> capture(String event, {Map<String, Object>? properties}) async {}

  @override
  Future<void> screen(String name) async {}

  @override
  Future<void> identifyUser(
    String userId, {
    Map<String, Object>? properties,
  }) async {}

  @override
  Future<void> forgetUser() async {}

  @override
  Future<void> setEnabled(bool enabled) async {}
}

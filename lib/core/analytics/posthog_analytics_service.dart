import 'dart:developer' as developer;

import 'package:posthog_flutter/posthog_flutter.dart';

import 'package:nanimo/core/analytics/analytics_service.dart';

/// Analytics must never take the app down: a dropped metric costs nothing,
/// a crash on a capture costs a user.
class PostHogAnalyticsService implements AnalyticsService {
  final Posthog _posthog;

  PostHogAnalyticsService({Posthog? posthog}) : _posthog = posthog ?? Posthog();

  static Future<void> configure({
    required String apiKey,
    required String host,
  }) async {
    final config = PostHogConfig(apiKey)
      ..host = host
      ..captureApplicationLifecycleEvents = true
      ..personProfiles = PostHogPersonProfiles.identifiedOnly;

    await Posthog().setup(config);
  }

  @override
  Future<void> capture(String event, {Map<String, Object>? properties}) =>
      _guard('capture $event', () => _posthog.capture(eventName: event, properties: properties));

  @override
  Future<void> screen(String name) =>
      _guard('screen $name', () => _posthog.screen(screenName: name));

  @override
  Future<void> identifyUser(String userId, {Map<String, Object>? properties}) =>
      _guard('identify', () => _posthog.identify(userId: userId, userProperties: properties));

  @override
  Future<void> forgetUser() => _guard('reset', () => _posthog.reset());

  @override
  Future<void> setEnabled(bool enabled) =>
      _guard('setEnabled', () => enabled ? _posthog.enable() : _posthog.disable());

  Future<void> _guard(String action, Future<void> Function() body) async {
    try {
      await body();
    } catch (e, st) {
      developer.log('analytics $action failed', name: 'analytics', error: e, stackTrace: st);
    }
  }
}

import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';
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
    String environment = 'production',
  }) async {
    final config = PostHogConfig(apiKey)
      ..host = host
      ..captureApplicationLifecycleEvents = true
      ..personProfiles = PostHogPersonProfiles.identifiedOnly
      ..sessionReplay = true
      ..sessionReplayConfig.maskAllTexts = true
      ..sessionReplayConfig.maskAllImages = true;

    await Posthog().setup(config);
    await Posthog().register('environment', environment);
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
  Future<void> setPersonProperties(Map<String, Object> properties) => _guard(
      'set person', () => _posthog.capture(eventName: r'$set', userProperties: properties));

  @override
  Future<void> forgetUser() => _guard('reset', () => _posthog.reset());

  @override
  Future<void> setEnabled(bool enabled) =>
      _guard('setEnabled', () => enabled ? _posthog.enable() : _posthog.disable());

  @override
  Future<bool> isEnabled() async {
    try {
      return !await _posthog.isOptOut();
    } catch (e, st) {
      developer.log('analytics isOptOut failed', name: 'analytics', error: e, stackTrace: st);
      return true;
    }
  }

  Future<void> _guard(String action, Future<void> Function() body) async {
    try {
      await body();
    } catch (e, st) {
      developer.log('analytics $action failed', name: 'analytics', error: e, stackTrace: st);
    }
  }
}

/// Journal entries and pet photos are private: replay frames mask every text
/// and image. Inert when the SDK was never configured (debug builds, tests).
class AnalyticsReplayRoot extends StatelessWidget {
  final Widget child;

  const AnalyticsReplayRoot({super.key, required this.child});

  @override
  Widget build(BuildContext context) => PostHogWidget(child: child);
}

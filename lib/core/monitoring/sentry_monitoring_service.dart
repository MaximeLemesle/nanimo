import 'dart:async';
import 'dart:developer' as developer;

import 'package:sentry_flutter/sentry_flutter.dart';

import 'package:nanimo/core/monitoring/monitoring_service.dart';

/// Sentry-backed crash reporting.
/// Captured: unhandled Flutter exceptions, uncaught async errors in the app's
/// error zone, native crashes, and errors the app reports explicitly through [captureException].
class SentryMonitoringService implements MonitoringService {
  final String _dsn;
  final String _release;
  final String _environment;

  /// Injected so tests drive the whole class without a network call.
  final Future<void> Function(
    void Function(SentryFlutterOptions) configure,
    FutureOr<void> Function() appRunner,
  ) _initializer;

  SentryMonitoringService({
    required String dsn,
    required String release,
    required String environment,
    Future<void> Function(
      void Function(SentryFlutterOptions),
      FutureOr<void> Function(),
    )? initializer,
  })  : _dsn = dsn,
        _release = release,
        _environment = environment,
        _initializer = initializer ?? _defaultInitializer;

  static Future<void> _defaultInitializer(
    void Function(SentryFlutterOptions) configure,
    FutureOr<void> Function() appRunner,
  ) {
    return SentryFlutter.init(configure, appRunner: appRunner);
  }

  @override
  Future<void> start(FutureOr<void> Function() appRunner) async {
    try {
      await _initializer(configure, appRunner);
    } catch (e, st) {
      // A reporter that cannot start must not take the app down with it.
      developer.log('Sentry failed to start, running without monitoring',
          name: 'monitoring', error: e, stackTrace: st);
      await appRunner();
    }
  }

  /// Visible for tests: asserts the privacy posture without booting Sentry.
  void configure(SentryFlutterOptions options) {
    options.dsn = _dsn;
    options.release = _release;
    options.environment = _environment;

    // Never send personal data Sentry would otherwise collect on its own.
    options.sendDefaultPii = false;
    options.attachScreenshot = false;
    options.attachViewHierarchy = false;

    // No performance tracing for now, see the class doc.
    options.tracesSampleRate = 0.0;

    // Sessions give the crash-free session rate, the indicator used to tell a
    // healthy release from a broken one.
    options.enableAutoSessionTracking = true;

    options.beforeSend = _scrub;
  }

  /// Runs on every event, including those Sentry builds itself, so a future SDK
  /// default that starts collecting more cannot leak through.
  FutureOr<SentryEvent?> _scrub(SentryEvent event, Hint hint) {
    final user = event.user;
    return event.copyWith(
      user: user == null
          ? null
          : SentryUser(
              id: user.id,
              email: null,
              ipAddress: null,
              username: null,
              geo: null,
            ),
      breadcrumbs: event.breadcrumbs?.map(_scrubBreadcrumb).toList(),
    );
  }

  Breadcrumb _scrubBreadcrumb(Breadcrumb crumb) {
    final data = crumb.data;
    if (data == null) return crumb;

    final cleaned = <String, dynamic>{};
    data.forEach((key, value) {
      cleaned[key] = value is String ? _stripQuery(value) : value;
    });
    return crumb.copyWith(data: cleaned);
  }

  String _stripQuery(String value) {
    final index = value.indexOf('?');
    return index == -1 ? value : '${value.substring(0, index)}?[filtré]';
  }

  @override
  Future<void> captureException(
    Object exception, {
    StackTrace? stackTrace,
    String? hint,
  }) async {
    try {
      await Sentry.captureException(
        exception,
        stackTrace: stackTrace,
        withScope: hint == null
            ? null
            : (scope) => scope.setContexts('contexte', {'origine': hint}),
      );
    } catch (e, st) {
      developer.log('could not report an exception',
          name: 'monitoring', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> identifyUser(String userId) async {
    try {
      await Sentry.configureScope((scope) => scope.setUser(SentryUser(id: userId)));
    } catch (e, st) {
      developer.log('could not attach the user',
          name: 'monitoring', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> forgetUser() async {
    try {
      await Sentry.configureScope((scope) => scope.setUser(null));
    } catch (e, st) {
      developer.log('could not detach the user',
          name: 'monitoring', error: e, stackTrace: st);
    }
  }

  @override
  Future<void> addBreadcrumb(String message, {String? category}) async {
    try {
      await Sentry.addBreadcrumb(
        Breadcrumb(message: message, category: category),
      );
    } catch (e, st) {
      developer.log('could not add a breadcrumb',
          name: 'monitoring', error: e, stackTrace: st);
    }
  }
}

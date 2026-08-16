import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/monitoring/breadcrumb_route_observer.dart';
import 'package:nanimo/core/monitoring/error_reporter.dart';
import 'package:nanimo/core/monitoring/monitoring_service.dart';

class _RecordingMonitoringService implements MonitoringService {
  final List<String> breadcrumbs = [];
  final List<String?> categories = [];

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
  Future<void> addBreadcrumb(String message, {String? category}) async {
    breadcrumbs.add(message);
    categories.add(category);
  }
}

Route<void> _route(String? name) {
  return PageRouteBuilder<void>(
    settings: RouteSettings(name: name),
    pageBuilder: (_, __, ___) => const SizedBox.shrink(),
  );
}

void main() {
  late _RecordingMonitoringService reporter;
  late BreadcrumbRouteObserver observer;

  setUp(() {
    reporter = _RecordingMonitoringService();
    errorReporter = reporter;
    observer = BreadcrumbRouteObserver();
  });

  tearDown(() {
    errorReporter = const NoopMonitoringService();
  });

  test('records the screen being opened', () {
    observer.didPush(_route('/pet/create'), null);

    expect(reporter.breadcrumbs, ['ouvre /pet/create']);
    expect(reporter.categories, ['navigation']);
  });

  test('records the screen being left', () {
    observer.didPop(_route('/pet/create'), null);

    expect(reporter.breadcrumbs, ['quitte /pet/create']);
  });

  test('records a replacement', () {
    observer.didReplace(newRoute: _route('/home'), oldRoute: _route('/splash'));

    expect(reporter.breadcrumbs, ['remplace par /home']);
  });

  /// An unnamed route would produce a breadcrumb saying nothing.
  test('ignores an unnamed route', () {
    observer.didPush(_route(null), null);
    observer.didPush(_route(''), null);

    expect(reporter.breadcrumbs, isEmpty);
  });
}

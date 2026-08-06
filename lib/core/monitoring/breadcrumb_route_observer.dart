import 'package:flutter/widgets.dart';

import 'package:nanimo/core/monitoring/error_reporter.dart';

/// Records screen changes so a report says what the user was doing before the
/// failure, not only which operation failed. Route names come from the page
/// built in [createRouter], which carries the router path.
class BreadcrumbRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record('ouvre', route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record('quitte', route);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (newRoute != null) _record('remplace par', newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _record(String action, Route<dynamic> route) {
    final name = route.settings.name;
    if (name == null || name.isEmpty) return;
    errorReporter.addBreadcrumb('$action $name', category: 'navigation');
  }
}

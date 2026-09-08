import 'package:flutter/widgets.dart';

import 'package:nanimo/core/analytics/analytics.dart';

/// Screen views feed the funnel steps that have no explicit event of their own.
/// Route names come from [createRouter], which carries the router path.
class ScreenViewRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record(route);
    super.didPush(route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _record(previousRoute);
    super.didPop(route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _record(newRoute);
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
  }

  void _record(Route<dynamic>? route) {
    final name = route?.settings.name;
    if (name == null || name.isEmpty) return;
    analytics.screen(name);
  }
}

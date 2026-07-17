import 'package:flutter/material.dart';

/// Tracks whether a modal route (bottom sheet, dialog) is open on the shell's
/// navigator.
///
/// The shell's nav bar is the Scaffold's `bottomNavigationBar`, so it sits
/// *outside* the navigator the sheets are pushed onto and paints over them.
/// The bar has to be told to get out of the way, and only the navigator knows
/// when a sheet is up.
///
/// Counted rather than a plain flag: sheets open other sheets (the health diary
/// sheet opens the vet visit one), and popping the inner one must not bring the
/// bar back while the outer is still up.
class ModalRouteObserver extends NavigatorObserver {
  final ValueNotifier<bool> isModalOpen = ValueNotifier(false);

  int _openCount = 0;

  void _sync() {
    if (_openCount < 0) _openCount = 0;
    isModalOpen.value = _openCount > 0;
  }

  bool _isModal(Route<dynamic>? route) => route is PopupRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isModal(route)) return;
    _openCount++;
    _sync();
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isModal(route)) return;
    _openCount--;
    _sync();
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    if (!_isModal(route)) return;
    _openCount--;
    _sync();
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    if (_isModal(oldRoute)) _openCount--;
    if (_isModal(newRoute)) _openCount++;
    _sync();
  }

  void dispose() => isModalOpen.dispose();
}

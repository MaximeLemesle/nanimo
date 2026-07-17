import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/modal_route_observer.dart';

class _FakePopupRoute extends PopupRoute<void> {
  @override
  Color? get barrierColor => null;

  @override
  bool get barrierDismissible => true;

  @override
  String? get barrierLabel => null;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) =>
      const SizedBox();

  @override
  Duration get transitionDuration => Duration.zero;
}

void main() {
  late ModalRouteObserver observer;

  setUp(() => observer = ModalRouteObserver());
  tearDown(() => observer.dispose());

  PopupRoute<void> popup() => _FakePopupRoute();
  Route<void> page() => PageRouteBuilder<void>(
        pageBuilder: (_, __, ___) => const SizedBox(),
      );

  test('starts closed', () {
    expect(observer.isModalOpen.value, isFalse);
  });

  test('opens on a modal push and closes on its pop', () {
    final route = popup();

    observer.didPush(route, null);
    expect(observer.isModalOpen.value, isTrue);

    observer.didPop(route, null);
    expect(observer.isModalOpen.value, isFalse);
  });

  test('ignores ordinary page routes', () {
    observer.didPush(page(), null);
    expect(observer.isModalOpen.value, isFalse);
  });

  test('stays open until the outermost of two nested sheets is popped', () {
    final outer = popup();
    final inner = popup();

    observer.didPush(outer, null);
    observer.didPush(inner, outer);
    expect(observer.isModalOpen.value, isTrue);

    /// The health diary sheet opens the vet visit sheet: closing the inner one
    /// must not bring the bar back over the outer one.
    observer.didPop(inner, outer);
    expect(observer.isModalOpen.value, isTrue);

    observer.didPop(outer, null);
    expect(observer.isModalOpen.value, isFalse);
  });

  test('closes when a modal is removed rather than popped', () {
    final route = popup();

    observer.didPush(route, null);
    observer.didRemove(route, null);
    expect(observer.isModalOpen.value, isFalse);
  });

  test('tracks a modal replaced by a page route', () {
    final route = popup();

    observer.didPush(route, null);
    observer.didReplace(newRoute: page(), oldRoute: route);
    expect(observer.isModalOpen.value, isFalse);
  });

  test('never goes negative on an unbalanced pop', () {
    observer.didPop(popup(), null);
    expect(observer.isModalOpen.value, isFalse);

    observer.didPush(popup(), null);
    expect(observer.isModalOpen.value, isTrue);
  });
}

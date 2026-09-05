import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/router/route_guard.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

class _MockGoRouterState extends Mock implements GoRouterState {}

GoRouterState _at(String location) {
  final state = _MockGoRouterState();
  when(() => state.matchedLocation).thenReturn(location);
  return state;
}

void main() {
  String? redirect(
    String location,
    AuthStatus status, {
    bool splashElapsed = true,
  }) =>
      handleRedirect(_at(location), status, splashElapsed: splashElapsed);

  group('unknown status', () {
    test('holds on the splash screen', () {
      expect(redirect(RouteNames.splash, AuthStatus.unknown), isNull);
    });

    test('sends anywhere else back to the splash screen', () {
      expect(
        redirect(RouteNames.home, AuthStatus.unknown),
        RouteNames.splash,
      );
    });
  });

  group('protected routes', () {
    test('sends an anonymous visitor on /home to the login', () {
      expect(
        redirect(RouteNames.home, AuthStatus.unauthenticated),
        RouteNames.login,
      );
    });

    /// The pet edit page lives at the root, outside the /home subtree, so it
    /// has to be guarded by name rather than inherited from it.
    test('sends an anonymous visitor on the pet edit page to the login', () {
      expect(
        redirect('${RouteNames.editPet}/p1', AuthStatus.unauthenticated),
        RouteNames.login,
      );
    });

    test('lets an authenticated user through to the pet edit page', () {
      expect(
        redirect('${RouteNames.editPet}/p1', AuthStatus.authenticated),
        isNull,
      );
    });
  });

  group('public routes', () {
    test('sends an authenticated user away from the login', () {
      expect(
        redirect(RouteNames.login, AuthStatus.authenticated),
        RouteNames.home,
      );
    });

    test('leaves an anonymous visitor on the login', () {
      expect(redirect(RouteNames.login, AuthStatus.unauthenticated), isNull);
    });
  });

  group('splash', () {
    test('stays put until its minimum duration has elapsed', () {
      expect(
        redirect(
          RouteNames.splash,
          AuthStatus.authenticated,
          splashElapsed: false,
        ),
        isNull,
      );
    });

    test('routes an authenticated user home once elapsed', () {
      expect(
        redirect(RouteNames.splash, AuthStatus.authenticated),
        RouteNames.home,
      );
    });

    test('routes an anonymous visitor to the onboarding once elapsed', () {
      expect(
        redirect(RouteNames.splash, AuthStatus.unauthenticated),
        RouteNames.onboarding,
      );
    });
  });
}

import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';

String? handleRedirect(
  GoRouterState state,
  AuthStatus status, {
  required bool splashElapsed,
}) {
  final location = state.matchedLocation;
  final isAuthenticated = status == AuthStatus.authenticated;
  final isPublicRoute = _publicRoutes.contains(location);
  final isProtected = _protectedRoutes.any(location.startsWith);

  /// First loading, redirect to the splash screen
  if (status == AuthStatus.unknown) {
    return location == RouteNames.splash ? null : RouteNames.splash;
  }

  /// Keep the splash visible for its minimum duration even when ready
  if (location == RouteNames.splash && !splashElapsed) return null;

  /// Protect the routes if the user is not authenticated
  if (!isAuthenticated && isProtected) return RouteNames.login;

  /// Avoid login if user is already authenticated
  if (isAuthenticated && isPublicRoute) return RouteNames.home;

  /// Redirection after the splash screen
  if (location == RouteNames.splash) {
    return isAuthenticated ? RouteNames.home : RouteNames.onboarding;
  }

  return null;
}

const _publicRoutes = {
  RouteNames.onboarding,
  RouteNames.createPet,
  RouteNames.login,
  RouteNames.signup,
};
const _protectedRoutes = {RouteNames.home};

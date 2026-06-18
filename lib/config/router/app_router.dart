import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_guard.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/app_shell.dart';
import 'package:nanimo/core/widgets/error_screen.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/auth/presentation/page/login_page.dart';
import 'package:nanimo/features/auth/presentation/page/signup_page.dart';
import 'package:nanimo/features/home/presentation/page/home_page.dart';
import 'package:nanimo/features/home/presentation/page/profile_page.dart';
import 'package:nanimo/features/pet/presentation/page/create_pet_page.dart';
import 'package:nanimo/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:nanimo/features/onboarding/presentation/page/splash_page.dart';
import 'package:nanimo/features/pet/presentation/page/pet_page.dart';
import 'package:nanimo/features/pet/presentation/page/pet_health_diary_page.dart';

class _AuthCubitListenable extends ChangeNotifier {
  _AuthCubitListenable(AuthCubit cubit) {
    cubit.stream.listen((_) => notifyListeners());
  }
}

GoRouter createRouter(AuthCubit authCubit) {
  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: _AuthCubitListenable(authCubit),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return handleRedirect(state, authCubit.state.status);
    },
    routes: [
      GoRoute(
        path: RouteNames.splash,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        builder: (_, __) => const OnboardingPage(),
      ),
      GoRoute(
        path: RouteNames.createPet,
        builder: (_, __) => const CreatePetPage(),
      ),
      GoRoute(
        path: RouteNames.login,
        builder: (_, __) => const LoginPage(),
      ),
      GoRoute(
        path: RouteNames.signup,
        builder: (_, __) => const SignupPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => AppShell(child: child),
        routes: [
          GoRoute(
            path: RouteNames.home,
            builder: (_, __) => const HomePage(),
            routes: [
              GoRoute(
                path: 'pet',
                builder: (_, __) => const PetPage(),
                routes: [
                  GoRoute(
                    path: 'health-diary',
                    builder: (_, __) => const PetHealthDiaryPage(),
                  ),
                ],
              ),
              GoRoute(
                path: 'profile',
                builder: (_, __) => const ProfilePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}

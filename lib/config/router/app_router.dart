import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_guard.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/app_shell.dart';
import 'package:nanimo/core/widgets/error_screen.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/auth/presentation/page/login_page.dart';
import 'package:nanimo/features/auth/presentation/page/signup_page.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/event/presentation/page/create_event_page.dart';
import 'package:nanimo/features/event/presentation/page/edit_event_page.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/page/journal_page.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
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

GoRouter createRouter(
  AuthCubit authCubit, {
  required EventRepository eventRepository,
  required ReferentialRepository referentialRepository,
  required PetRepository petRepository,
}) {
  /// Flips to true after the splash display duration
  final splashElapsed = ValueNotifier(false);
  Timer(const Duration(milliseconds: 1200), () => splashElapsed.value = true);

  return GoRouter(
    initialLocation: RouteNames.splash,
    refreshListenable: Listenable.merge([
      _AuthCubitListenable(authCubit),
      splashElapsed,
    ]),
    debugLogDiagnostics: true,
    redirect: (context, state) {
      return handleRedirect(
        state,
        authCubit.state.status,
        splashElapsed: splashElapsed.value,
      );
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
                path: 'create-event',
                builder: (_, __) => BlocProvider(
                  create: (_) => EventCreationCubit(
                    eventRepository: eventRepository,
                    referentialRepository: referentialRepository,
                    petRepository: petRepository,
                  )..load(),
                  child: const CreateEventPage(),
                ),
              ),
              GoRoute(
                path: 'edit-event/:eventId',
                builder: (_, state) => BlocProvider(
                  create: (_) => EditEventCubit(
                    eventRepository: eventRepository,
                    referentialRepository: referentialRepository,
                    petRepository: petRepository,
                  )..load(state.pathParameters['eventId']!),
                  child: const EditEventPage(),
                ),
              ),
              GoRoute(
                path: 'journal',
                builder: (_, __) => BlocProvider(
                  create: (_) => JournalCubit(
                    eventRepository: eventRepository,
                    petRepository: petRepository,
                    referentialRepository: referentialRepository,
                  ),
                  child: const JournalPage(),
                ),
              ),
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

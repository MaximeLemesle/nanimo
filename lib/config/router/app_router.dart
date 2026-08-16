import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_guard.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/app_shell.dart';
import 'package:nanimo/core/monitoring/breadcrumb_route_observer.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/modal_route_observer.dart';
import 'package:nanimo/core/widgets/error_screen.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/auth/presentation/page/login_page.dart';
import 'package:nanimo/features/auth/presentation/page/signup_page.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/presentation/cubit/edit_event_cubit.dart';
import 'package:nanimo/features/event/presentation/cubit/event_creation_cubit.dart';
import 'package:nanimo/features/event/presentation/page/create_event_page.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/event/presentation/page/edit_event_page.dart';
import 'package:nanimo/features/journal/presentation/cubit/journal_cubit.dart';
import 'package:nanimo/features/journal/presentation/page/journal_page.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/home/presentation/page/home_page.dart';
import 'package:nanimo/features/pet/presentation/page/create_pet_page.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:nanimo/features/settings/presentation/page/settings_page.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/paywall_cubit.dart';
import 'package:nanimo/features/subscription/presentation/page/paywall_page.dart';
import 'package:nanimo/features/onboarding/presentation/page/onboarding_page.dart';
import 'package:nanimo/features/onboarding/presentation/page/splash_page.dart';
import 'package:nanimo/features/pet/presentation/page/pet_page.dart';
import 'package:nanimo/features/pet/presentation/page/pet_health_diary_page.dart';

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    name: state.fullPath ?? state.uri.path,
    child: child,
    transitionDuration: const Duration(milliseconds: 180),
    reverseTransitionDuration: const Duration(milliseconds: 180),
    transitionsBuilder: (_, animation, __, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOut),
      child: child,
    ),
  );
}

class _AuthCubitListenable extends ChangeNotifier {
  late final StreamSubscription<AuthState> _subscription;

  _AuthCubitListenable(AuthCubit cubit) {
    _subscription = cubit.stream.listen((_) => notifyListeners());
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

GoRouter createRouter(
  AuthCubit authCubit, {
  required AuthRepository authRepository,
  required EventRepository eventRepository,
  required ReferentialRepository referentialRepository,
  required PetRepository petRepository,
  required HealthRepository healthRepository,
  required SettingsRepository settingsRepository,
  required PurchaseRepository purchaseRepository,
}) {
  /// Flips to true after the splash display duration
  final splashElapsed = ValueNotifier(false);
  Timer(const Duration(milliseconds: 1200), () => splashElapsed.value = true);

  final modalRouteObserver = ModalRouteObserver();

  /// One instance per Navigator: an observer cannot be attached to two of them.
  return GoRouter(
    observers: [BreadcrumbRouteObserver()],
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
        pageBuilder: (_, state) => _fadePage(state, const SplashPage()),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        pageBuilder: (_, state) => _fadePage(state, const OnboardingPage()),
      ),
      GoRoute(
        path: RouteNames.createPet,
        pageBuilder: (_, state) => _fadePage(state, const CreatePetPage()),
      ),
      GoRoute(
        path: RouteNames.login,
        pageBuilder: (_, state) => _fadePage(state, const LoginPage()),
      ),
      GoRoute(
        path: RouteNames.signup,
        pageBuilder: (_, state) => _fadePage(state, const SignupPage()),
      ),
      ShellRoute(
        observers: [modalRouteObserver, BreadcrumbRouteObserver()],
        pageBuilder: (context, state, child) => _fadePage(
          state,
          MultiBlocProvider(
            providers: [
              BlocProvider(
                create: (_) => HomeCubit(
                  petRepository: petRepository,
                  referentialRepository: referentialRepository,
                  eventRepository: eventRepository,
                  healthRepository: healthRepository,
                  authRepository: authRepository,
                ),
              ),
              BlocProvider(
                lazy: false,
                create: (_) => PetDetailsCubit(
                  petRepository: petRepository,
                  healthRepository: healthRepository,
                  referentialRepository: referentialRepository,
                ),
              ),
              BlocProvider(
                create: (_) => JournalCubit(
                  eventRepository: eventRepository,
                  petRepository: petRepository,
                  referentialRepository: referentialRepository,
                ),
              ),
            ],
            child: AppShell(
              isModalOpen: modalRouteObserver.isModalOpen,
              child: child,
            ),
          ),
        ),
        routes: [
          GoRoute(
            path: RouteNames.home,
            pageBuilder: (_, state) => _fadePage(state, const HomePage()),
            routes: [
              GoRoute(
                path: 'create-event',
                pageBuilder: (_, state) => _fadePage(
                  state,
                  BlocProvider(
                    create: (_) => EventCreationCubit(
                      eventRepository: eventRepository,
                      referentialRepository: referentialRepository,
                      petRepository: petRepository,
                    )..load(),
                    child: const CreateEventPage(),
                  ),
                ),
              ),
              GoRoute(
                path: 'edit-event/:eventId',
                pageBuilder: (_, state) => _fadePage(
                  state,
                  BlocProvider(
                    create: (_) => EditEventCubit(
                      eventRepository: eventRepository,
                      referentialRepository: referentialRepository,
                      petRepository: petRepository,
                    )..load(state.pathParameters['eventId']!),
                    child: const EditEventPage(),
                  ),
                ),
              ),
              GoRoute(
                path: 'journal',
                pageBuilder: (_, state) => _fadePage(state, const JournalPage()),
              ),
              GoRoute(
                path: 'pet',
                pageBuilder: (_, state) => _fadePage(state, const PetPage()),
                routes: [
                  GoRoute(
                    path: 'health-diary',
                    pageBuilder: (_, state) => _fadePage(state, const PetHealthDiaryPage()),
                  ),
                ],
              ),
              GoRoute(
                path: 'settings',
                pageBuilder: (_, state) => _fadePage(
                  state,
                  BlocProvider(
                    create: (_) => SettingsCubit(
                      authRepository: authRepository,
                      settingsRepository: settingsRepository,
                    )..load(),
                    child: const SettingsPage(),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: RouteNames.paywall,
        pageBuilder: (_, state) => _fadePage(
          state,
          BlocProvider(
            create: (_) => PaywallCubit(
              purchaseRepository: purchaseRepository,
              authRepository: authRepository,
            )..loadOffers(),
            child: const PaywallPage(),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => ErrorScreen(error: state.error),
  );
}

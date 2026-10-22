import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/notifications/reminder_planner.dart';
import 'package:nanimo/core/widgets/app_shell.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit(super.state);

  void load(SubscriptionState next) => emit(next);

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakePetDetailsCubit extends Cubit<PetDetailsState>
    implements PetDetailsCubit {
  _FakePetDetailsCubit() : super(const PetDetailsState());

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakePetCreationCubit extends Cubit<PetCreationState>
    implements PetCreationCubit {
  _FakePetCreationCubit() : super(const PetCreationState());

  void created({required bool duringOnboarding}) => emit(PetCreationState(
        status: PetCreationStatus.success,
        createdDuringOnboarding: duringOnboarding,
      ));

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakeOnboardingCubit extends Cubit<OnboardingState>
    implements OnboardingCubit {
  _FakeOnboardingCubit() : super(const OnboardingState());

  @override
  void noSuchMethod(Invocation invocation) {}
}

SubscriptionState _plan(String planName) =>
    SubscriptionState.loaded(SubscriptionConfigModel(
      configId: 'cfg',
      planName: planName,
      maxImagesPerEvent: planName == 'premium' ? 5 : 1,
      maxPets: planName == 'premium' ? 10 : 1,
    ));

/// The shell opens no paywall on signup, and routes the trial-end warning.
void main() {
  late _FakeSubscriptionCubit subscription;
  late _FakePetCreationCubit petCreation;

  Future<void> pumpShell(
    WidgetTester tester, {
    required SubscriptionState subscriptionState,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    subscription = _FakeSubscriptionCubit(subscriptionState);
    petCreation = _FakePetCreationCubit();
    final petDetails = _FakePetDetailsCubit();
    final onboarding = _FakeOnboardingCubit();
    addTearDown(subscription.close);
    addTearDown(petCreation.close);
    addTearDown(petDetails.close);
    addTearDown(onboarding.close);

    final router = GoRouter(
      initialLocation: RouteNames.home,
      routes: [
        ShellRoute(
          builder: (_, __, child) => AppShell(
            isModalOpen: ValueNotifier(false),
            child: child,
          ),
          routes: [
            GoRoute(
              path: RouteNames.home,
              builder: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
        GoRoute(
          path: RouteNames.paywall,
          builder: (_, __) => const Scaffold(body: Text('paywall-stub')),
        ),
        GoRoute(
          path: RouteNames.settings,
          builder: (_, __) => const Scaffold(body: Text('settings-stub')),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<SubscriptionCubit>.value(value: subscription),
          BlocProvider<PetDetailsCubit>.value(value: petDetails),
          BlocProvider<PetCreationCubit>.value(value: petCreation),
          BlocProvider<OnboardingCubit>.value(value: onboarding),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The trial is offered once the first steps are done, not on signup.
  testWidgets('opens no paywall when the onboarding pet lands',
      (tester) async {
    await pumpShell(tester, subscriptionState: _plan('freemium'));

    petCreation.created(duringOnboarding: true);
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsNothing);
  });

  testWidgets('a tap on the trial-end warning opens the settings',
      (tester) async {
    await pumpShell(tester, subscriptionState: _plan('premium'));

    pendingNotificationTap.value = 'trialEnd|${ReminderPlanner.trialPayloadId}';
    await tester.pumpAndSettle();

    expect(find.text('settings-stub'), findsOneWidget);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
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

/// NAN-093 lot 1: the paywall is placed at the end of the onboarding.
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

  testWidgets('opens once the onboarding pet has landed', (tester) async {
    await pumpShell(tester, subscriptionState: _plan('freemium'));

    petCreation.created(duringOnboarding: true);
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsOneWidget);
  });

  testWidgets('stays away from an in-app pet creation', (tester) async {
    await pumpShell(tester, subscriptionState: _plan('freemium'));

    petCreation.created(duringOnboarding: false);
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsNothing);
  });

  testWidgets('never opens for someone who already pays', (tester) async {
    await pumpShell(tester, subscriptionState: _plan('premium'));

    petCreation.created(duringOnboarding: true);
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsNothing);
  });

  /// The plan may land after the pet on a slow network.
  testWidgets('waits for the plan, then opens', (tester) async {
    await pumpShell(
      tester,
      subscriptionState: const SubscriptionState.unknown(),
    );

    petCreation.created(duringOnboarding: true);
    await tester.pumpAndSettle();
    expect(find.text('paywall-stub'), findsNothing);

    subscription.load(_plan('freemium'));
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsOneWidget);
  });

  testWidgets('a plan landing late on a premium account opens nothing',
      (tester) async {
    await pumpShell(
      tester,
      subscriptionState: const SubscriptionState.unknown(),
    );

    petCreation.created(duringOnboarding: true);
    await tester.pumpAndSettle();
    subscription.load(_plan('premium'));
    await tester.pumpAndSettle();

    expect(find.text('paywall-stub'), findsNothing);
  });
}

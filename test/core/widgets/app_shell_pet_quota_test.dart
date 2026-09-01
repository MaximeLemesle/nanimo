import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/widgets/app_shell.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit(super.state);

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakePetDetailsCubit extends Cubit<PetDetailsState>
    implements PetDetailsCubit {
  _FakePetDetailsCubit(List<PetModel> pets)
      : super(PetDetailsState(status: PetDetailsStatus.loaded, pets: pets));

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakePetCreationCubit extends Cubit<PetCreationState>
    implements PetCreationCubit {
  _FakePetCreationCubit() : super(const PetCreationState());

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakeOnboardingCubit extends Cubit<OnboardingState>
    implements OnboardingCubit {
  _FakeOnboardingCubit() : super(const OnboardingState());

  var resetCount = 0;

  @override
  void reset() => resetCount++;

  @override
  void noSuchMethod(Invocation invocation) {}
}

PetModel _pet(int index) => PetModel(
      petId: 'p$index',
      petName: 'Milo $index',
      birthdate: DateTime.utc(2022, 6, 15),
      gender: Gender.female,
      createdAt: DateTime.utc(2026, 6, 10),
      petRaceId: 'r-europeen',
      petSpeciesId: 's-chat',
    );

SubscriptionState _plan(String planName, int maxPets) =>
    SubscriptionState.loaded(SubscriptionConfigModel(
      configId: 'cfg',
      planName: planName,
      maxImagesPerEvent: 1,
      maxPets: maxPets,
    ));

void main() {
  late _FakeOnboardingCubit onboarding;

  /// Hosts AppShell on a router carrying the /paywall route, so the upsell can
  /// be followed all the way to the destination.
  Future<void> pumpShell(
    WidgetTester tester, {
    required SubscriptionState subscriptionState,
    required int petCount,
  }) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final subscription = _FakeSubscriptionCubit(subscriptionState);
    final petDetails = _FakePetDetailsCubit(
      [for (var i = 0; i < petCount; i++) _pet(i)],
    );
    final petCreation = _FakePetCreationCubit();
    onboarding = _FakeOnboardingCubit();
    addTearDown(subscription.close);
    addTearDown(petDetails.close);
    addTearDown(petCreation.close);
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
          path: RouteNames.createPet,
          builder: (_, __) => const Scaffold(body: Text('create-pet-stub')),
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

  Future<void> tapAddPet(WidgetTester tester) async {
    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter un animal'));
    await tester.pumpAndSettle();
  }

  testWidgets('under the quota the create-pet flow opens', (tester) async {
    await pumpShell(
      tester,
      subscriptionState: _plan('freemium', 1),
      petCount: 0,
    );

    await tapAddPet(tester);

    expect(onboarding.resetCount, 1);
    expect(find.text('create-pet-stub'), findsOneWidget);
  });

  /// NAN-059: the free quota is the paywall's door, with no snack bar in between.
  testWidgets('at the free quota the paywall opens straight away',
      (tester) async {
    await pumpShell(
      tester,
      subscriptionState: _plan('freemium', 1),
      petCount: 1,
    );

    await tapAddPet(tester);

    expect(find.text('paywall-stub'), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
    expect(find.text('create-pet-stub'), findsNothing);
    expect(onboarding.resetCount, 0);
  });

  testWidgets('at the premium quota the message uses it and no paywall opens',
      (tester) async {
    await pumpShell(
      tester,
      subscriptionState: _plan('premium', 10),
      petCount: 10,
    );

    await tapAddPet(tester);

    expect(find.textContaining('Limite de 10 animaux'), findsOneWidget);
    expect(find.text('paywall-stub'), findsNothing);
  });

  testWidgets('an unloaded plan keeps the degraded message', (tester) async {
    await pumpShell(
      tester,
      subscriptionState: const SubscriptionState.unknown(),
      petCount: 0,
    );

    await tapAddPet(tester);

    expect(
      find.textContaining('Impossible de vérifier votre abonnement'),
      findsOneWidget,
    );
    expect(find.text('paywall-stub'), findsNothing);
  });
}

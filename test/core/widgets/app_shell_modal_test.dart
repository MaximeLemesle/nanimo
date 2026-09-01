import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/core/widgets/bottom_bar_widget/bottom_bar_widget.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/settings/data/settings_repository.dart';
import 'package:nanimo/features/subscription/data/purchase_repository.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockEventRepository extends Mock implements EventRepository {}

class _MockAuthRepository extends Mock implements AuthRepository {}

class _MockSettingsRepository extends Mock implements SettingsRepository {}

class _MockPurchaseRepository extends Mock implements PurchaseRepository {}

/// The create menu reads the plan at build time to mark its premium row, so
/// the shell no longer boots without a SubscriptionCubit above it.
class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit() : super(const SubscriptionState.unknown());

  @override
  void noSuchMethod(Invocation invocation) {}
}

class _FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  _FakeAuthCubit() : super(const AuthState.authenticated());

  @override
  Future<void> login(String email, String password) async {}

  @override
  Future<void> register(String email, String password, String userName) async {}

  @override
  Future<void> loginWithGoogle() async {}

  @override
  Future<void> loginWithApple() async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> resync() async {}

  @override
  void clearError() {}
}

const _chat = PetSpeciesModel(
  petSpeciesId: 's-chat',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
);

const _europeen = PetRaceModel(
  petRaceId: 'r-europeen',
  raceName: 'Européen',
  petSpeciesId: 's-chat',
);

final _milo = PetModel(
  petId: 'p1',
  petName: 'Milo',
  birthdate: DateTime.utc(2022, 6, 15),
  gender: Gender.female,
  createdAt: DateTime.utc(2026, 6, 10),
  petRaceId: 'r-europeen',
  petSpeciesId: 's-chat',
);

void main() {
  late _FakeAuthCubit authCubit;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;
  late _MockHealthRepository healthRepo;
  late _MockEventRepository eventRepo;
  late _MockAuthRepository authRepo;
  late OnboardingCubit onboardingCubit;
  late PetCreationCubit petCreationCubit;
  late HomeCubit homeCubit;
  late PetDetailsCubit petDetailsCubit;
  late _FakeSubscriptionCubit subscriptionCubit;
  late GoRouter router;

  setUp(() {
    authCubit = _FakeAuthCubit();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    eventRepo = _MockEventRepository();
    authRepo = _MockAuthRepository();

    when(() => eventRepo.watchEvents()).thenAnswer((_) => Stream.value(const []));
    when(() => eventRepo.watchPetEvents()).thenAnswer((_) => Stream.value(const {}));
    when(() => eventRepo.watchAllImages()).thenAnswer((_) => Stream.value(const {}));
    when(() => healthRepo.watchAllDiaries()).thenAnswer((_) => Stream.value(const []));
    when(() => healthRepo.watchAllVaccines()).thenAnswer((_) => Stream.value(const []));
    when(() => authRepo.watchCurrentUser()).thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.watchDiaryForPet(any())).thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_milo]));
    when(() => petRepo.getPets()).thenAnswer((_) async => [_milo]);
    when(() => referentialRepo.fetchSpecies()).thenAnswer((_) async => [_chat]);
    when(() => referentialRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => [_europeen]);
    when(() => referentialRepo.fetchEventTypes())
        .thenAnswer((_) async => const <EventTypeModel>[]);
    when(() => referentialRepo.fetchRecommendedVaccinesBySpecies(any()))
        .thenAnswer((_) async => const []);
  });

  tearDown(() async {
    await subscriptionCubit.close();
    await petCreationCubit.close();
    await homeCubit.close();
    await petDetailsCubit.close();
    await onboardingCubit.close();
    await authCubit.close();
  });

  /// Boots the app on the real router, exactly like main.dart wires it, so the
  /// observer -> router -> AppShell wiring is what gets exercised.
  Future<void> pumpHome(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 2.0;
    addTearDown(tester.view.reset);

    onboardingCubit = OnboardingCubit(referentialRepository: referentialRepo);
    petCreationCubit = PetCreationCubit(
      authCubit: authCubit,
      petRepository: petRepo,
    );
    homeCubit = HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
      eventRepository: eventRepo,
      healthRepository: healthRepo,
      authRepository: authRepo,
    );
    petDetailsCubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: referentialRepo,
    );
    subscriptionCubit = _FakeSubscriptionCubit();
    router = createRouter(
      authCubit,
      authRepository: authRepo,
      eventRepository: eventRepo,
      referentialRepository: referentialRepo,
      petRepository: petRepo,
      healthRepository: healthRepo,
      settingsRepository: _MockSettingsRepository(),
      purchaseRepository: _MockPurchaseRepository(),
    );

    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          BlocProvider<PetCreationCubit>.value(value: petCreationCubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<PetDetailsCubit>.value(value: petDetailsCubit),
          BlocProvider<SubscriptionCubit>.value(value: subscriptionCubit),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );

    /// Clear the splash delay, then let the home streams settle.
    await tester.pump(const Duration(seconds: 2));
    await tester.pumpAndSettle();
  }

  double barOpacity(WidgetTester tester) {
    final opacity = tester.widget<AnimatedOpacity>(
      find.ancestor(
        of: find.byType(BottomBarWidget),
        matching: find.byType(AnimatedOpacity),
      ),
    );
    return opacity.opacity;
  }

  testWidgets('nav bar is visible on the home page', (tester) async {
    await pumpHome(tester);

    expect(find.byType(BottomBarWidget), findsOneWidget);
    expect(barOpacity(tester), 1);
  });

  testWidgets('nav bar hides while a bottom sheet is open, and comes back',
      (tester) async {
    await pumpHome(tester);
    expect(barOpacity(tester), 1);

    /// The weekly article card opens the sheet the ticket calls out.
    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();
    expect(barOpacity(tester), 0);

    Navigator.of(tester.element(find.text('Lire la suite'))).pop();
    await tester.pumpAndSettle();
    expect(barOpacity(tester), 1);
  });

  testWidgets('nav bar stops taking taps while a sheet is open',
      (tester) async {
    await pumpHome(tester);

    await tester.tap(find.text('Lire la suite'));
    await tester.pumpAndSettle();

    /// Matched by key: the Scaffold wraps the bar in IgnorePointers of its own,
    /// and some of those are already ignoring while a sheet is up.
    final ignorePointer = tester.widget<IgnorePointer>(
      find.byKey(const Key('bottom_bar_ignore_pointer')),
    );
    expect(ignorePointer.ignoring, isTrue);
  });
}

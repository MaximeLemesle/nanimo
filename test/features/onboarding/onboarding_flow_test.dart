import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/config/router/app_router.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _FakeAuthCubit extends Cubit<AuthState> implements AuthCubit {
  _FakeAuthCubit() : super(const AuthState.unknown());

  void sessionNotFound() => emit(const AuthState.unauthenticated());
  void sessionRestored() => emit(const AuthState.authenticated());

  @override
  Future<void> login(String email, String password) async {
    emit(const AuthState.authenticated());
  }

  @override
  Future<void> register(String email, String password) async {
    emit(const AuthState.authenticated());
  }

  @override
  Future<void> loginWithGoogle() async {
    emit(const AuthState.authenticated());
  }

  @override
  Future<void> loginWithApple() async {
    emit(const AuthState.authenticated());
  }

  @override
  Future<void> logout() async {
    emit(const AuthState.unauthenticated());
  }

  @override
  void clearError() {}
}

const _chat = PetSpeciesModel(
  petSpeciesId: 's-chat',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
);

const _chien = PetSpeciesModel(
  petSpeciesId: 's-chien',
  speciesName: 'Chien',
  weightUnit: WeightUnit.kg,
  iconKey: 'dog',
);

const _europeen = PetRaceModel(
  petRaceId: 'r-europeen',
  raceName: 'Européen',
  petSpeciesId: 's-chat',
);

const _berger = PetRaceModel(
  petRaceId: 'r-berger',
  raceName: 'Berger',
  petSpeciesId: 's-chien',
);

void main() {
  late _FakeAuthCubit authCubit;
  late _MockReferentialRepository referentialRepo;
  late _MockPetRepository petRepo;
  late _MockHealthRepository healthRepo;
  late StreamController<List<PetModel>> petsController;
  late OnboardingCubit onboardingCubit;
  late PetCreationCubit petCreationCubit;
  late HomeCubit homeCubit;
  late PetDetailsCubit petDetailsCubit;
  late GoRouter router;

  setUpAll(() {
    registerFallbackValue(
      PetModel(
        petId: 'fallback',
        petName: 'fallback',
        birthdate: DateTime.utc(2020),
        gender: Gender.unknown,
        createdAt: DateTime.utc(2020),
        petRaceId: 'r',
        petSpeciesId: 's',
      ),
    );
  });

  setUp(() {
    authCubit = _FakeAuthCubit();
    referentialRepo = _MockReferentialRepository();
    petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    petsController = StreamController<List<PetModel>>.broadcast();

    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(const <VetVisitModel>[]));

    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_chat, _chien]);
    when(() => referentialRepo.fetchRacesBySpecies(_chat.petSpeciesId))
        .thenAnswer((_) async => [_europeen]);
    when(() => referentialRepo.fetchRacesBySpecies(_chien.petSpeciesId))
        .thenAnswer((_) async => [_berger]);
    when(() => petRepo.watchPets()).thenAnswer((_) => petsController.stream);

    /// Mimics the write-through cache: a created pet lands in the pets stream.
    when(() => petRepo.createPet(any())).thenAnswer((invocation) async {
      final pet = invocation.positionalArguments.first as PetModel;
      petsController.add([pet]);
    });
  });

  tearDown(() async {
    await petCreationCubit.close();
    await homeCubit.close();
    await petDetailsCubit.close();
    await onboardingCubit.close();
    await authCubit.close();
    await petsController.close();
  });

  /// Boots the app on the real router, exactly like main.dart wires it.
  /// The viewport mimics a tall phone so every step fits on screen.
  /// Cubits are created here (not in setUp) so their stream subscriptions
  /// live in the fake-async zone of the test and get delivered on pumps.
  Future<void> pumpApp(WidgetTester tester) async {
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
    );
    petDetailsCubit = PetDetailsCubit(
      petRepository: petRepo,
      healthRepository: healthRepo,
      referentialRepository: referentialRepo,
    );
    router = createRouter(authCubit);
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider<AuthCubit>.value(value: authCubit),
          BlocProvider<OnboardingCubit>.value(value: onboardingCubit),
          BlocProvider<PetCreationCubit>.value(value: petCreationCubit),
          BlocProvider<HomeCubit>.value(value: homeCubit),
          BlocProvider<PetDetailsCubit>.value(value: petDetailsCubit),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
  }

  /// Cold start → welcome → 3 steps → lands on the signup page.
  Future<void> goThroughOnboarding(WidgetTester tester) async {
    await pumpApp(tester);
    expect(find.text('Splash Page'), findsOneWidget);

    authCubit.sessionNotFound();
    await tester.pumpAndSettle();
    expect(find.text('Commencer'), findsOneWidget);

    await tester.tap(find.text('Commencer'));
    await tester.pumpAndSettle();

    // Step 1: species grid loaded from the referential.
    expect(find.text('Faisons connaissance'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
    expect(find.text('Chien'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Milo');
    await tester.tap(find.text('Chat'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    // Step 2: gender + race (loaded for the selected species) + birthdate.
    expect(find.text('Quelques détails'), findsOneWidget);
    await tester.tap(find.text('Femelle'));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Européen').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Sélectionner une date'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(20, 20)); // close the date bottom sheet
    await tester.pumpAndSettle();
    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    // Step 3: success screen with the pet name.
    expect(find.text('Félicitations !'), findsOneWidget);
    expect(find.text('Milo'), findsOneWidget);

    await tester.tap(find.text('Créer mon compte'));
    await tester.pumpAndSettle();
    expect(find.text('Inscription'), findsOneWidget);
  }

  group('Onboarding flow', () {
    testWidgets(
        'cold start: splash → welcome → 3 steps → email signup → home shows Milo',
        (tester) async {
      await goThroughOnboarding(tester);

      await tester.enterText(find.byType(TextField).at(0), 'milo@nanimo.fr');
      await tester.enterText(find.byType(TextField).at(1), 'azerty1');
      await tester.enterText(find.byType(TextField).at(2), 'azerty1');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Créer mon compte'));
      await tester.pumpAndSettle();

      // The pending pet was inserted once, and home displays it.
      final created = verify(() => petRepo.createPet(captureAny())).captured;
      expect(created, hasLength(1));
      expect((created.single as PetModel).petName, 'Milo');
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Milo'), findsOneWidget);
    });

    testWidgets(
        'failed post-signup insert shows a retry banner that re-inserts the pet',
        (tester) async {
      // The first insert fails (e.g. the users_pets FK race after signup),
      // the retry succeeds.
      var attempts = 0;
      when(() => petRepo.createPet(any())).thenAnswer((invocation) async {
        attempts++;
        if (attempts == 1) {
          // The real insert resolves over the network after Home has mounted;
          // the delay reproduces that ordering so the error reaches the banner.
          await Future<void>.delayed(const Duration(milliseconds: 50));
          throw const RepositoryNetworkException('Création impossible.');
        }
        final pet = invocation.positionalArguments.first as PetModel;
        petsController.add([pet]);
      });

      await goThroughOnboarding(tester);

      await tester.enterText(find.byType(TextField).at(0), 'milo@nanimo.fr');
      await tester.enterText(find.byType(TextField).at(1), 'azerty1');
      await tester.enterText(find.byType(TextField).at(2), 'azerty1');
      await tester.pumpAndSettle();
      await tester.tap(find.text('Créer mon compte'));
      await tester.pump();
      // Mimic the post-signup sync landing an empty pet cache so Home renders
      // (otherwise it stays on its loading spinner forever).
      petsController.add(const []);
      await tester.pumpAndSettle();

      // Landed on Home without the pet, but the failure is surfaced + retryable.
      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Milo'), findsNothing);
      expect(find.text('Réessayer'), findsOneWidget);

      await tester.tap(find.text('Réessayer'));
      await tester.pumpAndSettle();

      expect(attempts, 2);
      expect(find.text('Milo'), findsOneWidget);
    });

    testWidgets('SSO Google signup inserts the pending pet and shows home',
        (tester) async {
      await goThroughOnboarding(tester);

      await tester.tap(find.text('Continuer avec Google'));
      await tester.pumpAndSettle();

      final created = verify(() => petRepo.createPet(captureAny())).captured;
      expect(created, hasLength(1));
      expect((created.single as PetModel).petName, 'Milo');
      expect(find.text('Milo'), findsOneWidget);
    });

    testWidgets('backtrack: changing species on step 1 resets the race',
        (tester) async {
      await pumpApp(tester);
      authCubit.sessionNotFound();
      await tester.pumpAndSettle();
      await tester.tap(find.text('Commencer'));
      await tester.pumpAndSettle();

      // Step 1 → step 2 with Chat + Européen selected.
      await tester.enterText(find.byType(TextField), 'Milo');
      await tester.tap(find.text('Chat'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(DropdownButtonFormField<String>));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Européen').last);
      await tester.pumpAndSettle();
      expect(onboardingCubit.state.petRaceId, _europeen.petRaceId);

      // Back to step 1, switch the species to Chien.
      await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Chien'));
      await tester.pumpAndSettle();

      // The race is reset and the new species' races are loaded.
      expect(onboardingCubit.state.petRaceId, isNull);
      expect(onboardingCubit.state.races, [_berger]);
      await tester.tap(find.text('Continuer'));
      await tester.pumpAndSettle();
      expect(find.text('Choisis une race'), findsOneWidget);
      expect(find.text('Européen'), findsNothing);
    });

    testWidgets('existing user logs in via /login without touching onboarding',
        (tester) async {
      await pumpApp(tester);
      authCubit.sessionNotFound();
      await tester.pumpAndSettle();

      router.go(RouteNames.login);
      await tester.pumpAndSettle();
      expect(find.text('Se connecter'), findsWidgets);

      await tester.enterText(find.byType(TextField).at(0), 'max@nanimo.fr');
      await tester.enterText(find.byType(TextField).at(1), 'azerty1');
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(ButtonWidget, 'Se connecter'));
      await tester.pump();

      // The sync fills the cache with the user's existing pets.
      petsController.add([
        PetModel(
          petId: 'p-existing',
          petName: 'Saïko',
          birthdate: DateTime.utc(2021, 3, 2),
          gender: Gender.male,
          createdAt: DateTime.utc(2026, 1, 1),
          petRaceId: _europeen.petRaceId,
          petSpeciesId: _chat.petSpeciesId,
        ),
      ]);
      await tester.pumpAndSettle();

      // Home is shown with the synced pets, onboarding stayed pristine.
      expect(find.text('Saïko'), findsOneWidget);
      verifyNever(() => petRepo.createPet(any()));
      expect(onboardingCubit.state, const OnboardingState());
    });

    testWidgets('warm start: restored session goes from splash straight to home',
        (tester) async {
      await pumpApp(tester);
      expect(find.text('Splash Page'), findsOneWidget);

      authCubit.sessionRestored();
      petsController.add(const []);
      await tester.pumpAndSettle();

      expect(find.text('Accueil'), findsOneWidget);
      expect(find.text('Commencer'), findsNothing);
      verifyNever(() => petRepo.createPet(any()));
    });
  });
}

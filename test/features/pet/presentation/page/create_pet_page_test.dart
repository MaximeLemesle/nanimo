import 'package:flutter_confetti/flutter_confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_creation_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/create_pet_page.dart';
import 'package:nanimo/features/pet/presentation/widgets/create_pet_step_three_widget.dart';

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

const _species = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
);

const _races = [
  PetRaceModel(petRaceId: 'r1', raceName: 'Bengal', petSpeciesId: 's1'),
];

void main() {
  late _MockReferentialRepository referentialRepo;

  setUp(() {
    referentialRepo = _MockReferentialRepository();
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_species]);
    when(() => referentialRepo.fetchRacesBySpecies(any()))
        .thenAnswer((_) async => _races);
  });

  /// Builds a cubit with a complete pet draft, positioned on step 2.
  Future<OnboardingCubit> seededCubitOnStepTwo() async {
    final cubit = OnboardingCubit(referentialRepository: referentialRepo);
    cubit.setPetName('Milo');
    await cubit.selectSpecies('s1');
    cubit.setRace('r1');
    cubit.setGender(Gender.female);
    cubit.setBirthdate(DateTime.utc(2022, 6, 15));
    cubit.nextStep();
    return cubit;
  }

  Widget buildPage(OnboardingCubit cubit) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OnboardingCubit>.value(value: cubit),
        BlocProvider<PetCreationCubit>(
          create: (_) => throw UnimplementedError('not needed in this test'),
        ),
      ],
      child: const MaterialApp(home: CreatePetPage()),
    );
  }

  testWidgets('Continuer on step 2 shows step 3 instead of leaving the flow',
      (tester) async {
    final cubit = await seededCubitOnStepTwo();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    expect(cubit.state.currentStep, 2);
    expect(find.text('Continuer'), findsOneWidget);

    await tester.tap(find.text('Continuer'));
    await tester.pumpAndSettle();

    expect(cubit.state.currentStep, 3);
    expect(find.byType(CreatePetStepThreeWidget), findsOneWidget);
    expect(find.text('Félicitations !'), findsOneWidget);
    expect(find.text('Créer mon compte'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('confetti animation starts when step 3 appears', (tester) async {
    final cubit = await seededCubitOnStepTwo();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Continuer'));
    // Pump through the 280ms page transition frame by frame.
    await tester.pump();
    for (var i = 0; i < 25; i++) {
      await tester.pump(const Duration(milliseconds: 16));
    }

    // Two bursts are inserted in the app overlay when step 3 appears.
    expect(find.byType(Confetti), findsNWidgets(2));

    // Drain the animation: once finished, the overlay entries remove
    // themselves and no tickers leak.
    await tester.pumpAndSettle();
    expect(find.byType(Confetti), findsNothing);
    await cubit.close();
  });
}

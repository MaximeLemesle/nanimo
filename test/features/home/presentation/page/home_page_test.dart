import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/home/presentation/cubit/home_cubit.dart';
import 'package:nanimo/features/home/presentation/page/home_page.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

final _milo = PetModel(
  petId: 'p1',
  petName: 'Milo',
  birthdate: DateTime.utc(2022, 6, 15),
  gender: Gender.female,
  createdAt: DateTime.utc(2026, 6, 10),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _cat = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat',
);

void main() {
  late _MockPetRepository petRepo;
  late _MockReferentialRepository referentialRepo;
  late StreamController<List<PetModel>> petsController;

  setUp(() {
    petRepo = _MockPetRepository();
    referentialRepo = _MockReferentialRepository();
    petsController = StreamController<List<PetModel>>();
    when(() => petRepo.watchPets()).thenAnswer((_) => petsController.stream);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_cat]);
  });

  tearDown(() => petsController.close());

  Widget buildPage(HomeCubit cubit) {
    return MaterialApp(
      home: Scaffold(
        body: BlocProvider.value(value: cubit, child: const HomePage()),
      ),
    );
  }

  testWidgets('shows a loader until the pets stream emits', (tester) async {
    final cubit = HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
    );
    await tester.pumpWidget(buildPage(cubit));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await cubit.close();
  });

  testWidgets('shows an empty message when the user has no pet',
      (tester) async {
    final cubit = HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
    );
    await tester.pumpWidget(buildPage(cubit));

    petsController.add(const []);
    await tester.pumpAndSettle();

    expect(find.text('Aucun animal pour le moment'), findsOneWidget);
    await cubit.close();
  });

  testWidgets('shows a card with the created pet name and avatar',
      (tester) async {
    final cubit = HomeCubit(
      petRepository: petRepo,
      referentialRepository: referentialRepo,
    );
    await tester.pumpWidget(buildPage(cubit));

    petsController.add([_milo]);
    await tester.pumpAndSettle();

    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Né le 15/06/2022'), findsOneWidget);
    final image = tester.widget<Image>(find.byType(Image));
    expect(
      (image.image as AssetImage).assetName,
      'assets/icons/species/cat.png',
    );
    await cubit.close();
  });
}

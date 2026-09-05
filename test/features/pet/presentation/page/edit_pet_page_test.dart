import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/edit_pet_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/edit_pet_page.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

class _MockEventRepository extends Mock implements EventRepository {}

const _catSpecies = PetSpeciesModel(
  petSpeciesId: 'sp-cat',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _europeen = PetRaceModel(
  petRaceId: 'race-europeen',
  raceName: 'Européen',
  petSpeciesId: 'sp-cat',
);

const _siamois = PetRaceModel(
  petRaceId: 'race-siamois',
  raceName: 'Siamois',
  petSpeciesId: 'sp-cat',
);

const _europeenIcon = PetIconModel(
  petIconId: 'icon-europeen',
  petIconName: 'Européen',
  assetPath: 'assets/icons/species/cat-europeen.png',
  isPremium: false,
  petSpeciesId: 'sp-cat',
  petRaceId: 'race-europeen',
);

PetModel buildMilo() => PetModel(
      petId: 'pet-milo',
      petName: 'Milo',
      birthdate: DateTime.utc(2022, 5, 1),
      gender: Gender.male,
      createdAt: DateTime.utc(2022, 5, 1),
      petRaceId: 'race-europeen',
      petSpeciesId: 'sp-cat',
      petIconId: 'icon-europeen',
    );

void main() {
  late _MockPetRepository petRepo;
  late _MockReferentialRepository referentialRepo;
  late _MockEventRepository eventRepo;

  setUpAll(() {
    registerFallbackValue(buildMilo());
  });

  setUp(() {
    petRepo = _MockPetRepository();
    referentialRepo = _MockReferentialRepository();
    eventRepo = _MockEventRepository();

    when(() => petRepo.getPetById('pet-milo'))
        .thenAnswer((_) async => buildMilo());
    when(() => petRepo.updatePet(any())).thenAnswer((_) async {});
    when(() => petRepo.deletePet(any())).thenAnswer((_) async {});
    when(() => eventRepo.countEventsForPet('pet-milo'))
        .thenAnswer((_) async => 0);
    when(() => eventRepo.purgeLocalEventsForPet(any())).thenAnswer((_) async {});
    when(() => referentialRepo.fetchRacesBySpecies('sp-cat'))
        .thenAnswer((_) async => [_europeen, _siamois]);
    when(() => referentialRepo.fetchSpecies())
        .thenAnswer((_) async => [_catSpecies]);
    when(() => referentialRepo.fetchIcons())
        .thenAnswer((_) async => [_europeenIcon]);
  });

  EditPetCubit buildCubit() => EditPetCubit(
        petRepository: petRepo,
        referentialRepository: referentialRepo,
        eventRepository: eventRepo,
      );

  /// Hosts the page behind a GoRouter so the success listener's `context.pop()`
  /// has a route to fall back to.
  Future<EditPetCubit> pumpPage(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(1080, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = buildCubit()..load('pet-milo');
    addTearDown(cubit.close);

    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          builder: (_, __) => const Scaffold(body: SizedBox.shrink()),
        ),
        GoRoute(
          path: '/edit',
          builder: (_, __) => BlocProvider<EditPetCubit>.value(
            value: cubit,
            child: const EditPetPage(),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    router.push('/edit');
    await tester.pumpAndSettle();
    return cubit;
  }

  testWidgets('shows a loader until the pet is loaded', (tester) async {
    when(() => petRepo.getPetById('pet-milo')).thenAnswer((_) async {
      await Future<void>.delayed(const Duration(milliseconds: 50));
      return buildMilo();
    });

    final cubit = buildCubit()..load('pet-milo');
    addTearDown(cubit.close);

    await tester.pumpWidget(MaterialApp(
      home: BlocProvider<EditPetCubit>.value(
        value: cubit,
        child: const EditPetPage(),
      ),
    ));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    await tester.pumpAndSettle();
    expect(find.byType(CircularProgressIndicator), findsNothing);
  });

  testWidgets('prefills the form with the pet values', (tester) async {
    await pumpPage(tester);

    expect(find.text('Milo'), findsOneWidget);
    expect(find.text('Européen'), findsWidgets);
    expect(find.text('01/05/2022'), findsOneWidget);
    expect(find.text('Chat'), findsOneWidget);
  });

  testWidgets('submits the edited name', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField).first, 'Miloute');
    await tester.pump();
    await tester.tap(find.widgetWithText(ButtonWidget, 'Enregistrer'));
    await tester.pumpAndSettle();

    final saved =
        verify(() => petRepo.updatePet(captureAny())).captured.single
            as PetModel;
    expect(saved.petName, 'Miloute');
  });

  testWidgets('disables saving when the name is too short', (tester) async {
    await pumpPage(tester);

    await tester.enterText(find.byType(TextField).first, 'M');
    await tester.pump();
    await tester.tap(find.widgetWithText(ButtonWidget, 'Enregistrer'));
    await tester.pumpAndSettle();

    verifyNever(() => petRepo.updatePet(any()));
  });

  testWidgets('warns about the souvenirs before deleting', (tester) async {
    when(() => eventRepo.countEventsForPet('pet-milo'))
        .thenAnswer((_) async => 3);
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ButtonWidget, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(find.text('Supprimer Milo ?'), findsOneWidget);
    expect(
      find.textContaining('Tu as 3 souvenirs avec Milo'),
      findsOneWidget,
    );
  });

  testWidgets('uses the singular for a lone souvenir', (tester) async {
    when(() => eventRepo.countEventsForPet('pet-milo'))
        .thenAnswer((_) async => 1);
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ButtonWidget, 'Supprimer'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Tu as 1 souvenir avec Milo'), findsOneWidget);
  });

  testWidgets('cancelling the dialog leaves the pet alone', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ButtonWidget, 'Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
    await tester.pumpAndSettle();

    verifyNever(() => petRepo.deletePet(any()));
  });

  testWidgets('confirming the dialog deletes the pet', (tester) async {
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ButtonWidget, 'Supprimer'));
    await tester.pumpAndSettle();
    await tester.tap(find.widgetWithText(TextButton, 'Supprimer'));
    await tester.pumpAndSettle();

    verify(() => petRepo.deletePet('pet-milo')).called(1);
  });

  testWidgets('shows the error in a snack bar', (tester) async {
    when(() => petRepo.updatePet(any())).thenThrow(Exception('boom'));
    await pumpPage(tester);

    await tester.tap(find.widgetWithText(ButtonWidget, 'Enregistrer'));
    await tester.pumpAndSettle();

    expect(find.byType(SnackBar), findsOneWidget);
  });
}

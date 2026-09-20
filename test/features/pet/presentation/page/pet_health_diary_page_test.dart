import 'package:flutter/material.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_profile/pet_bottom_sheet/add_weight_bottom_sheet_widget.dart';
import 'package:nanimo/features/pet/presentation/widgets/pet_health_diary/pet_diary_card/pet_summary_diary_card_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/pet_health_diary_page.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

final _pet = PetModel(
  petId: 'p1',
  petName: 'Yummy',
  birthdate: DateTime(2024, 1, 1),
  gender: Gender.male,
  createdAt: DateTime(2024, 1, 1),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

const _species = PetSpeciesModel(
  petSpeciesId: 's1',
  speciesName: 'Chat',
  weightUnit: WeightUnit.kg,
  iconKey: 'cat-europeen',
);

const _races = [
  PetRaceModel(petRaceId: 'r1', raceName: 'Européen', petSpeciesId: 's1'),
];

final _diary = HealthDiaryModel(
  healthDiaryId: 'd1',
  petId: 'p1',
  isSterilized: true,
  isChipped: true,
  chipNumber: '250 26 85 12345678',
);

final _vaccines = [
  HealthDiaryVaccineModel(
    healthDiaryVaccineId: 'v1',
    vaccineName: 'Typhus félin',
    lastDate: DateTime(2025, 5, 13),
    nextDate: DateTime.now().add(const Duration(days: 20)),
    recurrence: 365,
    doseNumber: 1,
    totalDoseNumber: 1,
    healthDiaryId: 'd1',
  ),
];

final _vetVisits = [
  VetVisitModel(
    vetVisitId: 'vv1',
    title: 'Bilan annuel',
    visitedAt: DateTime(2026, 1, 14),
    vetName: 'Dr.Martin',
    clinicName: 'Clinique des Pins',
    petId: 'p1',
  ),
];

final _weightLogs = [
  HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: 'w1',
    weight: 1.2,
    loggedAt: DateTime(2026, 1, 1),
    petId: 'p1',
  ),
  HealthDiaryWeightLogModel(
    healthDiaryWeightLogId: 'w2',
    weight: 3.2,
    loggedAt: DateTime(2026, 6, 1),
    petId: 'p1',
  ),
];

class _FakeSubscriptionCubit extends Cubit<SubscriptionState>
    implements SubscriptionCubit {
  _FakeSubscriptionCubit()
      : super(SubscriptionState.loaded(const SubscriptionConfigModel(
          configId: 'cfg',
          planName: 'premium',
          maxImagesPerEvent: 5,
          maxPets: 10,
        )));

  @override
  void noSuchMethod(Invocation invocation) {}
}

void main() {
  late _MockPetRepository petRepo;
  late _MockHealthRepository healthRepo;
  late _MockReferentialRepository refRepo;

  setUpAll(() {
    registerFallbackValue(HealthDiaryModel(healthDiaryId: 'f', petId: 'p'));
    registerFallbackValue(
      HealthDiaryVaccineModel(
        healthDiaryVaccineId: 'f',
        vaccineName: 'x',
        lastDate: DateTime(2026, 1, 1),
        nextDate: DateTime(2026, 1, 2),
        recurrence: 0,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: 'd',
      ),
    );
    registerFallbackValue(
      VetVisitModel(
        vetVisitId: 'f',
        title: 'x',
        visitedAt: DateTime(2026, 1, 1),
        petId: 'p',
      ),
    );
    registerFallbackValue(
      HealthDiaryWeightLogModel(
        healthDiaryWeightLogId: 'f',
        weight: 1,
        loggedAt: DateTime(2026, 1, 1),
        petId: 'p',
      ),
    );
  });

  setUp(() {
    petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    refRepo = _MockReferentialRepository();

    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_pet]));
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    when(() => healthRepo.addVetVisit(any())).thenAnswer((_) async {});
    when(() => healthRepo.updateVetVisit(any())).thenAnswer((_) async {});
    when(() => healthRepo.updateVaccine(any())).thenAnswer((_) async {});
    when(() => healthRepo.deleteVaccine(any())).thenAnswer((_) async {});
    when(() => healthRepo.deleteVetVisit(any())).thenAnswer((_) async {});
    when(() => healthRepo.addWeightLog(any())).thenAnswer((_) async {});
    when(() => healthRepo.updateWeightLog(any())).thenAnswer((_) async {});
    when(() => healthRepo.deleteWeightLog(any())).thenAnswer((_) async {});
    when(() => healthRepo.watchDiaryForPet(any())).thenAnswer((_) => Stream.value(_diary));
    when(() => healthRepo.getVaccinesForDiary(any())).thenAnswer((_) => Stream.value(_vaccines));
    when(() => healthRepo.getWeightLogsForPet(any())).thenAnswer((_) => Stream.value(_weightLogs));
    when(() => healthRepo.getVetVisitsForPet(any())).thenAnswer((_) => Stream.value(_vetVisits));
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => [_species]);
    when(() => refRepo.fetchRacesBySpecies(any())).thenAnswer((_) async => _races);
  });

  Widget buildPage(PetDetailsCubit cubit) {
    return MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<PetDetailsCubit>.value(value: cubit),
          BlocProvider<SubscriptionCubit>.value(
            value: _FakeSubscriptionCubit(),
          ),
        ],
        child: const PetHealthDiaryPage(),
      ),
    );
  }

  PetDetailsCubit createCubit() => PetDetailsCubit(
        petRepository: petRepo,
        healthRepository: healthRepo,
        referentialRepository: refRepo,
      );

  testWidgets('renders every carnet de santé section', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    expect(find.text('Récapitulatif'), findsOneWidget);
    expect(find.text('Nom'), findsOneWidget);
    expect(find.text('Yummy'), findsWidgets);
    expect(find.text('Vaccins'), findsOneWidget);
    expect(find.text('Visites vétérinaires'), findsOneWidget);
    expect(find.text('Évolution du poids'), findsOneWidget);
    expect(find.text('Typhus félin'), findsOneWidget);
    expect(find.text('Bilan annuel'), findsOneWidget);
    expect(find.text('Européen'), findsOneWidget);
    // expect(find.text('Exporter en PDF'), findsOneWidget);

    await cubit.close();
  });

  /// NAN-090 review: the visits come before the vaccines.
  testWidgets('puts the vet visits above the vaccines', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    final visits = tester.getTopLeft(find.text('Visites vétérinaires')).dy;
    final vaccines = tester.getTopLeft(find.text('Vaccins')).dy;
    expect(visits, lessThan(vaccines));

    await cubit.close();
  });

  testWidgets('opens the add vaccine modal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter un vaccin'));
    await tester.pumpAndSettle();

    expect(find.text('Nom du vaccin'), findsOneWidget);

    await cubit.close();
  });

  testWidgets('adds a vet visit through the modal', (tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2000));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    final cubit = createCubit();
    await tester.pumpWidget(buildPage(cubit));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Ajouter une visite'));
    await tester.pumpAndSettle();

    await tester.enterText(find.widgetWithText(TextField, 'Motif de la visite'), 'Rappel vaccin');
    await tester.tap(find.text('Sélectionner une date'));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(400, 50));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Enregistrer'));
    await tester.pumpAndSettle();

    verify(() => healthRepo.addVetVisit(any())).called(1);

    await cubit.close();
  });

  /// NAN-085. The pencil arms the section, a second tap picks the entry.
  group('editing an entry', () {
    testWidgets('puts one pencil beside each section title', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Modifier un vaccin'), findsOneWidget);
      expect(find.byTooltip('Modifier une visite'), findsOneWidget);

      await cubit.close();
    });

    /// Nothing to pick, so the control would arm an empty list.
    testWidgets('hides the pencil while the section is empty', (tester) async {
      when(() => healthRepo.getVaccinesForDiary(any())).thenAnswer((_) => Stream.value([]));

      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      expect(find.byTooltip('Modifier un vaccin'), findsNothing);
      expect(find.byTooltip('Modifier une visite'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('arming the section says what to do and offers a way out', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Modifier un vaccin'));
      await tester.pumpAndSettle();

      expect(find.text('Choisis le vaccin à modifier'), findsOneWidget);
      expect(find.byTooltip('Annuler la modification'), findsOneWidget);

      /// The other section must not be armed by the same gesture.
      expect(find.text('Choisis la visite à modifier'), findsNothing);

      await tester.tap(find.byTooltip('Annuler la modification'));
      await tester.pumpAndSettle();

      expect(find.text('Choisis le vaccin à modifier'), findsNothing);

      await cubit.close();
    });

    testWidgets('picking a vaccine opens it pre-filled', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Modifier un vaccin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Typhus félin'));
      await tester.pumpAndSettle();

      expect(find.text('Modifier le vaccin'), findsWidgets);

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(() => healthRepo.updateVaccine(any())).called(1);
      verifyNever(() => healthRepo.addVaccine(any()));

      await cubit.close();
    });

    testWidgets('picking a vet visit opens it pre-filled', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Modifier une visite'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Bilan annuel'));
      await tester.pumpAndSettle();

      expect(find.text('Modifier la visite'), findsWidgets);
      expect(find.text('Dr.Martin'), findsWidgets);
      expect(find.text('Clinique des Pins'), findsWidgets);

      /// Saving an untouched form must update, never create a duplicate.
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      verify(() => healthRepo.updateVetVisit(any())).called(1);
      verifyNever(() => healthRepo.addVetVisit(any()));

      await cubit.close();
    });

    /// The mode is one-shot: it must not stay armed after a pick.
    testWidgets('leaves selection mode once an entry is picked', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Modifier un vaccin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Typhus félin'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      expect(find.text('Choisis le vaccin à modifier'), findsNothing);
      expect(find.byTooltip('Modifier un vaccin'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('a row is inert until the section is armed', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Typhus félin'));
      await tester.pumpAndSettle();

      expect(find.text('Enregistrer'), findsNothing);

      await cubit.close();
    });
  });

  // NAN-080: NAN-085 shipped the edit only, and not for the weight logs.
  group('deleting an entry', () {
    Future<PetDetailsCubit> openEditor(
      WidgetTester tester, {
      required String tooltip,
      required String row,
    }) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(tooltip));
      await tester.pumpAndSettle();
      await tester.tap(find.text(row));
      await tester.pumpAndSettle();
      return cubit;
    }

    Finder confirmButton() => find.descendant(
          of: find.byType(AlertDialog),
          matching: find.widgetWithText(TextButton, 'Supprimer'),
        );

    testWidgets('the create form offers no deletion', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Ajouter un vaccin'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer'), findsNothing);

      await cubit.close();
    });

    testWidgets('a vaccine is deleted once confirmed', (tester) async {
      final cubit = await openEditor(tester, tooltip: 'Modifier un vaccin', row: 'Typhus félin');

      await tester.tap(find.text('Supprimer le vaccin'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer ce vaccin ?'), findsOneWidget);
      await tester.tap(confirmButton());
      await tester.pumpAndSettle();

      verify(() => healthRepo.deleteVaccine('v1')).called(1);
      verifyNever(() => healthRepo.updateVaccine(any()));

      await cubit.close();
    });

    testWidgets('cancelling the confirmation deletes nothing', (tester) async {
      final cubit = await openEditor(tester, tooltip: 'Modifier un vaccin', row: 'Typhus félin');

      await tester.tap(find.text('Supprimer le vaccin'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(TextButton, 'Annuler'));
      await tester.pumpAndSettle();

      verifyNever(() => healthRepo.deleteVaccine(any()));

      /// The sheet is still there, so nothing typed has been lost either.
      expect(find.text('Modifier le vaccin'), findsWidgets);

      await cubit.close();
    });

    testWidgets('a vet visit is deleted once confirmed', (tester) async {
      final cubit = await openEditor(tester, tooltip: 'Modifier une visite', row: 'Bilan annuel');

      await tester.tap(find.text('Supprimer la visite'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer cette visite ?'), findsOneWidget);
      await tester.tap(confirmButton());
      await tester.pumpAndSettle();

      verify(() => healthRepo.deleteVetVisit('vv1')).called(1);

      await cubit.close();
    });
  });

  group('editing a weight log', () {
    Future<PetDetailsCubit> pumpDiary(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();
      return cubit;
    }

    testWidgets('the weight section carries a pencil like the others', (tester) async {
      final cubit = await pumpDiary(tester);

      expect(find.byTooltip('Modifier une pesée'), findsOneWidget);

      await cubit.close();
    });

    testWidgets('arming the section lists the logs, most recent first', (tester) async {
      final cubit = await pumpDiary(tester);

      expect(find.text('Poids naissance'), findsOneWidget);

      await tester.tap(find.byTooltip('Modifier une pesée'));
      await tester.pumpAndSettle();

      expect(find.text('Choisis la pesée à modifier'), findsOneWidget);
      expect(find.text('Poids naissance'), findsNothing);

      final recent = tester.getRect(find.text('3,2 kg le 01/06/2026'));
      final older = tester.getRect(find.text('1,2 kg le 01/01/2026'));
      expect(recent.top, lessThan(older.top));

      await cubit.close();
    });

    testWidgets('picking a log opens it pre-filled and updates on save', (tester) async {
      final cubit = await pumpDiary(tester);

      await tester.tap(find.byTooltip('Modifier une pesée'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3,2 kg le 01/06/2026'));
      await tester.pumpAndSettle();

      expect(find.text('Modifier la pesée'), findsWidgets);
      expect(find.widgetWithText(TextField, '3,2'), findsOneWidget);

      await tester.tap(find.text('Enregistrer'));
      await tester.pumpAndSettle();

      final captured = verify(() => healthRepo.updateWeightLog(captureAny())).captured.single as HealthDiaryWeightLogModel;
      expect(captured.healthDiaryWeightLogId, 'w2');
      expect(captured.weight, 3.2);
      verifyNever(() => healthRepo.addWeightLog(any()));

      await cubit.close();
    });

    testWidgets('a log is deleted once confirmed', (tester) async {
      final cubit = await pumpDiary(tester);

      await tester.tap(find.byTooltip('Modifier une pesée'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('3,2 kg le 01/06/2026'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Supprimer la pesée'));
      await tester.pumpAndSettle();

      expect(find.text('Supprimer cette pesée ?'), findsOneWidget);
      await tester.tap(find.descendant(
        of: find.byType(AlertDialog),
        matching: find.widgetWithText(TextButton, 'Supprimer'),
      ));
      await tester.pumpAndSettle();

      verify(() => healthRepo.deleteWeightLog('w2')).called(1);

      await cubit.close();
    });
  });

  // NAN-089: the summary showed the age without the date that produces it.
  group('the summary', () {
    Future<PetDetailsCubit> pumpDiary(WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      await tester.pumpWidget(buildPage(cubit));
      await tester.pumpAndSettle();
      return cubit;
    }

    testWidgets('shows the birthdate just above the age', (tester) async {
      final cubit = await pumpDiary(tester);

      expect(find.text('Date de naissance'), findsOneWidget);
      expect(find.text('01/01/2024'), findsOneWidget);

      final birthdate = tester.getRect(find.text('Date de naissance'));
      final age = tester.getRect(find.text('Âge'));
      expect(birthdate.top, lessThan(age.top));

      await cubit.close();
    });

    testWidgets('carries a pencil like the other sections', (tester) async {
      final cubit = await pumpDiary(tester);

      expect(find.byTooltip('Modifier les informations'), findsOneWidget);

      await cubit.close();
    });

    /// NAN-089: the pencil no longer arms a selection, it goes straight to the
    /// edit page, which now owns every field the summary shows.
    testWidgets('the pencil routes to the pet edit page', (tester) async {
      await tester.binding.setSurfaceSize(const Size(800, 2000));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final cubit = createCubit();
      addTearDown(cubit.close);

      String? pushedPath;
      final router = GoRouter(
        initialLocation: '/home/pet/diary',
        routes: [
          GoRoute(
            path: '/home/pet/diary',

            /// NAN-082 made the page read the plan, so the provider has to be
            /// here too, not only in `buildPage`.
            builder: (_, __) => MultiBlocProvider(
              providers: [
                BlocProvider<PetDetailsCubit>.value(value: cubit),
                BlocProvider<SubscriptionCubit>.value(
                  value: _FakeSubscriptionCubit(),
                ),
              ],
              child: const PetHealthDiaryPage(),
            ),
          ),
          GoRoute(
            path: '/pet/edit/:petId',
            builder: (_, state) {
              pushedPath = state.uri.path;
              return const Scaffold(body: SizedBox.shrink());
            },
          ),
        ],
      );
      addTearDown(router.dispose);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip('Modifier les informations'));
      await tester.pumpAndSettle();

      expect(pushedPath, '/pet/edit/p1');
    });

    /// Every row is now read-only: no chevron, and a tap opens nothing.
    testWidgets('leaves every row inert', (tester) async {
      final cubit = await pumpDiary(tester);

      expect(
        find.descendant(
          of: find.byType(PetSummaryDiaryCardWidget),
          matching: find.byIcon(Icons.chevron_right_rounded),
        ),
        findsNothing,
      );

      await tester.tap(find.text('Numéro de puce'));
      await tester.pumpAndSettle();
      expect(find.text('Modifier les informations de santé'), findsNothing);

      await tester.tap(find.text('Poids'));
      await tester.pumpAndSettle();
      expect(find.byType(AddWeightBottomSheetWidget), findsNothing);

      await cubit.close();
    });
  });
}

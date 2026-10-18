import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/health_diary_wizard_page.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockReferentialRepository extends Mock implements ReferentialRepository {}

final _dobby = PetModel(
  petId: 'p1',
  petName: 'Dobby',
  birthdate: DateTime(2024, 3, 2),
  gender: Gender.male,
  createdAt: DateTime(2024, 3, 2),
  petRaceId: 'r1',
  petSpeciesId: 's1',
);

void main() {
  late _MockHealthRepository healthRepo;
  late PetDetailsCubit cubit;

  setUpAll(() {
    registerFallbackValue(const HealthDiaryModel(healthDiaryId: 'f', petId: 'f'));
    registerFallbackValue(HealthDiaryWeightLogModel(healthDiaryWeightLogId: 'f', weight: 1, loggedAt: DateTime(2026), petId: 'f'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    diaryFollowUpStore = DiaryFollowUpStore();
    final petRepo = _MockPetRepository();
    healthRepo = _MockHealthRepository();
    final refRepo = _MockReferentialRepository();
    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_dobby]));
    when(() => healthRepo.watchDiaryForPet(any())).thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getVaccinesForDiary(any())).thenAnswer((_) => Stream.value(const <HealthDiaryVaccineModel>[]));
    when(() => healthRepo.getWeightLogsForPet(any())).thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));
    when(() => healthRepo.getVetVisitsForPet(any())).thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    when(() => healthRepo.addWeightLog(any())).thenAnswer((_) async {});
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => []);
    when(() => refRepo.fetchIcons()).thenAnswer((_) async => []);
    when(() => refRepo.fetchRecommendedVaccinesBySpecies(any())).thenAnswer((_) async => []);
    cubit = PetDetailsCubit(petRepository: petRepo, healthRepository: healthRepo, referentialRepository: refRepo);
  });

  tearDown(() => cubit.close());

  Future<bool?> pumpWizard(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1000, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    bool? result;
    final router = GoRouter(
      initialLocation: '/home',
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, _) => Scaffold(
            body: TextButton(
              onPressed: () async => result = await context.push<bool>('/pet/carnet/p1'),
              child: const Text('open'),
            ),
          ),
        ),
        GoRoute(
          path: '/pet/carnet/:petId',
          builder: (_, state) => BlocProvider.value(
            value: cubit,
            child: HealthDiaryWizardPage(petId: state.pathParameters['petId']!),
          ),
        ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return result;
  }

  Future<void> tapAndSettle(WidgetTester tester, Finder finder) async {
    await tester.tap(finder);
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 25));
    }
  }

  testWidgets('asks one question per screen, then saves the diary on « Valider le carnet »', (tester) async {
    await pumpWizard(tester);

    expect(find.text('Poids de Dobby à sa naissance'), findsOneWidget);
    expect(find.text('Le 02/03/2024, pesé :'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '0,4');
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Est-ce que Dobby est castré ?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Oui').first);
    expect(find.text('Date de la castration'), findsOneWidget);
    await tapAndSettle(tester, find.text('Non').last);
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Ses vaccins et ses vermifuges'), findsOneWidget);
    expect(find.text('Me le rappeler plus tard'), findsOneWidget);
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Ses visites chez le vétérinaire'), findsOneWidget);
    verifyNever(() => healthRepo.upsertDiary(any()));
    await tapAndSettle(tester, find.text('Valider le carnet'));

    final diary = verify(() => healthRepo.upsertDiary(captureAny())).captured.single as HealthDiaryModel;
    expect(diary.isSterilized, isTrue);
    expect(diary.isChipped, isFalse);
    final weight = verify(() => healthRepo.addWeightLog(captureAny())).captured.single as HealthDiaryWeightLogModel;
    expect(weight.weight, 0.4);
    expect(weight.loggedAt, _dobby.birthdate);
    expect(find.text('Le carnet de Dobby est créé !'), findsOneWidget);
  });

  testWidgets('« Me le rappeler plus tard » keeps the follow-up and moves on', (tester) async {
    await pumpWizard(tester);
    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Continuer'));

    await tapAndSettle(tester, find.text('Me le rappeler plus tard'));
    await tapAndSettle(tester, find.text('Programmer le rappel'));

    final followUps = await diaryFollowUpStore.all();
    expect(followUps.single.topic, DiaryFollowUpTopic.vaccines);
    expect(followUps.single.petId, 'p1');
    expect(followUps.single.at.hour, 18);
    expect(find.text('Ses visites chez le vétérinaire'), findsOneWidget);
  });
}

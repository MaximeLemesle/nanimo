import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:nanimo/core/notifications/diary_follow_up_store.dart';
import 'package:nanimo/core/notifications/notification_priming.dart';
import 'package:nanimo/core/notifications/notifications.dart';
import 'package:nanimo/core/utils/date_formatter.dart';
import '../../../../core/notifications/fake_notification_client.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/pet_details_cubit.dart';
import 'package:nanimo/core/widgets/button_widget.dart';
import 'package:nanimo/features/pet/presentation/page/health_diary_wizard_page.dart';

class _MockPetRepository extends Mock implements PetRepository {}

class _MockHealthRepository extends Mock implements HealthRepository {}

class _MockReferentialRepository extends Mock
    implements ReferentialRepository {}

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
  late FakeNotificationClient client;
  late NotificationPriming previousPriming;
  late _MockPetRepository petRepo;

  setUpAll(() {
    registerFallbackValue(_dobby);
    registerFallbackValue(
        const HealthDiaryModel(healthDiaryId: 'f', petId: 'f'));
    registerFallbackValue(HealthDiaryWeightLogModel(
        healthDiaryWeightLogId: 'f',
        weight: 1,
        loggedAt: DateTime(2026),
        petId: 'f'));
  });

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    diaryFollowUpStore = DiaryFollowUpStore();
    previousPriming = notificationPriming;
    client = FakeNotificationClient();
    notificationPriming =
        NotificationPriming(client: () => client, store: MemoryPrimingStore());
    petRepo = _MockPetRepository();
    when(() => petRepo.updatePet(any())).thenAnswer((_) async {});
    healthRepo = _MockHealthRepository();
    final refRepo = _MockReferentialRepository();
    when(() => petRepo.watchPets()).thenAnswer((_) => Stream.value([_dobby]));
    when(() => healthRepo.watchDiaryForPet(any()))
        .thenAnswer((_) => Stream.value(null));
    when(() => healthRepo.getVaccinesForDiary(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryVaccineModel>[]));
    when(() => healthRepo.getWeightLogsForPet(any()))
        .thenAnswer((_) => Stream.value(const <HealthDiaryWeightLogModel>[]));
    when(() => healthRepo.getVetVisitsForPet(any()))
        .thenAnswer((_) => Stream.value(const <VetVisitModel>[]));
    when(() => healthRepo.upsertDiary(any())).thenAnswer((_) async {});
    when(() => healthRepo.addWeightLog(any())).thenAnswer((_) async {});
    when(() => refRepo.fetchSpecies()).thenAnswer((_) async => []);
    when(() => refRepo.fetchIcons()).thenAnswer((_) async => []);
    when(() => refRepo.fetchRecommendedVaccinesBySpecies(any()))
        .thenAnswer((_) async => []);
    cubit = PetDetailsCubit(
        petRepository: petRepo,
        healthRepository: healthRepo,
        referentialRepository: refRepo);
  });

  tearDown(() async {
    notificationPriming = previousPriming;
    await cubit.close();
  });

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
              onPressed: () async =>
                  result = await context.push<bool>('/pet/carnet/p1'),
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

  /// The first two screens need their answers before « Continuer ».
  Future<void> answerFirstSteps(WidgetTester tester) async {
    await tester.enterText(find.byType(TextField), '4,2');
    await tester.pump();
    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Non').first);
    await tapAndSettle(tester, find.text('Non').last);
    await tapAndSettle(tester, find.text('Continuer'));
  }

  ButtonState continueState(WidgetTester tester) => tester
      .widget<ButtonWidget>(find.widgetWithText(ButtonWidget, 'Continuer'))
      .state;

  testWidgets('« Continuer » waits for today\'s weight, then both answers',
      (tester) async {
    await pumpWizard(tester);
    expect(continueState(tester), ButtonState.disabled);
    await tester.enterText(find.byType(TextField), '4,2');
    await tester.pump();
    expect(continueState(tester), ButtonState.normal);
    await tapAndSettle(tester, find.text('Continuer'));

    expect(continueState(tester), ButtonState.disabled);
    await tapAndSettle(tester, find.text('Oui').first);
    await tapAndSettle(tester, find.text('Oui').last);
    expect(continueState(tester), ButtonState.disabled,
        reason: 'no castration date nor chip number yet');

    await tapAndSettle(tester, find.text('Date de la castration'));
    expect(continueState(tester), ButtonState.disabled,
        reason: 'the chip number is still missing');

    await tester.enterText(
        find.byType(TextField).last, '25026');
    await tester.pump();
    expect(continueState(tester), ButtonState.disabled,
        reason: 'an incomplete chip number');
    await tester.enterText(
        find.byType(TextField).last, '250269801234567');
    await tester.pump();
    expect(continueState(tester), ButtonState.normal);
  });

  /// NAN-124: today's weight first, older weighings only if the owner has them.
  testWidgets('saves today\'s weight and the previous weighings added',
      (tester) async {
    await pumpWizard(tester);
    final now = DateTime.now();
    expect(find.text('Poids de Dobby'), findsOneWidget);
    expect(find.text('Le ${DateFormatter.calendarDay(now)}'), findsOneWidget);
    await tester.enterText(find.byType(TextField), '4,2');

    await tapAndSettle(tester, find.text('Ajouter une pesée précédente'));
    await tapAndSettle(tester, find.text('Date de la pesée'));
    tester
        .widget<CupertinoDatePicker>(find.byType(CupertinoDatePicker))
        .onDateTimeChanged(DateTime(2025, 6, 1));
    await tester.enterText(find.byType(TextField).at(1), '3,8');
    await tapAndSettle(tester, find.text('Ajouter une pesée précédente'));
    await tester.pump();
    expect(find.byType(TextField), findsNWidgets(3));

    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Non').first);
    await tapAndSettle(tester, find.text('Non').last);
    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Valider le carnet'));

    final logs = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .cast<HealthDiaryWeightLogModel>();
    expect(logs.map((log) => log.weight), unorderedEquals([4.2, 3.8]),
        reason: 'the empty weighing is left out');
    expect(logs.firstWhere((log) => log.weight == 3.8).loggedAt,
        DateTime(2025, 6, 1));
    expect(
        DateUtils.isSameDay(
            logs.firstWhere((log) => log.weight == 4.2).loggedAt, now),
        isTrue);
    expect(find.text('4,2 kg aujourd\'hui'), findsOneWidget);
    expect(find.text('1 pesée précédente'), findsOneWidget);
  });

  testWidgets('a previous weighing can be removed before saving',
      (tester) async {
    await pumpWizard(tester);
    await tapAndSettle(tester, find.text('Ajouter une pesée précédente'));
    expect(find.text('Date de la pesée'), findsOneWidget);
    await tapAndSettle(tester, find.byTooltip('Retirer'));
    expect(find.text('Date de la pesée'), findsNothing);
  });

  testWidgets('« Je ne sais pas » skips the weights', (tester) async {
    await pumpWizard(tester);
    await tapAndSettle(tester, find.text('Je ne sais pas'));
    expect(find.text('Est-ce que Dobby est castré ?'), findsOneWidget);
  });

  testWidgets('« Terminer » brings the user back to the home', (tester) async {
    await pumpWizard(tester);
    await answerFirstSteps(tester);
    await tapAndSettle(tester, find.text('Continuer'));
    await tapAndSettle(tester, find.text('Valider le carnet'));
    expect(find.text('Le carnet de Dobby est créé !'), findsOneWidget);
    expect(find.text('4,2 kg aujourd\'hui'), findsOneWidget);

    await tapAndSettle(tester, find.text('Terminer'));
    expect(find.text('open'), findsOneWidget);
  });

  testWidgets(
      'asks one question per screen, then saves the diary on « Valider le carnet »',
      (tester) async {
    await pumpWizard(tester);

    expect(find.text('Poids de Dobby'), findsOneWidget);
    expect(find.text('Date de la pesée'), findsNothing,
        reason: 'NAN-124: older weighings wait behind their button');
    await tester.enterText(find.byType(TextField), '4,2');
    await tester.pump();
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Est-ce que Dobby est castré ?'), findsOneWidget);
    await tapAndSettle(tester, find.text('Oui').first);
    expect(find.text('Date de la castration'), findsOneWidget);
    await tapAndSettle(tester, find.text('Date de la castration'));
    await tapAndSettle(tester, find.text('Non').last);
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Ses vaccins et ses vermifuges'), findsOneWidget);
    expect(find.text('Me le rappeler plus tard'), findsOneWidget);
    await tapAndSettle(tester, find.text('Continuer'));

    expect(find.text('Ses visites chez le vétérinaire'), findsOneWidget);
    verifyNever(() => healthRepo.upsertDiary(any()));
    await tapAndSettle(tester, find.text('Valider le carnet'));

    final diary = verify(() => healthRepo.upsertDiary(captureAny()))
        .captured
        .single as HealthDiaryModel;
    expect(diary.isSterilized, isTrue);
    expect(diary.isChipped, isFalse);
    final weight = verify(() => healthRepo.addWeightLog(captureAny()))
        .captured
        .single as HealthDiaryWeightLogModel;
    expect(weight.weight, 4.2);
    expect(DateUtils.isSameDay(weight.loggedAt, DateTime.now()), isTrue);
    expect(find.text('Le carnet de Dobby est créé !'), findsOneWidget);
  });

  testWidgets('refusing notifications never promises a follow-up',
      (tester) async {
    await pumpWizard(tester);
    await answerFirstSteps(tester);
    await tapAndSettle(tester, find.text('Me le rappeler plus tard'));
    await tapAndSettle(tester, find.text('Programmer le rappel'));
    await tapAndSettle(tester, find.text('Plus tard'));
    expect(client.requestCount, 0);
    expect(await diaryFollowUpStore.all(), isEmpty);
    expect(find.text('Ses vaccins et ses vermifuges'), findsOneWidget);
  });

  testWidgets('an OS refusal keeps the draft and does not schedule a reminder',
      (tester) async {
    client.grantOnRequest = false;
    await pumpWizard(tester);
    await answerFirstSteps(tester);
    await tapAndSettle(tester, find.text('Me le rappeler plus tard'));
    await tapAndSettle(tester, find.text('Programmer le rappel'));
    await tapAndSettle(tester, find.text('Activer les notifications').last);
    expect(client.requestCount, 1);
    expect(await diaryFollowUpStore.all(), isEmpty);
    expect(find.text('Ses vaccins et ses vermifuges'), findsOneWidget);
  });

  testWidgets('previously refused notifications lead to the phone settings',
      (tester) async {
    final store = MemoryPrimingStore()..shown = true;
    notificationPriming =
        NotificationPriming(client: () => client, store: store);
    await pumpWizard(tester);
    await answerFirstSteps(tester);
    await tapAndSettle(tester, find.text('Me le rappeler plus tard'));
    await tapAndSettle(tester, find.text('Programmer le rappel'));
    await tapAndSettle(tester, find.text('Ouvrir les réglages'));
    expect(client.requestCount, 0);
    expect(client.openSettingsCount, 1);
    expect(await diaryFollowUpStore.all(), isEmpty);
  });

  testWidgets('« Me le rappeler plus tard » keeps the follow-up and moves on',
      (tester) async {
    await pumpWizard(tester);
    await answerFirstSteps(tester);

    await tapAndSettle(tester, find.text('Me le rappeler plus tard'));
    await tapAndSettle(tester, find.text('Programmer le rappel'));

    expect(find.text('Activer les notifications'), findsNWidgets(2));
    expect(client.requestCount, 0);
    expect(await diaryFollowUpStore.all(), isEmpty);
    await tapAndSettle(tester, find.text('Activer les notifications').last);
    expect(client.requestCount, 1);
    final followUps = await diaryFollowUpStore.all();
    expect(followUps.single.topic, DiaryFollowUpTopic.vaccines);
    expect(followUps.single.petId, 'p1');
    expect(followUps.single.at.hour, 18);
    expect(find.text('Ses visites chez le vétérinaire'), findsOneWidget);
  });
}

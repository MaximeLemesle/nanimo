import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/health/data/vet_document_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/vet_visit_cubit.dart';
import 'package:nanimo/features/pet/presentation/page/vet_document_viewer_page.dart';
import 'package:nanimo/features/pet/presentation/page/vet_visit_page.dart';
import 'package:nanimo/features/pet/presentation/widgets/vet_visit/vet_document_picker.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

class _MockHealth extends Mock implements HealthRepository {}

class _MockDocuments extends Mock implements VetDocumentRepository {}

class _MockPets extends Mock implements PetRepository {}

class _FakePicker extends VetDocumentPicker {
  VetDocumentSource? asked;

  @override
  Future<PickedVetDocument?> pick(VetDocumentSource source) async {
    asked = source;
    return (file: File('ordo.pdf'), fileName: 'ordo.pdf');
  }
}

class _FakeSubscriptionCubit extends Cubit<SubscriptionState> implements SubscriptionCubit {
  _FakeSubscriptionCubit(int maxPets)
      : super(SubscriptionState.loaded(SubscriptionConfigModel(
          configId: 'cfg',
          planName: maxPets > 1 ? 'premium' : 'freemium',
          maxImagesPerEvent: 1,
          maxPets: maxPets,
        )));

  @override
  void noSuchMethod(Invocation invocation) {}
}

PetModel _pet(String id, DateTime createdAt) => PetModel(
      petId: id,
      petName: id == 'p1' ? 'Saïko' : 'Rex',
      birthdate: DateTime(2020),
      gender: Gender.male,
      createdAt: createdAt,
      petRaceId: 'r',
      petSpeciesId: 's',
    );

const _document = VetDocumentModel(
  documentId: 'd1',
  eventId: 'v1',
  storagePath: 'v1/d1.pdf',
  fileName: 'ordo.pdf',
  mimeType: 'application/pdf',
  sizeBytes: 4,
  type: VetDocumentType.ordonnance,
  source: VetDocumentSource.file,
);

void main() {
  late _MockHealth health;
  late _MockDocuments documents;
  late _MockPets pets;

  setUpAll(() {
    registerFallbackValue(File(''));
    registerFallbackValue(VetDocumentSource.file);
    registerFallbackValue(VetDocumentType.autre);
  });

  setUp(() {
    health = _MockHealth();
    documents = _MockDocuments();
    pets = _MockPets();
  });

  Future<void> pump(
    WidgetTester tester,
    VetVisitModel visit, {
    List<VetDocumentModel> docs = const [],
    List<PetModel>? petList,
    int maxPets = 10,
    VetDocumentPicker picker = const VetDocumentPicker(),
  }) async {
    tester.view.physicalSize = const Size(1170, 2532);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    when(() => health.watchVetVisit(visit.vetVisitId)).thenAnswer((_) => Stream.value(visit));
    when(() => pets.watchPets()).thenAnswer((_) => Stream.value(petList ?? [_pet('p1', DateTime(2024))]));
    when(() => documents.fetchForVisit(visit.vetVisitId)).thenAnswer((_) async => docs);
    final cubit = VetVisitCubit(healthRepository: health, documentRepository: documents, petRepository: pets)
      ..load(visit.vetVisitId);
    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SubscriptionCubit>.value(value: _FakeSubscriptionCubit(maxPets)),
          BlocProvider.value(value: cubit),
        ],
        child: VetVisitPage(picker: picker),
      ),
    ));
    await tester.pumpAndSettle();
  }

  testWidgets('shows the visit, its time, its reason, its report and its documents', (tester) async {
    await pump(
      tester,
      VetVisitModel(
        vetVisitId: 'v1',
        title: 'Contrôle annuel',
        visitedAt: DateTime(2026, 10, 20, 14, 30),
        hasTime: true,
        petId: 'p1',
        clinicName: 'Clinique des Pins',
        reason: 'Toux depuis 3 jours',
        report: 'RAS, sirop 5 jours',
        documentCount: 1,
      ),
      docs: const [_document],
    );

    expect(find.text('Contrôle annuel'), findsOneWidget);
    expect(find.text('Le 20/10/2026 à 14h30'), findsOneWidget);
    expect(find.text('Saïko'), findsOneWidget);
    expect(find.text('Clinique des Pins'), findsOneWidget);
    expect(find.text('Toux depuis 3 jours'), findsOneWidget);
    expect(find.text('RAS, sirop 5 jours'), findsOneWidget);
    expect(find.text('Ordonnance'), findsOneWidget);
    expect(find.text('1/10'), findsOneWidget);
    expect(find.byTooltip('Modifier la visite'), findsOneWidget);
  });

  testWidgets('a past visit without report invites to write it', (tester) async {
    await pump(tester, VetVisitModel(vetVisitId: 'v1', title: 'Vaccin', visitedAt: DateTime(2026, 1, 3), petId: 'p1'));

    expect(find.text('Écrire le compte-rendu'), findsOneWidget);
    expect(find.text('Ajouter un document'), findsOneWidget);
  });

  testWidgets('adding a document goes through the type, then the picker', (tester) async {
    final picker = _FakePicker();
    when(() => documents.upload(
          eventId: any(named: 'eventId'),
          file: any(named: 'file'),
          fileName: any(named: 'fileName'),
          source: any(named: 'source'),
          type: any(named: 'type'),
          currentCount: any(named: 'currentCount'),
        )).thenAnswer((_) async => _document);
    await pump(tester, VetVisitModel(vetVisitId: 'v1', title: 'Vaccin', visitedAt: DateTime(2026, 1, 3), petId: 'p1'),
        picker: picker);

    await tester.ensureVisible(find.text('Ajouter un document'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ajouter un document'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ordonnance'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Importer un fichier (PDF)'));
    await tester.pumpAndSettle();

    expect(picker.asked, VetDocumentSource.file);
    verify(() => documents.upload(
          eventId: 'v1',
          file: any(named: 'file'),
          fileName: 'ordo.pdf',
          source: VetDocumentSource.file,
          type: VetDocumentType.ordonnance,
          currentCount: 0,
        )).called(1);
    expect(find.text('1/10'), findsOneWidget);
  });

  testWidgets('a locked animal is read only, documents stay listed', (tester) async {
    await pump(
      tester,
      VetVisitModel(vetVisitId: 'v1', title: 'Vaccin', visitedAt: DateTime(2026, 1, 3), petId: 'p2', documentCount: 1),
      docs: const [_document],
      petList: [_pet('p1', DateTime(2024)), _pet('p2', DateTime(2025))],
      maxPets: 1,
    );

    expect(find.byTooltip('Modifier la visite'), findsNothing);
    expect(find.text('Ajouter un document'), findsNothing);
    expect(find.text('Écrire le compte-rendu'), findsNothing);
    expect(find.text('Ordonnance'), findsOneWidget);
  });

  testWidgets('documents that cannot load offer to retry', (tester) async {
    when(() => health.watchVetVisit('v1')).thenAnswer((_) => Stream.value(
          VetVisitModel(vetVisitId: 'v1', title: 'Vaccin', visitedAt: DateTime(2026, 1, 3), petId: 'p1'),
        ));
    when(() => pets.watchPets()).thenAnswer((_) => Stream.value([_pet('p1', DateTime(2024))]));
    var calls = 0;
    when(() => documents.fetchForVisit('v1')).thenAnswer((_) async {
      calls++;
      throw Exception('offline');
    });
    final cubit = VetVisitCubit(healthRepository: health, documentRepository: documents, petRepository: pets)..load('v1');
    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SubscriptionCubit>.value(value: _FakeSubscriptionCubit(10)),
          BlocProvider.value(value: cubit),
        ],
        child: const VetVisitPage(),
      ),
    ));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Réessayer'));
    await tester.pumpAndSettle();

    expect(calls, 2);
  });

  testWidgets('an unknown visit says so', (tester) async {
    when(() => health.watchVetVisit('gone')).thenAnswer((_) => Stream<VetVisitModel?>.value(null));
    when(() => pets.watchPets()).thenAnswer((_) => const Stream.empty());
    when(() => documents.fetchForVisit('gone')).thenAnswer((_) async => const []);
    final cubit = VetVisitCubit(healthRepository: health, documentRepository: documents, petRepository: pets)
      ..load('gone');
    await tester.pumpWidget(MaterialApp(
      home: MultiBlocProvider(
        providers: [
          BlocProvider<SubscriptionCubit>.value(value: _FakeSubscriptionCubit(10)),
          BlocProvider.value(value: cubit),
        ],
        child: const VetVisitPage(),
      ),
    ));
    await tester.pumpAndSettle();

    expect(find.text('Cette visite n’existe plus.'), findsOneWidget);
  });

  group('VetDocumentViewerPage', () {
    testWidgets('a document that cannot be fetched says so, and can still be shared', (tester) async {
      var shared = false;
      await tester.pumpWidget(MaterialApp(
        home: VetDocumentViewerPage(
          document: _document,
          urlResolver: (_) async => null,
          fileResolver: (_) async => null,
          onShare: () => shared = true,
        ),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Ordonnance'), findsOneWidget);
      expect(find.textContaining('n’a pas pu être ouvert'), findsOneWidget);
      await tester.tap(find.byTooltip('Partager'));
      expect(shared, isTrue);
    });

    testWidgets('open pushes it above the current page', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => VetDocumentViewerPage.open(
              context,
              document: const VetDocumentModel(
                documentId: 'd2',
                eventId: 'v1',
                storagePath: 'v1/d2.jpg',
                fileName: 'photo.jpg',
                mimeType: 'image/jpeg',
                sizeBytes: 4,
                source: VetDocumentSource.camera,
              ),
              urlResolver: (_) async => null,
              fileResolver: (_) async => null,
              onShare: () {},
            ),
            child: const Text('open'),
          ),
        ),
      ));
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      expect(find.text('photo.jpg'), findsOneWidget);
    });
  });
}

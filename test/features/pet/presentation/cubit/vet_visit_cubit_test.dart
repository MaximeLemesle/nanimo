import 'dart:async';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/analytics/analytics_service.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/health/data/vet_document_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:nanimo/features/pet/presentation/cubit/vet_visit_cubit.dart';

import '../../../../core/analytics/recording_analytics_service.dart';

class _MockHealth extends Mock implements HealthRepository {}

class _MockDocuments extends Mock implements VetDocumentRepository {}

class _MockPets extends Mock implements PetRepository {}

final _visit = VetVisitModel(
  vetVisitId: 'v1',
  title: 'Contrôle',
  visitedAt: DateTime(2026, 10, 20),
  petId: 'p1',
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
  late StreamController<VetVisitModel?> visits;
  late RecordingAnalyticsService recorder;

  setUpAll(() {
    registerFallbackValue(_visit);
    registerFallbackValue(_document);
    registerFallbackValue(File(''));
    registerFallbackValue(VetDocumentSource.file);
    registerFallbackValue(VetDocumentType.autre);
  });

  setUp(() {
    health = _MockHealth();
    documents = _MockDocuments();
    pets = _MockPets();
    visits = StreamController<VetVisitModel?>.broadcast();
    recorder = RecordingAnalyticsService();
    analytics = recorder;
    when(() => health.watchVetVisit('v1')).thenAnswer((_) => visits.stream);
    when(() => pets.watchPets()).thenAnswer((_) => Stream.value([
          PetModel(
            petId: 'p1',
            petName: 'Saïko',
            birthdate: DateTime(2020),
            gender: Gender.male,
            createdAt: DateTime(2024),
            petRaceId: 'r',
            petSpeciesId: 's',
          ),
        ]));
    when(() => documents.fetchForVisit('v1')).thenAnswer((_) async => const [_document]);
  });

  tearDown(() {
    analytics = const NoopAnalyticsService();
    visits.close();
  });

  VetVisitCubit build({bool fromNotification = false}) => VetVisitCubit(
        healthRepository: health,
        documentRepository: documents,
        petRepository: pets,
        fromNotification: fromNotification,
      );

  Future<VetVisitCubit> loaded({bool fromNotification = false}) async {
    final cubit = build(fromNotification: fromNotification);
    final load = cubit.load('v1');
    visits.add(_visit);
    await load;
    await Future<void>.delayed(Duration.zero);
    return cubit;
  }

  test('load follows the visit, its animal and its documents', () async {
    final cubit = await loaded();

    expect(cubit.state.status, VetVisitStatus.loaded);
    expect(cubit.state.visit!.vetVisitId, 'v1');
    expect(cubit.state.pet!.petName, 'Saïko');
    expect(cubit.state.documents.single.documentId, 'd1');
    expect(cubit.state.documentsStatus, VetDocumentsStatus.loaded);
    await cubit.close();
  });

  test('a visit that disappears is reported as not found', () async {
    final cubit = await loaded();

    visits.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, VetVisitStatus.notFound);
    await cubit.close();
  });

  test('documents that cannot load leave the visit readable', () async {
    when(() => documents.fetchForVisit('v1')).thenThrow(const RepositoryNetworkException('offline'));

    final cubit = await loaded();

    expect(cubit.state.status, VetVisitStatus.loaded);
    expect(cubit.state.documentsStatus, VetDocumentsStatus.error);
    await cubit.close();
  });

  test('the first document completes the visit, credited to the notification', () async {
    when(() => documents.fetchForVisit('v1')).thenAnswer((_) async => const []);
    when(() => documents.upload(
          eventId: any(named: 'eventId'),
          file: any(named: 'file'),
          fileName: any(named: 'fileName'),
          source: any(named: 'source'),
          type: any(named: 'type'),
          currentCount: any(named: 'currentCount'),
        )).thenAnswer((_) async => _document);
    final cubit = await loaded(fromNotification: true);

    await cubit.addDocument(
      file: File('x'),
      fileName: 'ordo.pdf',
      source: VetDocumentSource.file,
      type: VetDocumentType.ordonnance,
    );

    expect(cubit.state.documents.single.documentId, 'd1');
    expect(cubit.state.isUploading, isFalse);
    expect(recorder.lastOf(AnalyticsEvents.vetDocumentAdded)!.properties, {
      AnalyticsProperties.docType: 'ordonnance',
      AnalyticsProperties.source: 'file',
      AnalyticsProperties.mimeType: 'application/pdf',
    });
    expect(recorder.lastOf(AnalyticsEvents.vetVisitCompleted)!.properties, {
      AnalyticsProperties.fromNotification: true,
    });
    await cubit.close();
  });

  test('a refused document surfaces its message and stops uploading', () async {
    when(() => documents.upload(
          eventId: any(named: 'eventId'),
          file: any(named: 'file'),
          fileName: any(named: 'fileName'),
          source: any(named: 'source'),
          type: any(named: 'type'),
          currentCount: any(named: 'currentCount'),
        )).thenThrow(const VetDocumentRejected('Ce fichier dépasse 10 Mo.'));
    final cubit = await loaded();

    await cubit.addDocument(file: File('x'), fileName: 'big.pdf', source: VetDocumentSource.file);

    expect(cubit.state.error, 'Ce fichier dépasse 10 Mo.');
    expect(cubit.state.isUploading, isFalse);
    cubit.clearError();
    expect(cubit.state.error, isNull);
    await cubit.close();
  });

  test('deleteDocument drops it from the list', () async {
    when(() => documents.delete(any())).thenAnswer((_) async {});
    final cubit = await loaded();

    await cubit.deleteDocument(_document);

    expect(cubit.state.documents, isEmpty);
    await cubit.close();
  });

  test('a written report completes the visit once, a later edit does not', () async {
    when(() => health.updateVetVisit(any())).thenAnswer((_) async {});
    final cubit = await loaded();

    await cubit.updateVisit(_visit.copyWith(report: () => 'RAS'));
    visits.add(_visit.copyWith(report: () => 'RAS'));
    await Future<void>.delayed(Duration.zero);
    await cubit.updateVisit(_visit.copyWith(report: () => 'RAS, revoir dans 6 mois'));

    expect(recorder.names.where((name) => name == AnalyticsEvents.vetVisitCompleted), hasLength(1));
    expect(recorder.lastOf(AnalyticsEvents.vetVisitCompleted)!.properties[AnalyticsProperties.fromNotification], isFalse);
    await cubit.close();
  });

  test('deleteVisit ends on deleted', () async {
    when(() => health.deleteVetVisit('v1')).thenAnswer((_) async {});
    final cubit = await loaded();

    expect(await cubit.deleteVisit(), isTrue);
    visits.add(null);
    await Future<void>.delayed(Duration.zero);

    expect(cubit.state.status, VetVisitStatus.deleted);
    await cubit.close();
  });

  test('a delete refused keeps the visit and says why', () async {
    when(() => health.deleteVetVisit('v1')).thenThrow(const RepositoryNetworkException('Connexion requise'));
    final cubit = await loaded();

    expect(await cubit.deleteVisit(), isFalse);
    expect(cubit.state.status, VetVisitStatus.loaded);
    expect(cubit.state.error, 'Connexion requise');
    await cubit.close();
  });

  test('sharing hands back the downloaded file and is tracked', () async {
    final file = File('shared.pdf');
    when(() => documents.downloadToTemp(_document)).thenAnswer((_) async => file);
    final cubit = await loaded();

    expect(await cubit.fileToShare(_document), file);
    expect(recorder.lastOf(AnalyticsEvents.vetDocumentShared)!.properties[AnalyticsProperties.docType], 'ordonnance');
    await cubit.close();
  });

  test('a failed download or url is reported, not thrown', () async {
    when(() => documents.downloadToTemp(_document)).thenThrow(const RepositoryNetworkException('offline'));
    when(() => documents.signedUrl(_document)).thenThrow(const RepositoryNetworkException('offline'));
    final cubit = await loaded();

    expect(await cubit.fileToShare(_document), isNull);
    expect(await cubit.documentFile(_document), isNull);
    expect(await cubit.documentUrl(_document), isNull);
    expect(cubit.state.error, 'offline');
    await cubit.close();
  });

  test('the add button closes at ten documents', () {
    final full = VetVisitState(documents: List.filled(10, _document));

    expect(full.canAddDocument, isFalse);
    expect(const VetVisitState(isUploading: true).canAddDocument, isFalse);
    expect(const VetVisitState().canAddDocument, isTrue);
  });
}

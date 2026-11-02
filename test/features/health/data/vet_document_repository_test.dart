import 'dart:io';
import 'dart:typed_data';

import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/health/data/vet_document_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

const _bucket = VetDocumentRepository.bucket;

VetDocumentModel _document({String id = 'd1', String eventId = 'v1'}) => VetDocumentModel(
      documentId: id,
      eventId: eventId,
      storagePath: '$eventId/$id.pdf',
      fileName: 'ordonnance.pdf',
      mimeType: 'application/pdf',
      sizeBytes: 4,
      source: VetDocumentSource.file,
    );

void main() {
  setUpAll(() {
    registerSupabaseFallbacks();
    registerFallbackValue(File(''));
    registerFallbackValue(const FileOptions());
  });

  final harness = IsarTestHarness();
  late MockSupabaseClient supabase;
  late VetDocumentRepository repo;
  late Directory temp;

  setUp(() async {
    await harness.setUp();
    supabase = MockSupabaseClient();
    temp = Directory.systemTemp.createTempSync('vet_docs_');
    repo = VetDocumentRepository(supabase, harness.isar, tempDir: () async => temp);
    await harness.isar.writeTxn(() => harness.isar.vetVisitCaches.putByVetVisitId(VetVisitCache.fromModel(
          VetVisitModel(vetVisitId: 'v1', title: 'Contrôle', visitedAt: DateTime(2026, 11, 2), petId: 'p1', documentCount: 1),
        )));
  });

  tearDown(() async {
    await harness.tearDown();
    if (temp.existsSync()) temp.deleteSync(recursive: true);
  });

  Future<int> cachedCount() async => (await harness.isar.vetVisitCaches.getByVetVisitId('v1'))!.documentCount;

  File fileOf(String name, int bytes) => File('${temp.path}/$name')..writeAsBytesSync(Uint8List(bytes));

  group('upload refuses before sending anything', () {
    test('a format the bucket would not take', () async {
      await expectLater(
        repo.upload(eventId: 'v1', file: fileOf('notes.docx', 4), fileName: 'notes.docx', source: VetDocumentSource.file, currentCount: 0),
        throwsA(isA<VetDocumentRejected>()),
      );
      verifyNever(() => supabase.storage);
    });

    test('an eleventh document', () async {
      await expectLater(
        repo.upload(eventId: 'v1', file: fileOf('a.pdf', 4), fileName: 'a.pdf', source: VetDocumentSource.file, currentCount: 10),
        throwsA(isA<VetDocumentRejected>().having((e) => e.message, 'message', contains('10 documents'))),
      );
    });

    test('a file over 10 Mo', () async {
      await expectLater(
        repo.upload(
          eventId: 'v1',
          file: fileOf('big.pdf', VetDocumentModel.maxBytes + 1),
          fileName: 'big.pdf',
          source: VetDocumentSource.file,
          currentCount: 0,
        ),
        throwsA(isA<VetDocumentRejected>().having((e) => e.message, 'message', contains('10 Mo'))),
      );
    });
  });

  test('upload stores the file under the visit, then the row, then counts it', () async {
    final fileApi = stubStorageBucket(supabase, _bucket);
    when(() => fileApi.upload(any(), any(), fileOptions: any(named: 'fileOptions'))).thenAnswer((_) async => 'ok');
    Map<String, dynamic>? inserted;
    final qb = MockSupabaseQueryBuilder();
    when(() => supabase.from('event_documents')).thenAnswer((_) => qb);
    when(() => qb.insert(any())).thenAnswer((invocation) {
      inserted = invocation.positionalArguments.first as Map<String, dynamic>;
      return FakePostgrestChain(() => null) as dynamic;
    });

    final document = await repo.upload(
      eventId: 'v1',
      file: fileOf('Ordo.JPG', 4),
      fileName: 'Ordo.JPG',
      source: VetDocumentSource.camera,
      type: VetDocumentType.ordonnance,
      currentCount: 1,
    );

    expect(document.storagePath, startsWith('v1/'));
    expect(document.storagePath, endsWith('.jpg'));
    expect(document.mimeType, 'image/jpeg');
    expect(inserted!['doc_type'], 'ordonnance');
    expect(inserted!['source'], 'camera');
    expect(inserted!['size_bytes'], 4);
    expect(await cachedCount(), 2);
  });

  test('a row refused by the server takes its file back', () async {
    final fileApi = stubStorageBucket(supabase, _bucket);
    when(() => fileApi.upload(any(), any(), fileOptions: any(named: 'fileOptions'))).thenAnswer((_) async => 'ok');
    when(() => fileApi.remove(any())).thenAnswer((_) async => <FileObject>[]);
    stubInsert(supabase, 'event_documents', resolver: () => throw Exception('quota'));

    await expectLater(
      repo.upload(eventId: 'v1', file: fileOf('a.pdf', 4), fileName: 'a.pdf', source: VetDocumentSource.file, currentCount: 0),
      throwsException,
    );

    verify(() => fileApi.remove(any())).called(1);
    expect(await cachedCount(), 1);
  });

  test('delete removes the row, the file, and the count', () async {
    stubDelete(supabase, 'event_documents', resolver: () => null);
    final fileApi = stubStorageRemove(supabase, _bucket, resolver: () {});

    await repo.delete(_document());

    verify(() => fileApi.remove(['v1/d1.pdf'])).called(1);
    expect(await cachedCount(), 0);
  });

  test('a delete refused by the server keeps everything', () async {
    stubDelete(supabase, 'event_documents', resolver: () => throw Exception('offline'));

    await expectLater(repo.delete(_document()), throwsException);
    expect(await cachedCount(), 1);
  });

  test('fetchForVisit maps the rows', () async {
    stubSelect(supabase, 'event_documents', resolver: () => [_document().toJson()]);

    final documents = await repo.fetchForVisit('v1');

    expect(documents.single.documentId, 'd1');
  });

  test('downloadToTemp writes the file under its own name', () async {
    final fileApi = stubStorageBucket(supabase, _bucket);
    when(() => fileApi.download('v1/d1.pdf')).thenAnswer((_) async => Uint8List.fromList([1, 2, 3]));

    final file = await repo.downloadToTemp(_document());

    expect(file.path, endsWith('d1-ordonnance.pdf'));
    expect(file.readAsBytesSync(), [1, 2, 3]);
  });

  test('signedUrl asks the private bucket', () async {
    final fileApi = stubStorageBucket(supabase, _bucket);
    when(() => fileApi.createSignedUrl('v1/d1.pdf', 3600)).thenAnswer((_) async => 'https://signed');

    expect(await repo.signedUrl(_document()), 'https://signed');
  });
}

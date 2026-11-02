import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';

void main() {
  group('VetDocumentModel', () {
    test('round-trips through json', () {
      const original = VetDocumentModel(
        documentId: 'd1',
        eventId: 'e1',
        storagePath: 'e1/d1.pdf',
        fileName: 'ordonnance.pdf',
        mimeType: 'application/pdf',
        sizeBytes: 2048,
        type: VetDocumentType.ordonnance,
        source: VetDocumentSource.file,
      );

      final copy = VetDocumentModel.fromJson({...original.toJson(), 'created_at': '2026-11-02T10:00:00Z'});

      expect(copy.documentId, 'd1');
      expect(copy.eventId, 'e1');
      expect(copy.storagePath, 'e1/d1.pdf');
      expect(copy.sizeBytes, 2048);
      expect(copy.type, VetDocumentType.ordonnance);
      expect(copy.source, VetDocumentSource.file);
      expect(copy.isPdf, isTrue);
      expect(copy.createdAt, DateTime.utc(2026, 11, 2, 10));
      expect(original.toJson()['doc_type'], 'ordonnance');
    });

    test('an unknown type or source falls back instead of throwing', () {
      final copy = VetDocumentModel.fromJson({
        'id_event_document': 'd1',
        'event_id': 'e1',
        'storage_path': 'e1/d1.jpg',
        'file_name': 'photo.jpg',
        'mime_type': 'image/jpeg',
        'size_bytes': 10,
        'doc_type': 'radio',
        'source': 'scanner',
      });

      expect(copy.type, VetDocumentType.autre);
      expect(copy.source, VetDocumentSource.file);
      expect(copy.isPdf, isFalse);
      expect(copy.createdAt, isNull);
    });

    test('compte-rendu keeps its database code', () {
      expect(VetDocumentType.compteRendu.code, 'compte_rendu');
      expect(VetDocumentType.fromCode('compte_rendu'), VetDocumentType.compteRendu);
      expect(VetDocumentType.fromCode(null), VetDocumentType.autre);
    });

    test('only what the bucket accepts gets a mime type', () {
      expect(VetDocumentModel.mimeTypeFor('scan.PDF'), 'application/pdf');
      expect(VetDocumentModel.mimeTypeFor('a.jpeg'), 'image/jpeg');
      expect(VetDocumentModel.mimeTypeFor('a.jpg'), 'image/jpeg');
      expect(VetDocumentModel.mimeTypeFor('a.png'), 'image/png');
      expect(VetDocumentModel.mimeTypeFor('a.heic'), 'image/heic');
      expect(VetDocumentModel.mimeTypeFor('a.webp'), 'image/webp');
      expect(VetDocumentModel.mimeTypeFor('notes.docx'), isNull);
      expect(VetDocumentModel.mimeTypeFor('noextension'), isNull);
    });
  });
}

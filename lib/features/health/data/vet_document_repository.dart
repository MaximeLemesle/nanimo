import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/vet_visit_cache.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';

/// Refused before anything is sent: wrong format, too heavy, or one too many.
class VetDocumentRejected extends RepositoryException {
  const VetDocumentRejected(super.message);
}

class VetDocumentRepository {
  static const bucket = 'health-documents';
  static const _table = 'event_documents';

  final SupabaseClient _supabase;
  final Isar _isar;
  final Future<Directory> Function() _tempDir;

  VetDocumentRepository(this._supabase, this._isar, {Future<Directory> Function()? tempDir})
      : _tempDir = tempDir ?? getTemporaryDirectory;

  Future<List<VetDocumentModel>> fetchForVisit(String eventId) async {
    try {
      final rows = await _supabase.from(_table).select().eq('event_id', eventId).order('created_at');
      return [for (final row in rows) VetDocumentModel.fromJson(row)];
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'fetchVetDocuments',
          networkMessage: 'Une connexion internet est requise pour afficher les documents.',
          serverMessage: 'Impossible de charger les documents pour le moment.');
    }
  }

  /// Files live under `{eventId}/`: the storage policy reads the visit from it.
  Future<VetDocumentModel> upload({
    required String eventId,
    required File file,
    required String fileName,
    required VetDocumentSource source,
    required int currentCount,
    VetDocumentType type = VetDocumentType.autre,
  }) async {
    final mimeType = VetDocumentModel.mimeTypeFor(fileName);
    if (mimeType == null) {
      throw const VetDocumentRejected('Seuls les photos et les PDF peuvent être ajoutés.');
    }
    if (currentCount >= VetDocumentModel.maxPerVisit) {
      throw const VetDocumentRejected('Une visite peut porter 10 documents au maximum.');
    }
    final size = await file.length();
    if (size > VetDocumentModel.maxBytes) {
      throw const VetDocumentRejected('Ce fichier dépasse 10 Mo.');
    }

    final documentId = const Uuid().v4();
    final extension = fileName.substring(fileName.lastIndexOf('.') + 1).toLowerCase();
    final document = VetDocumentModel(
      documentId: documentId,
      eventId: eventId,
      storagePath: '$eventId/$documentId.$extension',
      fileName: fileName,
      mimeType: mimeType,
      sizeBytes: size,
      type: type,
      source: source,
    );

    try {
      await _supabase.storage.from(bucket).upload(
            document.storagePath,
            file,
            fileOptions: FileOptions(contentType: mimeType),
          );
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'uploadVetDocument',
          networkMessage: 'Une connexion internet est requise pour ajouter un document.',
          serverMessage: 'Impossible d’envoyer le document pour le moment.');
    }

    try {
      await _supabase.from(_table).insert(document.toJson());
    } catch (e, st) {
      await _removeQuietly([document.storagePath]);
      throw mapRepositoryError(e, st,
          operation: 'insertVetDocument',
          networkMessage: 'Une connexion internet est requise pour ajouter un document.',
          serverMessage: 'Impossible d’enregistrer le document pour le moment.');
    }

    await _shiftCount(eventId, 1);
    return document;
  }

  Future<void> delete(VetDocumentModel document) async {
    try {
      await _supabase.from(_table).delete().eq('id_event_document', document.documentId);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'deleteVetDocument',
          networkMessage: 'Une connexion internet est requise pour supprimer un document.',
          serverMessage: 'Impossible de supprimer le document pour le moment.');
    }
    await _removeQuietly([document.storagePath]);
    await _shiftCount(document.eventId, -1);
  }

  Future<String> signedUrl(VetDocumentModel document) {
    return _supabase.storage.from(bucket).createSignedUrl(document.storagePath, 3600);
  }

  /// Sharing needs a real file on disk, named as the user knows it.
  Future<File> downloadToTemp(VetDocumentModel document) async {
    try {
      final bytes = await _supabase.storage.from(bucket).download(document.storagePath);
      final dir = await _tempDir();
      final file = File('${dir.path}/${document.documentId}-${document.fileName}');
      return file.writeAsBytes(bytes, flush: true);
    } catch (e, st) {
      throw mapRepositoryError(e, st,
          operation: 'downloadVetDocument',
          networkMessage: 'Une connexion internet est requise pour ouvrir ce document.',
          serverMessage: 'Impossible de récupérer le document pour le moment.');
    }
  }

  Future<void> _removeQuietly(List<String> paths) async {
    if (paths.isEmpty) return;
    try {
      await _supabase.storage.from(bucket).remove(paths);
    } catch (_) {}
  }

  Future<void> _shiftCount(String eventId, int delta) async {
    await _isar.writeTxn(() async {
      final cached = await _isar.vetVisitCaches.getByVetVisitId(eventId);
      if (cached == null) return;
      final next = cached.documentCount + delta;
      cached.documentCount = next < 0 ? 0 : next;
      await _isar.vetVisitCaches.putByVetVisitId(cached);
    });
  }
}

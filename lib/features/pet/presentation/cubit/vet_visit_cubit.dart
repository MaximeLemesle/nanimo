import 'dart:async';
import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/vet_document_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/health/data/vet_document_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'vet_visit_state.dart';

/// One visit, its report and its documents (NAN-133).
class VetVisitCubit extends Cubit<VetVisitState> {
  final HealthRepository _healthRepository;
  final VetDocumentRepository _documentRepository;
  final PetRepository _petRepository;

  /// Opened from the evening follow-up: completing it is credited to it.
  final bool fromNotification;

  StreamSubscription<VetVisitModel?>? _visitSub;
  StreamSubscription<List<PetModel>>? _petsSub;

  VetVisitCubit({
    required HealthRepository healthRepository,
    required VetDocumentRepository documentRepository,
    required PetRepository petRepository,
    this.fromNotification = false,
  })  : _healthRepository = healthRepository,
        _documentRepository = documentRepository,
        _petRepository = petRepository,
        super(const VetVisitState());

  Future<void> load(String vetVisitId) async {
    _petsSub = _petRepository.watchPets().listen((pets) {
      if (!isClosed) emit(state.copyWith(pets: pets));
    });
    _visitSub = _healthRepository.watchVetVisit(vetVisitId).listen((visit) {
      if (isClosed || state.status == VetVisitStatus.deleted) return;
      if (visit == null) {
        emit(state.copyWith(status: VetVisitStatus.notFound));
        return;
      }
      emit(state.copyWith(status: VetVisitStatus.loaded, visit: visit));
    });
    await refreshDocuments(vetVisitId);
  }

  Future<void> refreshDocuments([String? vetVisitId]) async {
    final id = vetVisitId ?? state.visit?.vetVisitId;
    if (id == null) return;
    emit(state.copyWith(documentsStatus: VetDocumentsStatus.loading));
    try {
      final documents = await _documentRepository.fetchForVisit(id);
      if (isClosed) return;
      emit(state.copyWith(documents: documents, documentsStatus: VetDocumentsStatus.loaded));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(documentsStatus: VetDocumentsStatus.error));
    }
  }

  Future<void> addDocument({
    required File file,
    required String fileName,
    required VetDocumentSource source,
    VetDocumentType type = VetDocumentType.autre,
  }) async {
    final visit = state.visit;
    if (visit == null || !state.canAddDocument) return;
    final wasCompleted = visit.isCompleted;
    emit(state.copyWith(isUploading: true, error: () => null));
    try {
      final document = await _documentRepository.upload(
        eventId: visit.vetVisitId,
        file: file,
        fileName: fileName,
        source: source,
        type: type,
        currentCount: state.documents.length,
      );
      if (isClosed) return;
      emit(state.copyWith(isUploading: false, documents: [...state.documents, document]));
      analytics.capture(AnalyticsEvents.vetDocumentAdded, properties: {
        AnalyticsProperties.docType: type.code,
        AnalyticsProperties.source: source.name,
        AnalyticsProperties.mimeType: document.mimeType,
      });
      if (!wasCompleted) _trackCompleted();
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(isUploading: false, error: () => err.toString()));
    }
  }

  Future<void> deleteDocument(VetDocumentModel document) async {
    try {
      await _documentRepository.delete(document);
      if (isClosed) return;
      emit(state.copyWith(
        documents: [for (final d in state.documents) if (d.documentId != document.documentId) d],
      ));
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: () => err.toString()));
    }
  }

  /// The file to hand to the share sheet, or null after an error.
  Future<File?> fileToShare(VetDocumentModel document) async {
    try {
      final file = await _documentRepository.downloadToTemp(document);
      analytics.capture(AnalyticsEvents.vetDocumentShared, properties: {
        AnalyticsProperties.docType: document.type.code,
      });
      return file;
    } catch (err) {
      if (!isClosed) emit(state.copyWith(error: () => err.toString()));
      return null;
    }
  }

  Future<String?> documentUrl(VetDocumentModel document) async {
    try {
      return await _documentRepository.signedUrl(document);
    } catch (err) {
      if (!isClosed) emit(state.copyWith(error: () => err.toString()));
      return null;
    }
  }

  Future<File?> documentFile(VetDocumentModel document) async {
    try {
      return await _documentRepository.downloadToTemp(document);
    } catch (err) {
      if (!isClosed) emit(state.copyWith(error: () => err.toString()));
      return null;
    }
  }

  Future<void> updateVisit(VetVisitModel next) async {
    final wasCompleted = state.visit?.isCompleted ?? false;
    try {
      await _healthRepository.updateVetVisit(next);
      if (!wasCompleted && next.isCompleted) _trackCompleted();
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: () => err.toString()));
    }
  }

  Future<bool> deleteVisit() async {
    final visit = state.visit;
    if (visit == null) return false;
    try {
      await _healthRepository.deleteVetVisit(visit.vetVisitId);
      if (isClosed) return true;
      emit(state.copyWith(status: VetVisitStatus.deleted));
      return true;
    } catch (err) {
      if (!isClosed) emit(state.copyWith(error: () => err.toString()));
      return false;
    }
  }

  void clearError() => emit(state.copyWith(error: () => null));

  void _trackCompleted() {
    analytics.capture(AnalyticsEvents.vetVisitCompleted, properties: {
      AnalyticsProperties.fromNotification: fromNotification,
    });
  }

  @override
  Future<void> close() {
    _visitSub?.cancel();
    _petsSub?.cancel();
    return super.close();
  }
}

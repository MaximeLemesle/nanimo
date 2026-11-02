part of 'vet_visit_cubit.dart';

enum VetVisitStatus { loading, loaded, notFound, deleted }

enum VetDocumentsStatus { loading, loaded, error }

class VetVisitState extends Equatable {
  final VetVisitStatus status;
  final VetVisitModel? visit;
  final List<PetModel> pets;
  final List<VetDocumentModel> documents;
  final VetDocumentsStatus documentsStatus;
  final bool isUploading;
  final String? error;

  const VetVisitState({
    this.status = VetVisitStatus.loading,
    this.visit,
    this.pets = const [],
    this.documents = const [],
    this.documentsStatus = VetDocumentsStatus.loading,
    this.isUploading = false,
    this.error,
  });

  PetModel? get pet {
    for (final pet in pets) {
      if (pet.petId == visit?.petId) return pet;
    }
    return null;
  }

  bool get canAddDocument => documents.length < VetDocumentModel.maxPerVisit && !isUploading;

  VetVisitState copyWith({
    VetVisitStatus? status,
    VetVisitModel? visit,
    List<PetModel>? pets,
    List<VetDocumentModel>? documents,
    VetDocumentsStatus? documentsStatus,
    bool? isUploading,
    String? Function()? error,
  }) {
    return VetVisitState(
      status: status ?? this.status,
      visit: visit ?? this.visit,
      pets: pets ?? this.pets,
      documents: documents ?? this.documents,
      documentsStatus: documentsStatus ?? this.documentsStatus,
      isUploading: isUploading ?? this.isUploading,
      error: error != null ? error() : this.error,
    );
  }

  @override
  List<Object?> get props => [status, visit, pets, documents, documentsStatus, isUploading, error];
}

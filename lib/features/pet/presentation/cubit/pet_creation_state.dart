part of 'pet_creation_cubit.dart';

enum PetCreationStatus { idle, creating, success, error }

class PetCreationState extends Equatable {
  final PetCreationStatus status;
  final String? error;
  final PetModel? pendingPet;

  const PetCreationState({
    this.status = PetCreationStatus.idle,
    this.error,
    this.pendingPet,
  });

  PetCreationState copyWith({
    PetCreationStatus? status,
    String? error,
    PetModel? pendingPet,
    bool clearError = false,
    bool clearPendingPet = false,
  }) {
    return PetCreationState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      pendingPet: clearPendingPet ? null : (pendingPet ?? this.pendingPet),
    );
  }

  @override
  List<Object?> get props => [status, error, pendingPet];
}

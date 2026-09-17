part of 'pet_creation_cubit.dart';

enum PetCreationStatus { idle, creating, success, error }

class PetCreationState extends Equatable {
  final PetCreationStatus status;
  final String? error;
  final PetModel? pendingPet;

  /// True for the pet inserted right after the signup, false for an in-app one.
  final bool createdDuringOnboarding;

  const PetCreationState({
    this.status = PetCreationStatus.idle,
    this.error,
    this.pendingPet,
    this.createdDuringOnboarding = false,
  });

  PetCreationState copyWith({
    PetCreationStatus? status,
    String? error,
    PetModel? pendingPet,
    bool? createdDuringOnboarding,
    bool clearError = false,
    bool clearPendingPet = false,
  }) {
    return PetCreationState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      pendingPet: clearPendingPet ? null : (pendingPet ?? this.pendingPet),
      createdDuringOnboarding:
          createdDuringOnboarding ?? this.createdDuringOnboarding,
    );
  }

  @override
  List<Object?> get props =>
      [status, error, pendingPet, createdDuringOnboarding];
}

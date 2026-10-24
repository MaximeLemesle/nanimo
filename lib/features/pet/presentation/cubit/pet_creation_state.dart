part of 'pet_creation_cubit.dart';

enum PetCreationStatus { idle, creating, success, error }

class PetCreationState extends Equatable {
  final PetCreationStatus status;
  final String? error;
  final PetModel? pendingPet;

  /// Created right after the pet when the onboarding asked for it (NAN-105).

  /// True for the pet inserted right after the signup, false for an in-app one.
  final bool createdDuringOnboarding;

  /// The onboarding pet is written but the home has not shown it yet.
  final String? awaitedPetId;

  const PetCreationState({
    this.status = PetCreationStatus.idle,
    this.error,
    this.pendingPet,
    this.createdDuringOnboarding = false,
    this.awaitedPetId,
  });

  /// The home keeps its loader instead of saying it has no animal.
  bool get isPetOnItsWay =>
      (pendingPet != null && status != PetCreationStatus.error) ||
      awaitedPetId != null;

  PetCreationState copyWith({
    PetCreationStatus? status,
    String? error,
    PetModel? pendingPet,
    bool? createdDuringOnboarding,
    bool clearError = false,
    String? awaitedPetId,
    bool clearPendingPet = false,
    bool clearAwaitedPet = false,
  }) {
    return PetCreationState(
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      pendingPet: clearPendingPet ? null : (pendingPet ?? this.pendingPet),
      createdDuringOnboarding:
          createdDuringOnboarding ?? this.createdDuringOnboarding,
      awaitedPetId:
          clearAwaitedPet ? null : (awaitedPetId ?? this.awaitedPetId),
    );
  }

  @override
  List<Object?> get props =>
      [status, error, pendingPet, createdDuringOnboarding, awaitedPetId];
}

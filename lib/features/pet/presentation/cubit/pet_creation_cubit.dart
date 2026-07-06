import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'pet_creation_state.dart';

class PetCreationCubit extends Cubit<PetCreationState> {
  final AuthCubit _authCubit;
  final PetRepository _petRepository;
  final Uuid _uuid;

  StreamSubscription<AuthState>? _authSubscription;
  AuthStatus _lastAuthStatus;

  PetCreationCubit({
    required AuthCubit authCubit,
    required PetRepository petRepository,
    Uuid? uuid,
  })  : _authCubit = authCubit,
        _petRepository = petRepository,
        _uuid = uuid ?? const Uuid(),
        _lastAuthStatus = authCubit.state.status,
        super(const PetCreationState()) {
    _authSubscription = _authCubit.stream.listen(_onAuthChanged);
  }

  /// Save the pet create before signup
  void prepare({
    required String petName,
    required String petSpeciesId,
    required String petRaceId,
    required Gender gender,
    required DateTime birthdate,
  }) {
    final pet = PetModel(
      petId: _uuid.v4(),
      petName: petName,
      birthdate: birthdate,
      gender: gender,
      createdAt: DateTime.now().toUtc(),
      petRaceId: petRaceId,
      petSpeciesId: petSpeciesId,
    );
    emit(PetCreationState(pendingPet: pet));
  }

  /// Check if the user is authenticated
  void _onAuthChanged(AuthState authState) {
    final previous = _lastAuthStatus;
    _lastAuthStatus = authState.status;

    final justSignedIn = previous == AuthStatus.unauthenticated &&
        authState.status == AuthStatus.authenticated;
    if (!justSignedIn) return;

    if (state.pendingPet == null) return;
    _createPet();
  }

  Future<void> _createPet() async {
    final pet = state.pendingPet;
    if (pet == null) return;

    emit(state.copyWith(
      status: PetCreationStatus.creating,
      clearError: true,
    ));
    try {
      await _petRepository.createPet(pet);
      emit(state.copyWith(
        status: PetCreationStatus.success,
        clearPendingPet: true,
      ));
    } on RepositoryException catch (e) {
      emit(state.copyWith(
        status: PetCreationStatus.error,
        error: e.message,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: PetCreationStatus.error,
        error: 'Impossible de créer votre animal.',
      ));
    }
  }

  Future<void> retry() async {
    if (state.pendingPet == null) return;
    await _createPet();
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}

import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/onboarding/presentation/cubit/onboarding_cubit.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'pet_creation_state.dart';

class PetCreationCubit extends Cubit<PetCreationState> {
  final AuthCubit _authCubit;
  final PetRepository _petRepository;
  final HealthRepository? _healthRepository;
  final Uuid _uuid;

  StreamSubscription<AuthState>? _authSubscription;
  AuthStatus _lastAuthStatus;

  PetCreationCubit({
    required AuthCubit authCubit,
    required PetRepository petRepository,
    HealthRepository? healthRepository,
    Uuid? uuid,
  })  : _authCubit = authCubit,
        _petRepository = petRepository,
        _healthRepository = healthRepository,
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
    String? petIconId,
    PendingVaccine? vaccine,
  }) {
    final pet = PetModel(
      petId: _uuid.v4(),
      petName: petName,
      birthdate: birthdate,
      gender: gender,
      createdAt: DateTime.now().toUtc(),
      petRaceId: petRaceId,
      petSpeciesId: petSpeciesId,
      petIconId: petIconId,
    );
    emit(PetCreationState(pendingPet: pet, pendingVaccine: vaccine));

    if (_authCubit.state.status == AuthStatus.authenticated) {
      _createPet();
    }
  }

  /// Check if the user is authenticated
  void _onAuthChanged(AuthState authState) {
    final previous = _lastAuthStatus;
    _lastAuthStatus = authState.status;

    final justSignedIn = previous == AuthStatus.unauthenticated &&
        authState.status == AuthStatus.authenticated;
    if (!justSignedIn) return;

    if (state.pendingPet == null) return;
    _createPet(duringOnboarding: true);
  }

  Future<void> _createPet({bool duringOnboarding = false}) async {
    final pet = state.pendingPet;
    if (pet == null) return;

    emit(state.copyWith(
      status: PetCreationStatus.creating,
      createdDuringOnboarding: duringOnboarding,
      clearError: true,
    ));
    try {
      await _petRepository.createPet(pet);
      analytics.capture(AnalyticsEvents.petCreated);
      await _createVaccine(pet.petId, state.pendingVaccine);
      emit(state.copyWith(
        status: PetCreationStatus.success,
        clearPendingPet: true,
      ));
    } on RepositoryException catch (e) {
      _trackCreationFailed(e is RepositoryNetworkException ? 'network' : 'server');
      emit(state.copyWith(
        status: PetCreationStatus.error,
        error: e.message,
      ));
    } catch (e) {
      _trackCreationFailed('unknown');
      emit(state.copyWith(
        status: PetCreationStatus.error,
        error: 'Impossible de créer votre animal.',
      ));
    }
  }

  /// Best effort: the pet is in, a vaccine that fails can be added later.
  Future<void> _createVaccine(String petId, PendingVaccine? vaccine) async {
    final health = _healthRepository;
    if (vaccine == null || health == null) return;
    try {
      final diaryId = _uuid.v4();
      await health.upsertDiary(HealthDiaryModel(healthDiaryId: diaryId, petId: petId));
      await health.addVaccine(HealthDiaryVaccineModel(
        healthDiaryVaccineId: _uuid.v4(),
        vaccineName: vaccine.name,
        lastDate: vaccine.lastDate,
        nextDate: vaccine.nextDate,
        recurrence: vaccine.recurrence,
        doseNumber: 1,
        totalDoseNumber: 1,
        healthDiaryId: diaryId,
      ));
      analytics.capture(
        AnalyticsEvents.vaccineCreated,
        properties: {AnalyticsProperties.source: HealthEntrySource.onboarding},
      );
    } catch (_) {}
  }

  void _trackCreationFailed(String reason) {
    analytics.capture(
      AnalyticsEvents.petCreationFailed,
      properties: {AnalyticsProperties.reason: reason},
    );
  }

  Future<void> retry() async {
    if (state.pendingPet == null) return;
    await _createPet(duringOnboarding: state.createdDuringOnboarding);
  }

  @override
  Future<void> close() async {
    await _authSubscription?.cancel();
    return super.close();
  }
}

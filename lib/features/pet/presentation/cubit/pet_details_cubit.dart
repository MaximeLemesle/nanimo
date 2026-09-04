import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_weight_log_model.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:nanimo/features/health/data/models/vet_visit_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:uuid/uuid.dart';

part 'pet_details_state.dart';

class PetDetailsCubit extends Cubit<PetDetailsState> {
  final PetRepository _petRepository;
  final HealthRepository _healthRepository;
  final ReferentialRepository _referentialRepository;

  StreamSubscription<List<PetModel>>? _petsSub;
  StreamSubscription<HealthDiaryModel?>? _diarySub;
  StreamSubscription<List<HealthDiaryVaccineModel>>? _vaccinesSub;
  StreamSubscription<List<HealthDiaryWeightLogModel>>? _weightSub;
  StreamSubscription<List<VetVisitModel>>? _vetVisitsSub;

  PetDetailsCubit({
    required PetRepository petRepository,
    required HealthRepository healthRepository,
    required ReferentialRepository referentialRepository,
  })  : _petRepository = petRepository,
        _healthRepository = healthRepository,
        _referentialRepository = referentialRepository,
        super(const PetDetailsState()) {
    _petsSub = _petRepository.watchPets().listen(_onPetsChanged);
    _loadSpecies();
    _loadIcons();
  }

  void _onPetsChanged(List<PetModel> pets) {
    final currentId = state.selectedPetId;
    final stillExists = pets.any((p) => p.petId == currentId);
    final selectedId =
        stillExists ? currentId : (pets.isNotEmpty ? pets.first.petId : null);

    emit(state.copyWith(
      status: PetDetailsStatus.loaded,
      pets: pets,
      selectedPetId: selectedId,
    ));

    if (selectedId != null && selectedId != currentId) {
      _subscribeToPet(selectedId);
    }
  }

  void selectPet(String petId) {
    if (petId == state.selectedPetId) return;
    emit(state.copyWith(selectedPetId: petId));
    _subscribeToPet(petId);
  }

  Future<void> addWeightLog(
    double weight,
    DateTime loggedAt, {
    String? petId,
  }) async {
    final targetId = petId ?? state.selectedPetId;
    if (targetId == null) return;
    try {
      final log = HealthDiaryWeightLogModel(
        healthDiaryWeightLogId: const Uuid().v4(),
        weight: weight,
        loggedAt: loggedAt,
        petId: targetId,
      );
      await _healthRepository.addWeightLog(log);
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> createHealthDiary({
    double? birthWeight,
    DateTime? birthWeightDate,
    bool? isSterilized,
    bool? isChipped,
    String? chipNumber,
    DateTime? lastDeworming,
    List<({String name, DateTime lastDate, DateTime nextDate, int recurrence})>
        vaccines = const [],
    List<
            ({
              String title,
              DateTime visitedAt,
              String? vetName,
              String? clinicName
            })>
        vetVisits = const [],
  }) async {
    final petId = state.selectedPetId;
    if (petId == null) return;
    try {
      final healthDiaryId = state.diary?.healthDiaryId ?? const Uuid().v4();
      final diary = HealthDiaryModel(
        healthDiaryId: healthDiaryId,
        petId: petId,
        isSterilized: isSterilized,
        isChipped: isChipped,
        chipNumber: chipNumber,
        lastDeworming: lastDeworming,
        lastVetAppointment: state.diary?.lastVetAppointment,
      );
      await _healthRepository.upsertDiary(diary);

      if (birthWeight != null) {
        await _healthRepository.addWeightLog(
          HealthDiaryWeightLogModel(
            healthDiaryWeightLogId: const Uuid().v4(),
            weight: birthWeight,
            loggedAt: birthWeightDate ?? DateTime.now(),
            petId: petId,
          ),
        );
      }

      for (final vaccine in vaccines) {
        await _healthRepository.addVaccine(
          HealthDiaryVaccineModel(
            healthDiaryVaccineId: const Uuid().v4(),
            vaccineName: vaccine.name,
            lastDate: vaccine.lastDate,
            nextDate: vaccine.nextDate,
            recurrence: vaccine.recurrence,
            doseNumber: 1,
            totalDoseNumber: 1,
            healthDiaryId: healthDiaryId,
          ),
        );
      }

      for (final visit in vetVisits) {
        await _healthRepository.addVetVisit(
          VetVisitModel(
            vetVisitId: const Uuid().v4(),
            title: visit.title,
            visitedAt: visit.visitedAt,
            vetName: visit.vetName,
            clinicName: visit.clinicName,
            petId: petId,
          ),
        );
      }
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> updateDiary({
    bool? isSterilized,
    bool? isChipped,
    String? chipNumber,
    DateTime? lastDeworming,
    DateTime? lastVetAppointment,
  }) async {
    final petId = state.selectedPetId;
    if (petId == null) return;
    try {
      final current = state.diary;
      final diary = HealthDiaryModel(
        healthDiaryId: current?.healthDiaryId ?? const Uuid().v4(),
        petId: petId,
        isSterilized: isSterilized ?? current?.isSterilized,
        isChipped: isChipped ?? current?.isChipped,
        chipNumber: chipNumber ?? current?.chipNumber,
        lastDeworming: lastDeworming ?? current?.lastDeworming,
        lastVetAppointment: lastVetAppointment ?? current?.lastVetAppointment,
      );
      await _healthRepository.upsertDiary(diary);
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> addVaccine({
    required String vaccineName,
    required DateTime lastDate,
    required DateTime nextDate,
    int recurrence = 0,
    int doseNumber = 1,
    int totalDoseNumber = 1,
  }) async {
    final petId = state.selectedPetId;
    if (petId == null) return;
    try {
      final healthDiaryId = await _ensureDiary(petId);
      if (healthDiaryId == null) return;
      final vaccine = HealthDiaryVaccineModel(
        healthDiaryVaccineId: const Uuid().v4(),
        vaccineName: vaccineName,
        lastDate: lastDate,
        nextDate: nextDate,
        recurrence: recurrence,
        doseNumber: doseNumber,
        totalDoseNumber: totalDoseNumber,
        healthDiaryId: healthDiaryId,
      );
      await _healthRepository.addVaccine(vaccine);
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> updateVaccine(HealthDiaryVaccineModel vaccine) async {
    try {
      await _healthRepository.updateVaccine(vaccine);
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  Future<void> addVetVisit({
    required String title,
    required DateTime visitedAt,
    String? vetName,
    String? clinicName,
  }) async {
    final petId = state.selectedPetId;
    if (petId == null) return;
    try {
      final visit = VetVisitModel(
        vetVisitId: const Uuid().v4(),
        title: title,
        visitedAt: visitedAt,
        vetName: vetName,
        clinicName: clinicName,
        petId: petId,
      );
      await _healthRepository.addVetVisit(visit);
    } catch (err) {
      if (isClosed) return;
      emit(state.copyWith(error: err.toString()));
    }
  }

  /// Returns the diary id for [petId], creating an empty diary if needed.
  Future<String?> _ensureDiary(String petId) async {
    final existing = state.diary;
    if (existing != null) return existing.healthDiaryId;
    final diary = HealthDiaryModel(
      healthDiaryId: const Uuid().v4(),
      petId: petId,
    );
    await _healthRepository.upsertDiary(diary);
    return diary.healthDiaryId;
  }

  void clearError() {
    if (state.error == null) return;
    emit(state.copyWith(error: null));
  }

  void _subscribeToPet(String petId) {
    _diarySub?.cancel();
    _vaccinesSub?.cancel();
    _weightSub?.cancel();
    _vetVisitsSub?.cancel();

    /// Species-specific data belongs to the pet it was fetched for. Keeping the
    /// previous pet's list while the new fetch is in flight offers e.g. cat
    /// vaccines for a rabbit — and they get saved to the rabbit's diary.
    emit(state.copyWith(recommendedVaccines: const []));

    _diarySub =
        _healthRepository.watchDiaryForPet(petId).listen(_onDiaryChanged);
    _weightSub = _healthRepository
        .getWeightLogsForPet(petId)
        .listen(_onWeightLogsChanged);
    _vetVisitsSub =
        _healthRepository.getVetVisitsForPet(petId).listen(_onVetVisitsChanged);
    _loadRaceName(petId);
    _loadRecommendedVaccines(petId);
  }

  void _onDiaryChanged(HealthDiaryModel? diary) {
    emit(state.copyWith(diary: diary));

    _vaccinesSub?.cancel();
    if (diary != null) {
      _vaccinesSub = _healthRepository
          .getVaccinesForDiary(diary.healthDiaryId)
          .listen(_onVaccinesChanged);
    } else {
      emit(state.copyWith(vaccines: const []));
    }
  }

  void _onVaccinesChanged(List<HealthDiaryVaccineModel> vaccines) {
    emit(state.copyWith(vaccines: vaccines));
  }

  void _onWeightLogsChanged(List<HealthDiaryWeightLogModel> logs) {
    emit(state.copyWith(
      weightLogs: logs,
      latestWeight: logs.isEmpty ? null : logs.last.weight,
    ));
  }

  void _onVetVisitsChanged(List<VetVisitModel> visits) {
    emit(state.copyWith(vetVisits: visits));
  }

  Future<void> _loadSpecies() async {
    try {
      final species = await _referentialRepository.fetchSpecies();
      if (isClosed) return;
      emit(state.copyWith(
        iconsKey: {for (final s in species) s.petSpeciesId: s.iconKey},
        speciesNameById: {
          for (final s in species) s.petSpeciesId: s.speciesName
        },
      ));
    } catch (_) {}
  }

  Future<void> _loadIcons() async {
    try {
      final icons = await _referentialRepository.fetchIcons();
      if (isClosed) return;
      emit(state.copyWith(icons: icons));
    } catch (_) {}
  }


  Future<void> _loadRaceName(String petId) async {
    PetModel? pet;
    for (final p in state.pets) {
      if (p.petId == petId) {
        pet = p;
        break;
      }
    }
    if (pet == null) return;

    try {
      final races =
          await _referentialRepository.fetchRacesBySpecies(pet.petSpeciesId);
      if (isClosed) return;
      final matches = races.where((r) => r.petRaceId == pet!.petRaceId);
      emit(state.copyWith(
        raceName: matches.isEmpty ? null : matches.first.raceName,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(raceName: null));
    }
  }

  /// Loads the recommended vaccines for the selected pet's species.
  Future<void> _loadRecommendedVaccines(String petId) async {
    PetModel? pet;
    for (final petType in state.pets) {
      if (petType.petId == petId) {
        pet = petType;
        break;
      }
    }
    if (pet == null) return;

    try {
      final vaccines = await _referentialRepository
          .fetchRecommendedVaccinesBySpecies(pet.petSpeciesId);
      if (isClosed || state.selectedPetId != petId) return;
      emit(state.copyWith(recommendedVaccines: vaccines));
    } catch (_) {
      if (isClosed || state.selectedPetId != petId) return;
      emit(state.copyWith(recommendedVaccines: const []));
    }
  }

  @override
  Future<void> close() {
    _petsSub?.cancel();
    _diarySub?.cancel();
    _vaccinesSub?.cancel();
    _weightSub?.cancel();
    _vetVisitsSub?.cancel();
    return super.close();
  }
}

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/core/utils/pet_icon_resolver.dart';
import 'package:nanimo/core/utils/pet_portrait.dart';
import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'edit_pet_state.dart';

/// Edits an existing pet. The species is never touched
class EditPetCubit extends Cubit<EditPetState> {
  final PetRepository _petRepository;
  final ReferentialRepository _referentialRepository;
  final EventRepository _eventRepository;

  EditPetCubit({
    required PetRepository petRepository,
    required ReferentialRepository referentialRepository,
    required EventRepository eventRepository,
  })  : _petRepository = petRepository,
        _referentialRepository = referentialRepository,
        _eventRepository = eventRepository,
        super(const EditPetState());

  Future<void> load(String petId) async {
    final pet = await _petRepository.getPetById(petId);
    if (isClosed) return;
    if (pet == null) {
      emit(state.copyWith(
        status: EditPetStatus.error,
        error: 'Cet animal est introuvable.',
      ));
      return;
    }

    final eventCount = await _eventRepository.countEventsForPet(petId);
    if (isClosed) return;
    emit(state.copyWith(pet: pet, eventCount: eventCount));

    try {
      final races =
          await _referentialRepository.fetchRacesBySpecies(pet.petSpeciesId);
      final species = await _referentialRepository.fetchSpecies();
      if (isClosed) return;

      final match = species.where((s) => s.petSpeciesId == pet.petSpeciesId);
      emit(state.copyWith(
        races: races,
        speciesName: match.isEmpty ? null : match.first.speciesName,
        speciesIconKey: match.isEmpty ? null : match.first.iconKey,
      ));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: EditPetStatus.error,
        error: 'Impossible de charger les races.',
      ));
      return;
    }

    await _loadPetIcons();
  }

  Future<void> _loadPetIcons() async {
    try {
      final icons = await _referentialRepository.fetchIcons();
      if (isClosed) return;
      emit(state.copyWith(icons: icons));
    } catch (_) {
    }
  }

  Future<void> submit({
    required String petName,
    required String petRaceId,
    required Gender gender,
    required DateTime birthdate,
  }) async {
    final pet = state.pet;
    if (pet == null) return;

    emit(state.copyWith(status: EditPetStatus.loading));

    final icon = PetIconResolver.defaultIcon(
      icons: state.icons,
      petRaceId: petRaceId,
      speciesIconKey: state.speciesIconKey,
    );

    try {
      await _petRepository.updatePet(pet.copyWith(
        petName: petName.trim(),
        petRaceId: petRaceId,
        gender: gender,
        birthdate: birthdate,
        petIconId: icon?.petIconId ?? pet.petIconId,
      ));
      if (isClosed) return;
      emit(state.copyWith(status: EditPetStatus.success));
    } on RepositoryException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: EditPetStatus.error, error: e.message));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: EditPetStatus.error,
        error: 'Une erreur est survenue lors de la modification de l\'animal.',
      ));
    }
  }

  Future<void> delete() async {
    final pet = state.pet;
    if (pet == null) return;

    emit(state.copyWith(status: EditPetStatus.deleting));

    try {
      await _petRepository.deletePet(pet.petId);
      await _eventRepository.purgeLocalEventsForPet(pet.petId);
      if (isClosed) return;
      emit(state.copyWith(status: EditPetStatus.deleted));
    } on RepositoryException catch (e) {
      if (isClosed) return;
      emit(state.copyWith(status: EditPetStatus.error, error: e.message));
    } catch (_) {
      if (isClosed) return;
      emit(state.copyWith(
        status: EditPetStatus.error,
        error: 'Une erreur est survenue lors de la suppression de l\'animal.',
      ));
    }
  }
}

import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'edit_event_state.dart';

class EditEventCubit extends Cubit<EditEventState> {
  final EventRepository _eventRepository;
  final ReferentialRepository _referentialRepository;
  final PetRepository _petRepository;

  EditEventCubit({
    required EventRepository eventRepository,
    required ReferentialRepository referentialRepository,
    required PetRepository petRepository,
  })  : _eventRepository = eventRepository,
        _referentialRepository = referentialRepository,
        _petRepository = petRepository,
        super(const EditEventState());

  Future<void> load(String eventId) async {
    final event = await _eventRepository.getEventById(eventId);
    if (event == null) {
      emit(state.copyWith(
        status: EditEventStatus.error,
        error: 'Ce souvenir est introuvable.',
      ));
      return;
    }

    final petIds = await _eventRepository.getPetIdsForEvent(eventId);
    final images = await _eventRepository.watchImagesForEvent(eventId).first;
    final pets = await _petRepository.getPets();

    emit(state.copyWith(
      event: event,
      existingImages: images,
      pets: pets,
      selectedPetIds: petIds,
    ));

    try {
      final types = await _referentialRepository.fetchEventTypes();
      final species = await _referentialRepository.fetchSpecies();

      emit(state.copyWith(
        types: types,
        selectedTypeId: event.eventTypeId,
        iconsKey: {
          for (final species in species) species.petSpeciesId: species.iconKey,
        },
      ));
    } catch (_) {
      emit(state.copyWith(
        status: EditEventStatus.error,
        error: 'Impossible de charger les types d\'événement.',
      ));
    }
  }

  void selectType(String eventTypeId) {
    emit(state.copyWith(selectedTypeId: eventTypeId));
  }

  void setSelectedPets(List<String> petIds) {
    emit(state.copyWith(selectedPetIds: petIds));
  }

  /// Persists the edited fields, syncs linked pets, and applies photo changes.
  Future<void> submit({
    required String title,
    String? description,
    required DateTime entryDate,
    required List<XFile> newImages,
    required List<EventImageModel> removedImages,
  }) async {
    final event = state.event;
    if (event == null) return;

    final eventTypeId = state.selectedTypeId;
    if (eventTypeId == null) {
      emit(state.copyWith(
        status: EditEventStatus.error,
        error: 'Veuillez choisir un type d\'événement.',
      ));
      return;
    }

    final petIds = state.selectedPetIds;
    if (petIds.isEmpty) {
      emit(state.copyWith(
        status: EditEventStatus.error,
        error: 'Veuillez choisir au moins un animal.',
      ));
      return;
    }

    emit(state.copyWith(status: EditEventStatus.loading));

    final trimDescription = description?.trim();

    try {
      await _eventRepository.updateEvent(EventModel(
        eventId: event.eventId,
        title: title.trim(),
        description: (trimDescription == null || trimDescription.isEmpty)
            ? null
            : trimDescription,
        entryDate: entryDate,
        createdAt: event.createdAt,
        eventTypeId: eventTypeId,
      ));

      await _eventRepository.updateEventPets(event.eventId, petIds);

      for (final image in removedImages) {
        await _eventRepository.deleteImage(image.eventImageId, image.assetPath);
      }

      for (final image in newImages) {
        final path = await _eventRepository.uploadEventImage(
          event.eventId,
          File(image.path),
        );
        await _eventRepository.addImage(EventImageModel(
          eventImageId: const Uuid().v4(),
          assetPath: path,
          eventId: event.eventId,
        ));
      }

      emit(state.copyWith(status: EditEventStatus.success));
    } on RepositoryNetworkException catch (e) {
      emit(state.copyWith(status: EditEventStatus.error, error: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: EditEventStatus.error,
        error: 'Une erreur est survenue lors de la modification de l\'événement.',
      ));
    }
  }

  Future<String> imageUrl(String assetPath) =>
      _eventRepository.signedImageUrl(assetPath);
}

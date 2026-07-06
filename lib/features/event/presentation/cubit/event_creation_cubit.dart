import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_image_model.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'event_creation_state.dart';

class EventCreationCubit extends Cubit<EventCreationState> {
  final EventRepository _eventRepository;
  final ReferentialRepository _referentialRepository;
  final PetRepository _petRepository;

  EventCreationCubit({
    required EventRepository eventRepository,
    required ReferentialRepository referentialRepository,
    required PetRepository petRepository,
  })  : _eventRepository = eventRepository,
        _referentialRepository = referentialRepository,
        _petRepository = petRepository,
        super(const EventCreationState());

  Future<void> load({String? initialPetId}) async {
    final pets = await _petRepository.getPets();
    final defaultPetId = pets.any((pet) => pet.petId == initialPetId)
        ? initialPetId
        : (pets.isNotEmpty ? pets.first.petId : null);
    emit(state.copyWith(
      pets: pets,
      selectedPetIds: defaultPetId != null ? [defaultPetId] : const [],
    ));

    try {
      final types = await _referentialRepository.fetchEventTypes();
      final species = await _referentialRepository.fetchSpecies();

      final defaultType = types.isEmpty
          ? null
          : types.firstWhere(
              (type) => type.code == 'balade',
              orElse: () => types.first,
            );

      emit(state.copyWith(
        types: types,
        selectedTypeId: defaultType?.eventTypeId,
        iconsKey: {
          for (final species in species) species.petSpeciesId: species.iconKey,
        },
      ));
    } catch (_) {
      emit(state.copyWith(
        status: EventCreationStatus.error,
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

  /// Create the event and then upload
  Future<void> submit({
    required String title,
    String? description,
    required DateTime entryDate,
    required List<XFile> images,
  }) async {
    final eventTypeId = state.selectedTypeId;
    if (eventTypeId == null) {
      emit(state.copyWith(
        status: EventCreationStatus.error,
        error: 'Veuillez choisir un type d\'événement.',
      ));
      return;
    }

    final petIds = state.selectedPetIds;
    if (petIds.isEmpty) {
      emit(state.copyWith(
        status: EventCreationStatus.error,
        error: 'Veuillez choisir au moins un animal.',
      ));
      return;
    }

    emit(state.copyWith(status: EventCreationStatus.loading));

    final eventId = const Uuid().v4();
    final trimDescription = description?.trim();

    try {
      await _eventRepository.createEvent(
        EventModel(
          eventId: eventId,
          title: title.trim(),
          description: (trimDescription == null || trimDescription.isEmpty)
              ? null
              : trimDescription,
          entryDate: entryDate,
          createdAt: DateTime.now(),
          eventTypeId: eventTypeId,
        ),
        petIds: petIds,
      );

      for (final image in images) {
        final path =
            await _eventRepository.uploadEventImage(eventId, File(image.path));
        await _eventRepository.addImage(EventImageModel(
          eventImageId: const Uuid().v4(),
          assetPath: path,
          eventId: eventId,
        ));
      }

      emit(state.copyWith(status: EventCreationStatus.success));
    } on RepositoryException catch (e) {
      emit(state.copyWith(status: EventCreationStatus.error, error: e.message));
    } catch (_) {
      emit(state.copyWith(
        status: EventCreationStatus.error,
        error: 'Une erreur est survenue lors de la création de l\'événement.',
      ));
    }
  }
}

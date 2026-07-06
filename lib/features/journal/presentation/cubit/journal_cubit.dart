import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/errors/repository_exception.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'journal_state.dart';

class JournalCubit extends Cubit<JournalState> {
  final EventRepository _eventRepository;
  final PetRepository _petRepository;
  final ReferentialRepository _referentialRepository;

  StreamSubscription<List<EventModel>>? _eventsSubscription;
  StreamSubscription<Map<String, List<String>>>? _petEventsSubscription;
  StreamSubscription<Map<String, List<String>>>? _imagesSubscription;

  JournalCubit({
    required EventRepository eventRepository,
    required PetRepository petRepository,
    required ReferentialRepository referentialRepository,
  })  : _eventRepository = eventRepository,
        _petRepository = petRepository,
        _referentialRepository = referentialRepository,
        super(const JournalState()) {
    _eventsSubscription =
        _eventRepository.watchEvents().listen(_onEventsChanged);
    _petEventsSubscription =
        _eventRepository.watchPetEvents().listen(_onPetEventsChanged);
    _imagesSubscription =
        _eventRepository.watchAllImages().listen(_onImagesChanged);
    _load();
  }

  void _onEventsChanged(List<EventModel> events) {
    emit(state.copyWith(status: JournalStatus.loaded, events: events));
  }

  void _onPetEventsChanged(Map<String, List<String>> petIdsByEvent) {
    emit(state.copyWith(petIdsByEvent: petIdsByEvent));
  }

  void _onImagesChanged(Map<String, List<String>> imagePathsByEvent) {
    emit(state.copyWith(imagePathsByEvent: imagePathsByEvent));
  }

  Future<void> _load() async {
    final pets = await _petRepository.getPets();
    emit(state.copyWith(pets: pets));

    try {
      final types = await _referentialRepository.fetchEventTypes();
      final species = await _referentialRepository.fetchSpecies();
      emit(state.copyWith(
        types: types,
        iconsKey: {
          for (final s in species) s.petSpeciesId: s.iconKey,
        },
      ));
    } catch (_) {
      emit(state.copyWith(
        status: JournalStatus.error,
        error: 'Impossible de charger le journal.',
      ));
    }
  }

  void togglePetFilter(String petId) {
    final next = Set<String>.from(state.selectedPetIds);
    if (!next.remove(petId)) next.add(petId);
    emit(state.copyWith(selectedPetIds: next));
  }

  void toggleTypeFilter(String typeId) {
    final next = Set<String>.from(state.selectedTypeIds);
    if (!next.remove(typeId)) next.add(typeId);
    emit(state.copyWith(selectedTypeIds: next));
  }

  void clearFilters() {
    emit(state.copyWith(
      selectedPetIds: const {},
      selectedTypeIds: const {},
    ));
  }

  /// Signed urls stay valid 1h; refresh a bit early so a memoized link is
  /// never served about to expire.
  static const _signedUrlTtl = Duration(minutes: 45);
  final Map<String, ({String url, DateTime expiresAt})> _signedUrls = {};

  /// Resolves a signed url for [assetPath], memoized until [_signedUrlTtl].
  Future<String> imageUrl(String assetPath) async {
    final cached = _signedUrls[assetPath];
    if (cached != null && DateTime.now().isBefore(cached.expiresAt)) {
      return cached.url;
    }
    final url = await _eventRepository.signedImageUrl(assetPath);
    _signedUrls[assetPath] = (
      url: url,
      expiresAt: DateTime.now().add(_signedUrlTtl),
    );
    return url;
  }

  Future<String?> deleteEvent(String eventId) async {
    try {
      await _eventRepository.deleteEvent(eventId);
      return null;
    } on RepositoryException catch (e) {
      return e.message;
    } catch (_) {
      return 'Impossible de supprimer le souvenir.';
    }
  }

  @override
  Future<void> close() {
    _eventsSubscription?.cancel();
    _petEventsSubscription?.cancel();
    _imagesSubscription?.cancel();
    return super.close();
  }
}

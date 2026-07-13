import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/core/utils/vaccine_status.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/auth/data/auth_repository.dart';
import 'package:nanimo/features/auth/data/models/user_model.dart';
import 'package:nanimo/features/event/data/event_repository.dart';
import 'package:nanimo/features/event/data/models/event_model.dart';
import 'package:nanimo/features/health/data/health_repository.dart';
import 'package:nanimo/features/health/data/models/health_diary_model.dart';
import 'package:nanimo/features/health/data/models/health_diary_vaccine_model.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PetRepository _petRepository;
  final ReferentialRepository _referentialRepository;
  final EventRepository _eventRepository;
  final HealthRepository _healthRepository;
  final AuthRepository _authRepository;

  StreamSubscription<List<PetModel>>? _petsSubscription;
  StreamSubscription<List<EventModel>>? _eventsSubscription;
  StreamSubscription<Map<String, List<String>>>? _petEventsSubscription;
  StreamSubscription<Map<String, List<String>>>? _imagesSubscription;
  StreamSubscription<List<HealthDiaryModel>>? _diariesSubscription;
  StreamSubscription<List<HealthDiaryVaccineModel>>? _vaccinesSubscription;
  StreamSubscription<UserModel?>? _userSubscription;

  HomeCubit({
    required PetRepository petRepository,
    required ReferentialRepository referentialRepository,
    required EventRepository eventRepository,
    required HealthRepository healthRepository,
    required AuthRepository authRepository,
  })  : _petRepository = petRepository,
        _referentialRepository = referentialRepository,
        _eventRepository = eventRepository,
        _healthRepository = healthRepository,
        _authRepository = authRepository,
        super(const HomeState()) {
    _petsSubscription = _petRepository.watchPets().listen(_onPetsChanged);
    _eventsSubscription =
        _eventRepository.watchEvents().listen(_onEventsChanged);
    _petEventsSubscription =
        _eventRepository.watchPetEvents().listen(_onPetEventsChanged);
    _imagesSubscription =
        _eventRepository.watchAllImages().listen(_onImagesChanged);
    _diariesSubscription =
        _healthRepository.watchAllDiaries().listen(_onDiariesChanged);
    _vaccinesSubscription =
        _healthRepository.watchAllVaccines().listen(_onVaccinesChanged);
    _userSubscription =
        _authRepository.watchCurrentUser().listen(_onUserChanged);
    _loadSpecies();
  }

  /// Refreshes the pet list on change
  void _onPetsChanged(List<PetModel> pets) {
    emit(state.copyWith(status: HomeStatus.loaded, pets: pets));
  }

  void _onEventsChanged(List<EventModel> events) {
    emit(state.copyWith(events: events));
  }

  void _onPetEventsChanged(Map<String, List<String>> petIdsByEvent) {
    emit(state.copyWith(petIdsByEvent: petIdsByEvent));
  }

  void _onImagesChanged(Map<String, List<String>> imagePathsByEvent) {
    emit(state.copyWith(imagePathsByEvent: imagePathsByEvent));
  }

  void _onDiariesChanged(List<HealthDiaryModel> diaries) {
    emit(state.copyWith(diaries: diaries));
  }

  void _onVaccinesChanged(List<HealthDiaryVaccineModel> vaccines) {
    emit(state.copyWith(vaccines: vaccines));
  }

  void _onUserChanged(UserModel? user) {
    final name = user?.userName.trim();
    if (name == null || name.isEmpty) return;
    emit(state.copyWith(userName: name));
  }

  /// Loads the species and icon
  Future<void> _loadSpecies() async {
    try {
      final species = await _referentialRepository.fetchSpecies();
      if (isClosed) return;
      emit(state.copyWith(
        iconsKey: {
          for (final s in species) s.petSpeciesId: s.iconKey,
        },
      ));
    } catch (_) {}
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

  @override
  Future<void> close() {
    _petsSubscription?.cancel();
    _eventsSubscription?.cancel();
    _petEventsSubscription?.cancel();
    _imagesSubscription?.cancel();
    _diariesSubscription?.cancel();
    _vaccinesSubscription?.cancel();
    _userSubscription?.cancel();
    return super.close();
  }
}

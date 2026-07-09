import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nanimo/data/repositories/referential_repository.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final PetRepository _petRepository;
  final ReferentialRepository _referentialRepository;

  StreamSubscription<List<PetModel>>? _petsSubscription;

  HomeCubit({
    required PetRepository petRepository,
    required ReferentialRepository referentialRepository,
  })  : _petRepository = petRepository,
        _referentialRepository = referentialRepository,
        super(const HomeState()) {
    _petsSubscription = _petRepository.watchPets().listen(_onPetsChanged);
    _loadSpecies();
  }

  /// Refreshes the pet list on change
  void _onPetsChanged(List<PetModel> pets) {
    emit(state.copyWith(status: HomeStatus.loaded, pets: pets));
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

  @override
  Future<void> close() {
    _petsSubscription?.cancel();
    return super.close();
  }
}

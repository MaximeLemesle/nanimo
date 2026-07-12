import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/event_type_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_species_cache.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Stat data (species, event types) is cached in Isar
class ReferentialRepository {
  final SupabaseClient _supabase;
  final Isar? _isar;

  ReferentialRepository(this._supabase, [this._isar]);

  /// Loading pet species
  Future<List<PetSpeciesModel>> fetchSpecies() async {
    try {
      final response = await _supabase.from('pet_species').select();
      final species = (response as List).map((element) => PetSpeciesModel.fromJson(element)).toList();
      await _cacheSpecies(species);
      return species;
    } catch (err) {
      final cached = await _cachedSpecies();
      if (cached.isNotEmpty) return cached;
      throw Exception('Erreur chargement des espèces : $err');
    }
  }

  Future<void> _cacheSpecies(List<PetSpeciesModel> species) async {
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.petSpeciesCaches.clear();
      await isar.petSpeciesCaches.putAll(
        species.map(PetSpeciesCache.fromModel).toList(),
      );
    });
  }

  Future<List<PetSpeciesModel>> _cachedSpecies() async {
    final isar = _isar;
    if (isar == null) return const [];
    final rows = await isar.petSpeciesCaches.where().findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  /// Loading pet races
  Future<List<PetRaceModel>> fetchRacesBySpecies(String petSpeciesId) async {
    try {
      final response = await _supabase.from('pet_race').select().eq('pet_species_id', petSpeciesId).order('pet_race_name');

      return (response as List).map((element) => PetRaceModel.fromJson(element)).toList();
    } catch (err) {
      throw Exception('Erreur chargement des races : $err');
    }
  }

  /// Loading event types
  Future<List<EventTypeModel>> fetchEventTypes() async {
    try {
      final response = await _supabase.from('event_type').select().order('name');
      final types = (response as List).map((element) => EventTypeModel.fromJson(element)).toList();
      await _cacheEventTypes(types);
      return types;
    } catch (err) {
      final cached = await _cachedEventTypes();
      if (cached.isNotEmpty) return cached;
      throw Exception('Erreur chargement des types d\'événement : $err');
    }
  }

  Future<void> _cacheEventTypes(List<EventTypeModel> types) async {
    final isar = _isar;
    if (isar == null) return;
    await isar.writeTxn(() async {
      await isar.eventTypeCaches.clear();
      await isar.eventTypeCaches.putAll(
        types.map(EventTypeCache.fromModel).toList(),
      );
    });
  }

  Future<List<EventTypeModel>> _cachedEventTypes() async {
    final isar = _isar;
    if (isar == null) return const [];
    final rows = await isar.eventTypeCaches.where().sortByName().findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  /// Loading recommended vaccines for a species
  Future<List<RecommendedVaccineModel>> fetchRecommendedVaccinesBySpecies(
    String petSpeciesId,
  ) async {
    try {
      final response = await _supabase.from('recommended_vaccines').select().eq('pet_species_id', petSpeciesId).order('name');

      return (response as List).map((element) => RecommendedVaccineModel.fromJson(element)).toList();
    } catch (err) {
      throw Exception('Erreur chargement des vaccins recommandés : $err');
    }
  }
}

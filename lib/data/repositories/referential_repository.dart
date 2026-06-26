import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
import 'package:nanimo/features/event/data/models/event_type_model.dart';
import 'package:nanimo/features/health/data/models/recommended_vaccines_model.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ReferentialRepository {
  final SupabaseClient _supabase;

  ReferentialRepository(this._supabase);

  /// Loading pet species
  Future<List<PetSpeciesModel>> fetchSpecies() async {
    try {
      final response = await _supabase.from('pet_species').select();
      return (response as List)
          .map((element) => PetSpeciesModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargement des espèces : $err');
    }
  }

  /// Loading pet races
  Future<List<PetRaceModel>> fetchRacesBySpecies(String petSpeciesId) async {
    try {
      final response = await _supabase
          .from('pet_race')
          .select()
          .eq('pet_species_id', petSpeciesId)
          .order('pet_race_name');

      return (response as List)
          .map((element) => PetRaceModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargement des races : $err');
    }
  }

  /// Loading event types
  Future<List<EventTypeModel>> fetchEventTypes() async {
    try {
      final response = await _supabase.from('event_type').select().order('name');
      return (response as List)
          .map((element) => EventTypeModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargement des types d\'événement : $err');
    }
  }

  /// Loading recommended vaccines for a species
  Future<List<RecommendedVaccineModel>> fetchRecommendedVaccinesBySpecies(
    String petSpeciesId,
  ) async {
    try {
      final response = await _supabase
          .from('recommended_vaccines')
          .select()
          .eq('pet_species_id', petSpeciesId)
          .order('name');

      return (response as List)
          .map((element) => RecommendedVaccineModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargement des vaccins recommandés : $err');
    }
  }
}

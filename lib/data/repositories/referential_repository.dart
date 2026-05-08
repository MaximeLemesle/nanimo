import 'package:nanimo/data/models/referential/pet_icon_model.dart';
import 'package:nanimo/data/models/referential/pet_race_model.dart';
import 'package:nanimo/data/models/referential/pet_species_model.dart';
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
      throw Exception('Erreur chargament des espèces : $err');
    }
  }

  /// Loading pet races
  Future<List<PetRaceModel>> fetchRacesBySpecies(String petSpeciesId) async {
    try {
      final response = await _supabase
          .from('pet_race')
          .select()
          .eq('pet_species_id', petSpeciesId);

      return (response as List)
          .map((element) => PetRaceModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargament des races : $err');
    }
  }

  /// Loading pet icons
  Future<List<PetIconModel>> fetchIconsBySpecies(String petSpeciesId) async {
    try {
      final response = await _supabase
          .from('pet_icons')
          .select()
          .eq('pet_species_id', petSpeciesId);

      return (response as List)
          .map((element) => PetIconModel.fromJson(element))
          .toList();
    } catch (err) {
      throw Exception('Erreur chargament des icônes : $err');
    }
  }
}

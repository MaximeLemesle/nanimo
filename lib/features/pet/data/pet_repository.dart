import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

/// Reads always hit Isar so the UI is instant and works offline. Supabase is
/// kept fresh by [SyncService] at app start. Writes go to Supabase first; on
/// success the cache is updated, on failure a [RepositoryNetworkException] is thrown.
class PetRepository {
  final SupabaseClient _supabase;
  final Isar _isar;

  PetRepository(this._supabase, this._isar);

  /// Live stream of pets from the local cache. Emits on every Isar write so
  /// the UI updates immediately after a create/update/delete.
  Stream<List<PetModel>> watchPets() {
    return _isar.petCaches
        .where()
        .sortByCreatedAt()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  /// One-shot read from the cache.
  Future<List<PetModel>> getPets() async {
    final rows = await _isar.petCaches.where().sortByCreatedAt().findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  /// One-shot read of a single pet.
  Future<PetModel?> getPetById(String petId) async {
    final row = await _isar.petCaches.getByPetId(petId);
    return row?.toModel();
  }

  /// Inserts a new pet. Supabase is the source of truth.
  /// If insert fails (no network, etc.), the cache is left 
  /// untouched and the caller gets a [RepositoryNetworkException].
  Future<void> createPet(PetModel pet) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const RepositoryNetworkException(
        'Vous devez être connecté pour créer un animal.',
      );
    }

    try {
      await _supabase.from('pets').insert(pet.toJson());
      await _supabase.from('users_pets').insert({
        'user_id': userId,
        'pet_id': pet.petId,
      });
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour créer un animal.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.petCaches.putByPetId(PetCache.fromModel(pet));
    });
  }

  /// Updates an existing pet. Same write-through guarantees as [createPet].
  Future<void> updatePet(PetModel pet) async {
    try {
      await _supabase.from('pets').update(pet.toJson()).eq('id_pet', pet.petId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour mettre à jour un animal.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.petCaches.putByPetId(PetCache.fromModel(pet));
    });
  }

  /// Deletes a pet. CASCADE on the Supabase side handles related rows; the
  /// next sync wave clears the orphan caches locally.
  Future<void> deletePet(String petId) async {
    try {
      await _supabase.from('pets').delete().eq('id_pet', petId);
    } catch (_) {
      throw const RepositoryNetworkException(
        'Une connexion internet est requise pour supprimer un animal.',
      );
    }

    await _isar.writeTxn(() async {
      await _isar.petCaches.deleteByPetId(petId);
    });
  }
}

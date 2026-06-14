import 'package:isar/isar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';

class PetRepository {
  final SupabaseClient _supabase;
  final Isar _isar;
  final int _writeRetryAttempts;
  final Duration _writeRetryBackoff;

  PetRepository(
    this._supabase,
    this._isar, {
    int writeRetryAttempts = 3,
    Duration writeRetryBackoff = const Duration(milliseconds: 400),
  })  : _writeRetryAttempts = writeRetryAttempts,
        _writeRetryBackoff = writeRetryBackoff;

  Stream<List<PetModel>> watchPets() {
    return _isar.petCaches
        .where()
        .sortByCreatedAt()
        .watch(fireImmediately: true)
        .map((rows) => rows.map((c) => c.toModel()).toList());
  }

  Future<List<PetModel>> getPets() async {
    final rows = await _isar.petCaches.where().sortByCreatedAt().findAll();
    return rows.map((c) => c.toModel()).toList();
  }

  Future<PetModel?> getPetById(String petId) async {
    final row = await _isar.petCaches.getByPetId(petId);
    return row?.toModel();
  }

  Future<void> createPet(PetModel pet) async {
    final userId = _supabase.auth.currentUser?.id;
    if (userId == null) {
      throw const RepositoryNetworkException(
        'Vous devez être connecté pour créer un animal.',
      );
    }

    await _writeWithRetry(() async {
      await _insertIgnoringDuplicate('pets', pet.toJson());
      await _insertIgnoringDuplicate('users_pets', {
        'user_id': userId,
        'pet_id': pet.petId,
      });
    });

    await _isar.writeTxn(() async {
      await _isar.petCaches.putByPetId(PetCache.fromModel(pet));
    });
  }

  Future<void> _insertIgnoringDuplicate(
    String table,
    Map<String, dynamic> values,
  ) async {
    try {
      await _supabase.from(table).insert(values);
    } on PostgrestException catch (e) {
      if (e.code == '23505') return;
      rethrow;
    }
  }

  Future<void> _writeWithRetry(Future<void> Function() write) async {
    for (var attempt = 1;; attempt++) {
      try {
        await write();
        return;
      } catch (_) {
        if (attempt >= _writeRetryAttempts) {
          throw const RepositoryNetworkException(
            'Une connexion internet est requise pour créer un animal.',
          );
        }
        await Future<void>.delayed(_writeRetryBackoff * attempt);
      }
    }
  }

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

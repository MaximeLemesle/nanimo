import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';

import '../../../helpers/isar_test_helper.dart';
import '../../../helpers/supabase_mocks.dart';

PetModel buildPet(
  String id,
  String name, {
  DateTime? createdAt,
}) {
  return PetModel(
    petId: id,
    petName: name,
    birthdate: DateTime.utc(2020, 1, 1),
    gender: Gender.male,
    createdAt: createdAt ?? DateTime.utc(2024, 1, 1),
    petRaceId: 'race-1',
    petSpeciesId: 'sp-1',
  );
}

void main() {
  final harness = IsarTestHarness();
  late PetRepository repo;

  setUp(() async {
    await harness.setUp();
    repo = PetRepository(MockSupabaseClient(), harness.isar);
  });

  tearDown(() async {
    await harness.tearDown();
  });

  Future<void> seed(PetModel model) async {
    await harness.isar.writeTxn(() async {
      await harness.isar.petCaches.putByPetId(PetCache.fromModel(model));
    });
  }

  group('watchPets', () {
    test('emits an empty list when the cache is empty', () async {
      final emission = await repo.watchPets().first;
      expect(emission, isEmpty);
    });

    test('emits cached pets sorted by createdAt ascending', () async {
      await seed(buildPet('p2', 'Felix', createdAt: DateTime.utc(2024, 6, 1)));
      await seed(buildPet('p1', 'Rex', createdAt: DateTime.utc(2024, 1, 1)));

      final emission = await repo.watchPets().first;
      expect(emission.map((p) => p.petId).toList(), ['p1', 'p2']);
    });
  });

  group('getPets', () {
    test('returns empty when the cache is empty', () async {
      expect(await repo.getPets(), isEmpty);
    });

    test('returns cached pets sorted by createdAt ascending', () async {
      await seed(buildPet('p2', 'Felix', createdAt: DateTime.utc(2024, 6, 1)));
      await seed(buildPet('p1', 'Rex', createdAt: DateTime.utc(2024, 1, 1)));

      final result = await repo.getPets();
      expect(result.map((p) => p.petId).toList(), ['p1', 'p2']);
    });
  });

  group('getPetById', () {
    test('returns null when missing', () async {
      expect(await repo.getPetById('missing'), isNull);
    });

    test('returns the cached pet when present', () async {
      await seed(buildPet('p1', 'Rex'));

      final result = await repo.getPetById('p1');
      expect(result, isNotNull);
      expect(result!.petName, 'Rex');
    });
  });
}

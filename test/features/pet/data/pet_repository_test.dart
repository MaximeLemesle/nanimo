import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:nanimo/core/errors/repository_network_exception.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/pet/data/pet_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  setUpAll(registerSupabaseFallbacks);

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

  group('createPet', () {
    late MockSupabaseClient supabase;
    late PetRepository createRepo;

    void buildAuthenticatedRepo({String userId = 'user-1'}) {
      supabase = MockSupabaseClient();
      final auth = MockGoTrueClient();
      final user = MockUser();
      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(user);
      when(() => user.id).thenReturn(userId);
      createRepo = PetRepository(
        supabase,
        harness.isar,
        writeRetryBackoff: Duration.zero,
      );
    }

    test('throws when no user is authenticated', () async {
      supabase = MockSupabaseClient();
      final auth = MockGoTrueClient();
      when(() => supabase.auth).thenReturn(auth);
      when(() => auth.currentUser).thenReturn(null);
      createRepo = PetRepository(supabase, harness.isar);

      await expectLater(
        createRepo.createPet(buildPet('p1', 'Rex')),
        throwsA(isA<RepositoryNetworkException>()),
      );
      expect(await createRepo.getPetById('p1'), isNull);
    });

    test('inserts pet + link and caches it on the happy path', () async {
      buildAuthenticatedRepo();
      stubInsert(supabase, 'pets', resolver: () => null);
      stubInsert(supabase, 'users_pets', resolver: () => null);

      await createRepo.createPet(buildPet('p1', 'Milo'));

      final cached = await createRepo.getPetById('p1');
      expect(cached, isNotNull);
      expect(cached!.petName, 'Milo');
    });

    test('retries past the post-signup race and succeeds, caching the pet',
        () async {
      buildAuthenticatedRepo();
      stubInsert(supabase, 'pets', resolver: () => null);
      var linkAttempts = 0;
      stubInsert(supabase, 'users_pets', resolver: () {
        linkAttempts++;
        if (linkAttempts == 1) {
          throw Exception('insert or update on table "users_pets" violates FK');
        }
        return null;
      });

      await createRepo.createPet(buildPet('p1', 'Milo'));

      expect(linkAttempts, 2);
      expect(await createRepo.getPetById('p1'), isNotNull);
    });

    test('throws and leaves the cache untouched after exhausting retries',
        () async {
      buildAuthenticatedRepo();
      stubInsert(supabase, 'pets', resolver: () => null);
      stubInsert(
        supabase,
        'users_pets',
        resolver: () => throw Exception('FK violation'),
      );

      await expectLater(
        createRepo.createPet(buildPet('p1', 'Milo')),
        throwsA(isA<RepositoryNetworkException>()),
      );
      expect(await createRepo.getPetById('p1'), isNull);
    });

    test('ignores a duplicate-key insert and caches the pet', () async {
      buildAuthenticatedRepo();
      stubInsert(supabase, 'pets',
          resolver: () =>
              throw const PostgrestException(message: 'dup', code: '23505'));
      stubInsert(supabase, 'users_pets', resolver: () => null);

      await createRepo.createPet(buildPet('p1', 'Milo'));

      expect(await createRepo.getPetById('p1'), isNotNull);
    });
  });

  group('updatePet', () {
    late MockSupabaseClient supabase;
    late PetRepository petRepo;

    setUp(() {
      supabase = MockSupabaseClient();
      petRepo = PetRepository(supabase, harness.isar);
    });

    test('updates Supabase then refreshes the cache', () async {
      await seed(buildPet('p1', 'Ancien'));
      stubUpdate(supabase, 'pets', resolver: () => null);

      await petRepo.updatePet(buildPet('p1', 'Nouveau'));

      expect((await petRepo.getPetById('p1'))!.petName, 'Nouveau');
    });

    test('throws a network exception on failure', () async {
      stubUpdate(supabase, 'pets', resolver: () => throw Exception('offline'));

      await expectLater(
        petRepo.updatePet(buildPet('p1', 'Milo')),
        throwsA(isA<RepositoryNetworkException>()),
      );
    });
  });

  group('deletePet', () {
    late MockSupabaseClient supabase;
    late PetRepository petRepo;

    setUp(() {
      supabase = MockSupabaseClient();
      petRepo = PetRepository(supabase, harness.isar);
    });

    test('deletes from Supabase and removes it from the cache', () async {
      await seed(buildPet('p1', 'Milo'));
      stubDelete(supabase, 'pets', resolver: () => null);

      await petRepo.deletePet('p1');

      expect(await petRepo.getPetById('p1'), isNull);
    });

    test('throws and keeps the cache when Supabase fails', () async {
      await seed(buildPet('p1', 'Milo'));
      stubDelete(supabase, 'pets', resolver: () => throw Exception('offline'));

      await expectLater(
        petRepo.deletePet('p1'),
        throwsA(isA<RepositoryNetworkException>()),
      );
      expect(await petRepo.getPetById('p1'), isNotNull);
    });
  });
}

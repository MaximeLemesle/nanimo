import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';
import 'package:nanimo/core/isar/cache/schemas/user_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/pet_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/event_image_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/health_diary_vaccine_cache.dart';
import 'package:nanimo/core/isar/cache/schemas/weight_log_cache.dart';

void main() {
  setUpAll(() async {
    await Isar.initializeIsarCore(download: true);
  });

  group('Isar schemas', () {
    late Directory tempDir;
    late Isar isar;

    setUp(() async {
      tempDir = Directory.systemTemp.createTempSync('isar_test_');
      isar = await Isar.open(
        [
          UserCacheSchema,
          PetCacheSchema,
          EventCacheSchema,
          EventImageCacheSchema,
          HealthDiaryCacheSchema,
          HealthDiaryVaccineCacheSchema,
          WeightLogCacheSchema,
        ],
        directory: tempDir.path,
      );
    });

    tearDown(() async {
      await isar.close();
      tempDir.deleteSync(recursive: true);
    });

    test('opens with all schemas without throwing', () {
      expect(isar.isOpen, true);
    });

    test('can write and read a UserCache', () async {
      final user = UserCache.fromJson({
        'id_user': 'test-uuid',
        'user_name': 'Test User',
        'mail': 'test@example.com',
        'subscription_status': 'free',
        'subscription_expires_at': null,
      });

      await isar.writeTxn(() async {
        await isar.userCaches.putByIdUser(user);
      });

      final result = await isar.userCaches.getByIdUser('test-uuid');
      expect(result, isNotNull);
      expect(result!.mail, 'test@example.com');
    });

    test('can write and read a PetCache', () async {
      final pet = PetCache.fromJson({
        'id_pet': 'pet-uuid',
        'pet_name': 'Buddy',
        'birthdate': null,
        'gender': 'male',
        'id_race': null,
        'id_species': null,
        'id_icon': null,
        'created_at': '2024-01-01T00:00:00.000Z',
      });

      await isar.writeTxn(() async {
        await isar.petCaches.putByIdPet(pet);
      });

      final result = await isar.petCaches.getByIdPet('pet-uuid');
      expect(result, isNotNull);
      expect(result!.petName, 'Buddy');
    });
  });
}

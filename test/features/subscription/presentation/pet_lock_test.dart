import 'package:flutter_test/flutter_test.dart';
import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/subscription/data/models/subscription_config_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';
import 'package:nanimo/features/subscription/presentation/pet_lock.dart';

PetModel _pet(String id, DateTime createdAt) => PetModel(
      petId: id,
      petName: id,
      birthdate: DateTime(2024, 1, 1),
      gender: Gender.female,
      createdAt: createdAt,
      petRaceId: 'r',
      petSpeciesId: 's',
    );

SubscriptionState _plan(String planName, int maxPets) =>
    SubscriptionState.loaded(SubscriptionConfigModel(
      configId: 'cfg',
      planName: planName,
      maxImagesPerEvent: 1,
      maxPets: maxPets,
    ));

final _first = _pet('first', DateTime(2025, 1, 1));
final _second = _pet('second', DateTime(2025, 6, 1));
final _third = _pet('third', DateTime(2026, 2, 1));

/// NAN-082: every animal stays on screen, only the covered ones stay writable.
void main() {
  group('PetLock.lockedPetIds', () {
    test('locks nothing while the plan covers everything', () {
      expect(
        PetLock.lockedPetIds([_first, _second], _plan('premium', 10)),
        isEmpty,
      );
    });

    test('locks nothing on a single animal and a free plan', () {
      expect(PetLock.lockedPetIds([_first], _plan('freemium', 1)), isEmpty);
    });

    test('keeps the oldest and locks the rest', () {
      expect(
        PetLock.lockedPetIds([_first, _second, _third], _plan('freemium', 1)),
        {'second', 'third'},
      );
    });

    /// Arrival order decides, not the order the list happens to arrive in.
    test('does not depend on the order of the list', () {
      expect(
        PetLock.lockedPetIds([_third, _first, _second], _plan('freemium', 1)),
        {'second', 'third'},
      );
    });

    /// A wrongly locked animal is worse than a quota left open for a session.
    test('locks nothing while the plan is unknown', () {
      expect(
        PetLock.lockedPetIds(
          [_first, _second, _third],
          const SubscriptionState.unknown(),
        ),
        isEmpty,
      );
    });
  });

  group('PetLock.isLocked', () {
    test('answers for one animal', () {
      final pets = [_first, _second];
      final plan = _plan('freemium', 1);

      expect(PetLock.isLocked('first', pets, plan), isFalse);
      expect(PetLock.isLocked('second', pets, plan), isTrue);
    });
  });
}

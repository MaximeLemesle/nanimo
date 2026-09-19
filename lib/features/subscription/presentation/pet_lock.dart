import 'package:nanimo/features/pet/data/models/pet_model.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

/// Which animals a plan no longer covers: those past the quota become read
/// only, the oldest by arrival staying usable.
abstract final class PetLock {
  /// Empty while the plan is unknown, like the premium marker.
  static Set<String> lockedPetIds(
    List<PetModel> pets,
    SubscriptionState subscription,
  ) {
    if (!subscription.isLoaded) return const {};

    final max = subscription.maxPets;
    if (pets.length <= max) return const {};

    final byArrival = [...pets]
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    return {for (final pet in byArrival.skip(max)) pet.petId};
  }

  static bool isLocked(
    String petId,
    List<PetModel> pets,
    SubscriptionState subscription,
  ) =>
      lockedPetIds(pets, subscription).contains(petId);
}

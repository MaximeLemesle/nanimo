import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

/// Shown when the plan could not be loaded at all: nothing is capped, the user
/// is simply offline, so no upsell is offered.
const String subscriptionUnavailableMessage =
    'Impossible de vérifier votre abonnement. Vérifiez votre connexion, puis réessayez.';

const String upgradeActionLabel = 'Passer premium';

/// Tells the user which plan limit blocked the gesture, and opens the paywall
/// from that same spot when going premium is what lifts it.
class QuotaUpsell {
  const QuotaUpsell._();

  static bool _offersUpgrade(SubscriptionState subscription) =>
      subscription.isLoaded && !subscription.isPremium;

  static String petMessage(SubscriptionState subscription) {
    if (!subscription.isLoaded) return subscriptionUnavailableMessage;

    final max = subscription.maxPets;
    final pets = max > 1 ? 'animaux' : 'animal';
    if (subscription.isPremium) return 'Limite de $max $pets atteinte.';
    return 'Ton plan gratuit est limité à $max $pets. '
        'Passe premium pour agrandir ta famille.';
  }

  static String eventImageMessage(
    SubscriptionState subscription,
    int maxImages,
  ) {
    if (!subscription.isLoaded) return subscriptionUnavailableMessage;

    final photos = maxImages > 1 ? 'photos' : 'photo';
    if (subscription.isPremium) {
      return 'Limite de $maxImages $photos par souvenir atteinte.';
    }
    return 'Ton plan gratuit est limité à $maxImages $photos par souvenir. '
        'Passe premium pour en ajouter plus.';
  }

  static void showPetQuota(
    BuildContext context,
    SubscriptionState subscription,
  ) =>
      show(
        context,
        message: petMessage(subscription),
        withUpgrade: _offersUpgrade(subscription),
      );

  static void showEventImageQuota(
    BuildContext context,
    SubscriptionState subscription,
    int maxImages,
  ) =>
      show(
        context,
        message: eventImageMessage(subscription, maxImages),
        withUpgrade: _offersUpgrade(subscription),
      );

  /// The router is resolved now, not in the callback: the snack bar outlives
  /// the widget that raised it, and `/paywall` sits on the root navigator.
  static void show(
    BuildContext context, {
    required String message,
    required bool withUpgrade,
  }) {
    final router = GoRouter.of(context);
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          action: withUpgrade
              ? SnackBarAction(
                  label: upgradeActionLabel,
                  onPressed: () => router.push(RouteNames.paywall),
                )
              : null,
        ),
      );
  }
}

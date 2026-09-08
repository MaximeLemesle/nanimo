import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:nanimo/config/router/route_names.dart';
import 'package:nanimo/core/analytics/analytics.dart';
import 'package:nanimo/core/analytics/analytics_events.dart';
import 'package:nanimo/features/subscription/presentation/cubit/subscription_cubit.dart';

/// Shown when the plan could not be loaded at all: nothing is capped, the user
/// is simply offline, so no upsell is offered.
const String subscriptionUnavailableMessage =
    'Impossible de vérifier votre abonnement. Vérifiez votre connexion, puis réessayez.';

/// Single passage point for a plan limit that blocks a gesture: a free user is
/// taken straight to the paywall, anyone else is only told what capped them.
class QuotaUpsell {
  const QuotaUpsell._();

  /// True only when going premium is what lifts the block, which is also the
  /// only case where pushing the paywall makes sense.
  static bool offersUpgrade(SubscriptionState subscription) =>
      subscription.isLoaded && !subscription.isPremium;

  static String petMessage(SubscriptionState subscription) {
    if (!subscription.isLoaded) return subscriptionUnavailableMessage;

    final max = subscription.maxPets;
    final pets = max > 1 ? 'animaux' : 'animal';
    return 'Limite de $max $pets atteinte.';
  }

  static String eventImageMessage(
    SubscriptionState subscription,
    int maxImages,
  ) {
    if (!subscription.isLoaded) return subscriptionUnavailableMessage;

    final photos = maxImages > 1 ? 'photos' : 'photo';
    return 'Limite de $maxImages $photos par souvenir atteinte.';
  }

  static void petQuotaReached(
    BuildContext context,
    SubscriptionState subscription,
  ) =>
      _block(
        context,
        subscription,
        petMessage(subscription),
        PaywallTrigger.addPet,
      );

  static void eventImageQuotaReached(
    BuildContext context,
    SubscriptionState subscription,
    int maxImages,
  ) =>
      _block(
        context,
        subscription,
        eventImageMessage(subscription, maxImages),
        PaywallTrigger.addPhoto,
      );

  static void _block(
    BuildContext context,
    SubscriptionState subscription,
    String message,
    String trigger,
  ) {
    if (offersUpgrade(subscription)) {
      openPaywall(context, trigger);
      return;
    }
    _showMessage(context, message);
  }

  /// `/paywall` sits on the root navigator, above whatever raised the block.
  /// Every entry point goes through here so [trigger] is never lost, which is
  /// the property that says which limit actually converts.
  static void openPaywall(BuildContext context, String trigger) {
    analytics.capture(
      AnalyticsEvents.paywallOpened,
      properties: {AnalyticsProperties.trigger: trigger},
    );
    GoRouter.of(context).push(RouteNames.paywall);
  }

  static void openPaywallWith(GoRouter router, String trigger) {
    analytics.capture(
      AnalyticsEvents.paywallOpened,
      properties: {AnalyticsProperties.trigger: trigger},
    );
    router.push(RouteNames.paywall);
  }

  static void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..clearSnackBars()
      ..showSnackBar(SnackBar(content: Text(message)));
  }
}

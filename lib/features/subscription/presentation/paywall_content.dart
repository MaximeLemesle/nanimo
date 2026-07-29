import 'package:flutter/material.dart';

/// Selling points shown on the paywall.
///
/// The numbers mirror the `subscription_config` rows (migration 0007). They are
/// duplicated here on purpose: a paywall that waits for a network read to show
/// its own promise is a paywall nobody converts on. **If the quotas change in
/// the database, change them here in the same commit.**
///
/// Nothing that is not shipped may be listed. Premium icons and PDF export were
/// deliberately left out: selling a feature that does not exist yet is a refund
/// request, not an argument.
class PaywallBenefit {
  final IconData icon;
  final String title;
  final String subtitle;

  const PaywallBenefit({
    required this.icon,
    required this.title,
    required this.subtitle,
  });
}

const List<PaywallBenefit> paywallBenefits = [
  PaywallBenefit(
    icon: Icons.pets_rounded,
    title: 'Jusqu’à 10 animaux',
    subtitle: 'Toute la famille dans une seule application, au lieu d’un seul animal.',
  ),
  PaywallBenefit(
    icon: Icons.photo_library_rounded,
    title: '5 photos par souvenir',
    subtitle: 'Racontez un moment en plusieurs images, au lieu d’une seule.',
  ),
  PaywallBenefit(
    icon: Icons.cloud_done_rounded,
    title: 'Plus d’espace de stockage',
    subtitle: 'De quoi garder les souvenirs de toute une vie.',
  ),
];

/// Legal pages, published from Notion.
///
/// Apple rejects a subscription screen that does not link to both. They are
/// constants rather than a remote config on purpose: a paywall that cannot
/// reach the network must still show them.
const String termsUrl =
    'https://plain-ant-39c.notion.site/Conditions-g-n-rales-d-utilisation-de-Nanimo-3ac8fef1b0fc81ce9b5ae88a4a31e7a6';

const String privacyUrl =
    'https://plain-ant-39c.notion.site/Politique-de-confidentialit-de-Nanimo-3ac8fef1b0fc81ffbc59ca2c47c58743';

/// Wording required by the stores on any auto-renewing subscription screen.
const String paywallLegalNotice =
    'Abonnement à renouvellement automatique. Le paiement est débité sur votre '
    'compte à la confirmation de l’achat, puis à chaque échéance tant que vous '
    'ne résiliez pas. Vous pouvez résilier à tout moment depuis les réglages de '
    'votre compte App Store ou Google Play, au plus tard 24 h avant la fin de '
    'la période en cours.';

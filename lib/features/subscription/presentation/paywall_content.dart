import 'package:flutter/material.dart';

class PaywallBenefit {
  final IconData icon;
  final String subtitle;
  final String title;

  const PaywallBenefit({
    required this.icon,
    required this.subtitle,
    required this.title,
  });
}

const String paywallTitle = 'Nanimo Premium';
const String paywallTagline = 'Toute la mémoire de ton animal';

const List<PaywallBenefit> paywallBenefits = [
  PaywallBenefit(
    icon: Icons.photo_library_rounded,
    subtitle: '5 photos par souvenir',
    title: 'aucun instant ne t’échappe',
  ),
  PaywallBenefit(
    icon: Icons.pets_rounded,
    subtitle: 'Ta famille peut grandir',
    title: '10 animaux, un seul journal',
  ),
];

const String termsUrl = 'https://plain-ant-39c.notion.site/Conditions-g-n-rales-d-utilisation-de-Nanimo-5ee8fef1b0fc83f59a4101c2099fb2b9';

const String privacyUrl = 'https://plain-ant-39c.notion.site/Politique-de-confidentialit-de-Nanimo-d308fef1b0fc82aeab2181cb868647b3';

const String paywallLegalNotice =
    'Ton abonnement est renouvelé automatiquement à chaque échéance. Tu peux le résilier à tout moment depuis les réglages de ton compte App Store ou Google Play, au plus tard 24 h avant la fin de la période en cours.';

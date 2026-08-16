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
const String paywallTagline = 'Profite de Nanimo à 100% !';

const List<PaywallBenefit> paywallBenefits = [
  PaywallBenefit(
    icon: Icons.pets_rounded,
    subtitle: 'Agrandis ta famille',
    title: 'jusqu’à 10 animaux',
  ),
  PaywallBenefit(
    icon: Icons.photo_library_rounded,
    subtitle: 'Créer des souvenirs',
    title: 'avec 5 photos',
  ),
];

const String termsUrl = 'https://plain-ant-39c.notion.site/Conditions-g-n-rales-d-utilisation-de-Nanimo-5ee8fef1b0fc83f59a4101c2099fb2b9';

const String privacyUrl = 'https://plain-ant-39c.notion.site/Politique-de-confidentialit-de-Nanimo-d308fef1b0fc82aeab2181cb868647b3';

const String paywallLegalNotice =
    'Ton abonnement est renouvelé automatiquement à chaque échéance. Tu peux le résilier à tout moment depuis les réglages de ton compte App Store ou Google Play, au plus tard 24 h avant la fin de la période en cours.';

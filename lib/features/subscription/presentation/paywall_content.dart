import 'package:nanimo/features/subscription/data/models/paywall_offer_model.dart';

class PaywallBenefit {
  final String subtitle;
  final String title;

  const PaywallBenefit({
    required this.subtitle,
    required this.title,
  });
}

const String paywallTitle = 'Nanimo Premium';
const String paywallTagline = 'Toute la place que mérite ta famille';

const List<PaywallBenefit> paywallBenefits = [
  PaywallBenefit(
    subtitle: 'Ne rate aucun instant',
    title: 'avec 5 photos',
  ),
  PaywallBenefit(
    subtitle: 'Agrandis ta famille',
    title: 'jusqu’à 10 animaux',
  ),
];

const String termsUrl = 'https://plain-ant-39c.notion.site/Conditions-g-n-rales-d-utilisation-de-Nanimo-5ee8fef1b0fc83f59a4101c2099fb2b9';

const String privacyUrl = 'https://plain-ant-39c.notion.site/Politique-de-confidentialit-de-Nanimo-d308fef1b0fc82aeab2181cb868647b3';

const String _cancellationNotice =
    'Renouvelé automatiquement, résiliable à tout moment depuis les réglages de ton compte App Store ou Google Play, au plus tard 24 h avant la fin de la période en cours.';

/// What the selected plan will charge and when, as the stores require it.
String paywallLegalNotice(PaywallOfferModel? offer) {
  if (offer == null) return _cancellationNotice;
  final price = '${offer.priceLabel} ${offer.periodLabel}'.trim();
  if (offer.hasTrial) return '${offer.trialDays} jours gratuits, puis $price. $_cancellationNotice';
  return '$price. $_cancellationNotice';
}

/// The CTA promises nothing the card does not already say.
const String paywallCta = 'Continuer';
const String paywallNoThanks = 'Non merci';

/// Shown while the webhook makes its way to Supabase
const String premiumConfirmingTitle = 'On active ton abonnement';

const String premiumConfirmingSubtitle = 'Encore quelques secondes, on prépare toute la place pour ta famille.';

const String premiumWelcomeTitle = 'Merci !';

const String premiumWelcomeSubtitle = 'Tu fais désormais partie de Nanimo Premium. Ta famille a toute la place qu’elle mérite.';

/// A purchase whose webhook has not landed yet leaves the app on freemium quotas,
/// and a relaunch is the one gesture that fixes it from the user's side.
const String premiumWelcomeNotice = 'Si jamais tu n’as pas encore accès aux fonctionnalités premium, ferme et rouvre l’application.';

const String premiumWelcomeCta = 'Ajouter un animal';

const String premiumWelcomeSecondaryCta = 'Revenir à l’accueil';

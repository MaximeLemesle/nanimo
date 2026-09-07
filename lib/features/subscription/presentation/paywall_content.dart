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

const String paywallLegalNotice =
    'Ton abonnement est renouvelé automatiquement à chaque échéance. Tu peux le résilier à tout moment depuis les réglages de ton compte App Store ou Google Play, au plus tard 24 h avant la fin de la période en cours.';

/// Shown while the webhook makes its way to Supabase. The user has just paid,
/// so this text has one job: prove the app is doing something.
const String premiumConfirmingTitle = 'On active ton abonnement';

const String premiumConfirmingSubtitle =
    'Encore quelques secondes, on prépare toute la place pour ta famille.';

const String premiumWelcomeTitle = 'Merci !';

const String premiumWelcomeSubtitle =
    'Tu fais désormais partie de Nanimo Premium. Ta famille a toute la place qu’elle mérite.';

/// Shown to everyone, discreetly. A purchase whose webhook has not landed yet
/// leaves the app on freemium quotas, and a relaunch is the one gesture that
/// fixes it from the user's side. Saying it once here is cheaper than a support
/// message, and it costs nothing to the user whose purchase went through.
const String premiumWelcomeNotice =
    'Si jamais tu n’as pas encore accès aux fonctionnalités premium, ferme et rouvre l’application.';

const String premiumWelcomeCta = 'Ajouter un animal';

const String premiumWelcomeSecondaryCta = 'Revenir à l’accueil';

/// Event vocabulary. Names are snake_case and never change once shipped: a
/// rename splits a funnel in two and silently breaks every saved insight.
class AnalyticsEvents {
  const AnalyticsEvents._();

  static const onboardingStarted = 'onboarding_started';
  static const onboardingStepCompleted = 'onboarding_step_completed';
  static const accountCreated = 'account_created';
  static const authCompleted = 'auth_completed';
  static const petCreated = 'pet_created';
  static const petCreationFailed = 'pet_creation_failed';
  static const memoryCreated = 'memory_created';

  static const paywallOpened = 'paywall_opened';
  static const paywallOfferSelected = 'paywall_offer_selected';
  static const purchaseStarted = 'purchase_started';
  static const purchaseCompleted = 'purchase_completed';
  static const purchaseCancelled = 'purchase_cancelled';
  static const purchaseFailed = 'purchase_failed';
  static const restoreStarted = 'restore_started';
  static const restoreFinished = 'restore_finished';

  /// The webhook is asynchronous, so a purchase can be paid but unconfirmed.
  /// These two say how often that happens in production, and if it self-heals.
  static const premiumConfirmationTimeout = 'premium_confirmation_timeout';
  static const premiumConfirmationRecovered = 'premium_confirmation_recovered';
}

class AnalyticsProperties {
  const AnalyticsProperties._();

  static const step = 'step';
  static const method = 'method';
  static const trigger = 'trigger';
  static const plan = 'plan';
  static const reason = 'reason';
  static const photoCount = 'photo_count';
  static const petCount = 'pet_count';
  static const confirmed = 'confirmed';
  static const restored = 'restored';
  static const source = 'source';
}

/// What blocked the user right before the paywall opened. This is the property
/// that says which limit actually sells, so it is never omitted.
class PaywallTrigger {
  const PaywallTrigger._();

  static const addPet = 'add_pet';
  static const addPhoto = 'add_photo';
  static const multiSelectPhotos = 'multi_select_photos';
  static const settingsButton = 'settings_button';
  static const notifications = 'notifications';
  static const unknown = 'unknown';
}

class AuthMethod {
  const AuthMethod._();

  static const email = 'email';
  static const google = 'google';
  static const apple = 'apple';
}

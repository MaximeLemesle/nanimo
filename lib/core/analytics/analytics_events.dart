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

  static const vaccineCreated = 'vaccine_created';
  static const vetVisitCreated = 'vet_visit_created';
  static const reminderScheduled = 'reminder_scheduled';
  static const notificationOpened = 'notification_opened';
  static const notificationPermission = 'notification_permission';
  static const checklistItemCompleted = 'checklist_item_completed';

  /// The two screens before the onboarding paywall (NAN-113).
  static const trialIntroViewed = 'trial_intro_viewed';
  static const trialReminderViewed = 'trial_reminder_viewed';

  static const paywallOpened = 'paywall_opened';
  static const paywallOfferSelected = 'paywall_offer_selected';

  /// Tells a deliberate "Non merci" apart from the close button.
  static const paywallDismissed = 'paywall_dismissed';
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
  static const upcoming = 'upcoming';
  static const item = 'item';
  static const result = 'result';
  static const kind = 'kind';
  static const skipped = 'skipped';

  /// Person properties, set on the profile rather than on one event.
  static const hasVaccine = 'has_vaccine';
  static const isPremium = 'is_premium';
}

/// Tells a first onboarding apart from an animal added later from the app.
class OnboardingSource {
  const OnboardingSource._();

  static const onboarding = 'onboarding';
  static const addPet = 'add_pet';
}

/// Where a health entry was written from.
class HealthEntrySource {
  const HealthEntrySource._();

  static const healthDiary = 'health_diary';
  static const diaryCreation = 'diary_creation';
  static const onboarding = 'onboarding';
}

/// What blocked the user right before the paywall opened. This is the property
/// that says which limit actually sells, so it is never omitted.
class PaywallTrigger {
  const PaywallTrigger._();

  static const addPet = 'add_pet';
  static const addPhoto = 'add_photo';
  static const multiSelectPhotos = 'multi_select_photos';
  static const settingsButton = 'settings_button';

  /// An animal kept from a premium plan that has lapsed.
  static const lockedPet = 'locked_pet';

  /// The only entry that is not a limit reached.
  static const onboarding = 'onboarding';
  static const notifications = 'notifications';
  static const unknown = 'unknown';
}

class AuthMethod {
  const AuthMethod._();

  static const email = 'email';
  static const google = 'google';
  static const apple = 'apple';
}

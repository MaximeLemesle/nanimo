/// Event vocabulary. Names are snake_case and never change once shipped: a
/// rename splits a funnel in two and silently breaks every saved insight.
class AnalyticsEvents {
  const AnalyticsEvents._();

  static const onboardingStarted = 'onboarding_started';
  static const onboardingStepCompleted = 'onboarding_step_completed';

  /// One of the explainer slides before the pet creation (NAN-114).
  static const onboardingSlideViewed = 'onboarding_slide_viewed';
  static const accountCreated = 'account_created';
  static const authCompleted = 'auth_completed';
  static const authFailed = 'auth_failed';
  static const signedOut = 'signed_out';
  static const accountDeleted = 'account_deleted';
  static const petCreated = 'pet_created';
  static const petCreationFailed = 'pet_creation_failed';
  static const petDeleted = 'pet_deleted';
  static const memoryCreated = 'memory_created';

  /// Sent alongside [memoryCreated]: the activation milestone, once per account.
  static const firstMemoryCreated = 'first_memory_created';
  static const memoryEdited = 'memory_edited';
  static const memoryDeleted = 'memory_deleted';

  static const journalViewSwitched = 'journal_view_switched';
  static const journalFilterApplied = 'journal_filter_applied';
  static const homeCardTapped = 'home_card_tapped';
  static const articleOpened = 'article_opened';

  static const vaccineCreated = 'vaccine_created';
  static const vetVisitCreated = 'vet_visit_created';
  static const weightLogged = 'weight_logged';
  static const reminderScheduled = 'reminder_scheduled';
  static const notificationOpened = 'notification_opened';
  static const notificationPermission = 'notification_permission';
  static const notificationPreferenceChanged = 'notification_preference_changed';
  static const checklistItemCompleted = 'checklist_item_completed';

  /// Captured just before the SDK goes silent, so the opt-out rate is known.
  static const analyticsOptedOut = 'analytics_opted_out';

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
  static const species = 'species';
  static const eventType = 'event_type';
  static const hasDescription = 'has_description';
  static const viewMode = 'view_mode';
  static const filter = 'filter';
  static const card = 'card';
  static const category = 'category';
  static const enabled = 'enabled';

  /// Person properties, set on the profile rather than on one event.
  static const hasVaccine = 'has_vaccine';
  static const isPremium = 'is_premium';
  static const memoryCount = 'memory_count';
  static const notificationsEnabled = 'notifications_enabled';

  /// What the OS allows, apart from the in-app switch in [notificationsEnabled].
  static const notificationPermission = 'notification_permission';
  static const authMethod = 'auth_method';
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

  /// The entries that are not a limit reached.
  static const onboarding = 'onboarding';
  static const firstSteps = 'first_steps';
  static const notifications = 'notifications';
  static const unknown = 'unknown';
}

/// Where a weight entry was typed.
class WeightSource {
  const WeightSource._();

  static const createMenu = 'create_menu';
  static const petPage = 'pet_page';
}

class HomeCard {
  const HomeCard._();

  static const memory = 'memory';
  static const birthday = 'birthday';
  static const pet = 'pet';
  static const vetVisit = 'vet_visit';
  static const health = 'health';
}

/// Species icon keys carry a breed variant (`cat-europeen`): breakdowns want `cat`.
String speciesCode(String iconKey) => iconKey.split('-').first;

/// Buckets keep the person property stable: a raw count changes on every memory.
String memoryCountBucket(int count) {
  if (count == 0) return '0';
  if (count == 1) return '1';
  if (count <= 4) return '2-4';
  if (count <= 9) return '5-9';
  if (count <= 24) return '10-24';
  return '25+';
}

class AuthMethod {
  const AuthMethod._();

  static const email = 'email';
  static const google = 'google';
  static const apple = 'apple';
}

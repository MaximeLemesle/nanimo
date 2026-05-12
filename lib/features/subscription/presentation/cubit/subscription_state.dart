part of 'subscription_cubit.dart';

enum SubscriptionStatus { unknown, loading, loaded, error }

class SubscriptionState extends Equatable {
  final SubscriptionStatus status;
  final SubscriptionConfigModel? config;
  final String? errorMessage;

  const SubscriptionState._({
    this.status = SubscriptionStatus.unknown,
    this.config,
    this.errorMessage,
  });

  const SubscriptionState.unknown() : this._();
  const SubscriptionState.loading() : this._(status: SubscriptionStatus.loading);
  const SubscriptionState.loaded(SubscriptionConfigModel config)
      : this._(status: SubscriptionStatus.loaded, config: config);
  const SubscriptionState.error(String msg)
      : this._(status: SubscriptionStatus.error, errorMessage: msg);

  bool get isLoaded => status == SubscriptionStatus.loaded;

  /// True if the user can create another pet given the current count
  bool canCreatePet(int currentCount) =>
      config != null && currentCount < config!.maxPets;

  /// True if the user can add another image to an event
  bool canAddImageToEvent(int currentImageCount) =>
      config != null && currentImageCount < config!.maxImagesPerEvent;

  /// True if the user has access to premium icons
  bool get canAccessPremiumIcons => config?.canAccessPremiumIcons ?? false;

  /// True if storage usage (in MB) is below the plan limit
  bool canUseStorage(int currentMb) =>
      config != null && currentMb < config!.maxStorageMb;

  @override
  List<Object?> get props => [status, config, errorMessage];
}

class SubscriptionConfigModel {
  final String configId;
  final String planName;
  final int maxImagesPerEvent;
  final int maxPets;
  final int maxStorageMb;

  const SubscriptionConfigModel({
    required this.configId,
    required this.planName,
    required this.maxImagesPerEvent,
    required this.maxPets,
    required this.maxStorageMb,
  });

  factory SubscriptionConfigModel.fromJson(Map<String, dynamic> json) {
    return SubscriptionConfigModel(
      configId: json['id_subscription_config'].toString(),
      planName: json['plan_name'] as String,
      maxImagesPerEvent: json['max_images_per_event'] as int,
      maxPets: json['max_pets'] as int,
      maxStorageMb: json['max_storage_in_mb'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id_subscription_config': configId,
        'plan_name': planName,
        'max_images_per_event': maxImagesPerEvent,
        'max_pets': maxPets,
        'max_storage_in_mb': maxStorageMb,
      };
}

class EventImageModel {
  final String eventImageId;
  final String assetPath;
  final String eventId;

  const EventImageModel({
    required this.eventImageId,
    required this.assetPath,
    required this.eventId,
  });

  factory EventImageModel.fromJson(Map<String, dynamic> json) {
    return EventImageModel(
      eventImageId: json['id_event_image'],
      assetPath: json['asset_path'],
      eventId: json['event_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event_image': eventImageId,
        'asset_path': assetPath,
        'event_id': eventId,
      };
}

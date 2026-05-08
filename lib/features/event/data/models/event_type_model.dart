class EventTypeModel {
  final String eventTypeId;
  final String name;
  final bool isPremium;

  const EventTypeModel({
    required this.eventTypeId,
    required this.name,
    required this.isPremium,
  });

  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      eventTypeId: json['id_event_type'],
      name: json['name'],
      isPremium: json['is_premium'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event_type': eventTypeId,
        'name': name,
        'is_premium': isPremium,
      };
}

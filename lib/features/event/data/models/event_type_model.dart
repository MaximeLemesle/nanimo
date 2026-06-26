class EventTypeModel {
  final String eventTypeId;
  final String name;
  final String? code;
  final bool isPremium;

  const EventTypeModel({
    required this.eventTypeId,
    required this.name,
    this.code,
    required this.isPremium,
  });

  factory EventTypeModel.fromJson(Map<String, dynamic> json) {
    return EventTypeModel(
      eventTypeId: json['id_event_type'],
      name: json['name'],
      code: json['code'],
      isPremium: json['is_premium'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event_type': eventTypeId,
        'name': name,
        'code': code,
        'is_premium': isPremium,
      };
}

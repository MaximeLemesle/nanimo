class EventModel {
  final String eventId;
  final String title;
  final String? description;
  final DateTime? createdAt;
  final DateTime? entryDate;
  final String eventTypeId;

  const EventModel({
    required this.eventId,
    required this.title,
    this.description,
    this.createdAt,
    this.entryDate,
    required this.eventTypeId,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      eventId: json['id_event'],
      title: json['title'],
      description: json['description'],
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      entryDate: json['entry_date'] != null
          ? DateTime.parse(json['entry_date'] as String)
          : null,
      eventTypeId: json['event_type_id'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id_event': eventId,
        'title': title,
        'description': description,
        'created_at': createdAt,
        'entry_date': entryDate,
        'event_type_id': eventTypeId,
      };
}

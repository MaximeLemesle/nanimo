import 'package:equatable/equatable.dart';

class NotificationPrefsModel extends Equatable {
  final bool pushEnabled;
  final bool vaccineReminders;
  final bool vetReminders;
  final bool dewormingReminders;
  final bool anniversaryReminders;
  final bool newArticles;

  const NotificationPrefsModel({
    this.pushEnabled = true,
    this.vaccineReminders = true,
    this.vetReminders = true,
    this.dewormingReminders = true,
    this.anniversaryReminders = true,
    this.newArticles = true,
  });

  static const defaults = NotificationPrefsModel();

  NotificationPrefsModel copyWith({
    bool? pushEnabled,
    bool? vaccineReminders,
    bool? vetReminders,
    bool? dewormingReminders,
    bool? anniversaryReminders,
    bool? newArticles,
  }) {
    return NotificationPrefsModel(
      pushEnabled: pushEnabled ?? this.pushEnabled,
      vaccineReminders: vaccineReminders ?? this.vaccineReminders,
      vetReminders: vetReminders ?? this.vetReminders,
      dewormingReminders: dewormingReminders ?? this.dewormingReminders,
      anniversaryReminders: anniversaryReminders ?? this.anniversaryReminders,
      newArticles: newArticles ?? this.newArticles,
    );
  }

  @override
  List<Object?> get props => [
        pushEnabled,
        vaccineReminders,
        vetReminders,
        dewormingReminders,
        anniversaryReminders,
        newArticles,
      ];
}

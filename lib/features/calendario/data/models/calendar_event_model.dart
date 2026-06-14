import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/entities/calendar_event_type.dart';

class CalendarEventModel extends CalendarEventEntity {
  const CalendarEventModel({
    required super.id,
    required super.title,
    required super.description,
    required super.startDate,
    required super.endDate,
    required super.type,
    required super.location,
    super.isAllDay,
  });

  factory CalendarEventModel.fromEntity(CalendarEventEntity entity) {
    return CalendarEventModel(
      id: entity.id,
      title: entity.title,
      description: entity.description,
      startDate: entity.startDate,
      endDate: entity.endDate,
      type: entity.type,
      location: entity.location,
      isAllDay: entity.isAllDay,
    );
  }

  factory CalendarEventModel.fromMap(Map<String, Object?> map) {
    return CalendarEventModel(
      id: map['id'] as String,
      title: map['title'] as String,
      description: map['description'] as String? ?? '',
      startDate: DateTime.parse(map['startDate'] as String),
      endDate: DateTime.parse(map['endDate'] as String),
      type: CalendarEventType.values.byName(map['type'] as String),
      location: map['location'] as String? ?? '',
      isAllDay: map['isAllDay'] as bool? ?? false,
    );
  }

  Map<String, Object?> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'type': type.name,
      'location': location,
      'isAllDay': isAllDay,
    };
  }
}

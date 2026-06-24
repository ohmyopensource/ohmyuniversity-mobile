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

  factory CalendarEventModel.fromJson(Map<String, dynamic> json) {
    final startDate = DateTime.parse(json['startDate'] as String).toLocal();
    final rawEndDate = json['endDate'] as String?;

    return CalendarEventModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String? ?? '',
      startDate: startDate,
      endDate: rawEndDate == null
          ? startDate
          : DateTime.parse(rawEndDate).toLocal(),
      type: _typeFromBackend(json['type'] as String?),
      location: json['notes'] as String? ?? '',
      isAllDay: json['allDay'] as bool? ?? false,
    );
  }

  Map<String, Object?> toRequestJson() {
    return {
      'title': title,
      'description': description,
      'startDate': startDate.toUtc().toIso8601String(),
      'endDate': endDate.toUtc().toIso8601String(),
      'type': _typeToBackend(type),
      'notes': location,
      'allDay': isAllDay,
    };
  }

  static CalendarEventType _typeFromBackend(String? value) {
    return switch (value) {
      'EXAM' => CalendarEventType.exam,
      'REMINDER' || 'DEADLINE' => CalendarEventType.reminder,
      _ => CalendarEventType.event,
    };
  }

  static String _typeToBackend(CalendarEventType type) {
    return switch (type) {
      CalendarEventType.exam => 'EXAM',
      CalendarEventType.reminder => 'REMINDER',
      CalendarEventType.event => 'PERSONAL',
    };
  }
}

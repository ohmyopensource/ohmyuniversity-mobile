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
    final startDate = _parseRequiredDate(
      json['startDate'] ??
          json['start_date'] ??
          json['dataInizio'] ??
          json['startsAt'],
    );

    final endDate =
        _parseOptionalDate(
          json['endDate'] ??
              json['end_date'] ??
              json['dataFine'] ??
              json['endsAt'],
        ) ??
        startDate;

    return CalendarEventModel(
      id: _textOrFallback(
        json['id'] ?? json['eventId'] ?? json['universityEventId'],
        '',
      ),
      title: _textOrFallback(
        json['title'] ?? json['titolo'] ?? json['name'],
        'Evento',
      ),
      description: _textOrFallback(
        json['description'] ?? json['descrizione'] ?? json['notes'],
        '',
      ),
      startDate: startDate,
      endDate: endDate,
      type: _typeFromBackend(json['type'] as String?),
      location: _textOrFallback(
        json['location'] ?? json['aula'] ?? json['luogo'] ?? json['notes'],
        '',
      ),
      isAllDay: json['allDay'] as bool? ?? json['all_day'] as bool? ?? false,
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

  static DateTime _parseRequiredDate(Object? value) {
    final parsed = _parseOptionalDate(value);
    if (parsed == null) {
      throw const FormatException('Invalid calendar event date');
    }
    return parsed;
  }

  static DateTime? _parseOptionalDate(Object? value) {
    if (value == null) return null;

    final text = value.toString().trim();
    if (text.isEmpty) return null;

    final isoDate = DateTime.tryParse(text);
    if (isoDate != null) return isoDate.toLocal();

    final match = RegExp(r'^(\d{1,2})/(\d{1,2})/(\d{4})').firstMatch(text);
    if (match == null) return null;

    return DateTime(
      int.parse(match.group(3)!),
      int.parse(match.group(2)!),
      int.parse(match.group(1)!),
    );
  }

  static String _textOrFallback(Object? value, String fallback) {
    final text = value?.toString().trim();
    if (text == null || text.isEmpty) return fallback;
    return text;
  }

  static CalendarEventType _typeFromBackend(String? value) {
    return switch (value?.toUpperCase()) {
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

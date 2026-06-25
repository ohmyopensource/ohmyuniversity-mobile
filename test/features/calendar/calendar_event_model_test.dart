import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/calendar/data/models/calendar_event_model.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';

void main() {
  test('maps backend exam events into calendar entities', () {
    final model = CalendarEventModel.fromJson({
      'id': 'exam-1',
      'title': 'Analisi Matematica',
      'description': 'Appello scritto',
      'startDate': '2026-06-28T09:00:00.000Z',
      'endDate': '2026-06-28T11:00:00.000Z',
      'type': 'EXAM',
      'notes': 'Aula A1',
      'allDay': false,
    });

    expect(model.id, 'exam-1');
    expect(model.title, 'Analisi Matematica');
    expect(model.description, 'Appello scritto');
    expect(model.type, CalendarEventType.exam);
    expect(model.location, 'Aula A1');
    expect(model.isAllDay, isFalse);
  });

  test('uses safe defaults for optional backend fields', () {
    final model = CalendarEventModel.fromJson({
      'id': 'event-1',
      'title': 'Promemoria iscrizione',
      'startDate': '2026-07-01T08:00:00.000Z',
      'type': 'UNKNOWN',
    });

    expect(model.description, '');
    expect(model.endDate, model.startDate);
    expect(model.type, CalendarEventType.event);
    expect(model.location, '');
    expect(model.isAllDay, isFalse);
  });

  test('serializes calendar events using backend field names', () {
    final model = CalendarEventModel.fromEntity(
      CalendarEventEntity(
        id: 'personal-1',
        title: 'Scadenza borsa di studio',
        description: 'Caricare la documentazione',
        startDate: DateTime.utc(2026, 8, 10, 9),
        endDate: DateTime.utc(2026, 8, 10, 10),
        type: CalendarEventType.reminder,
        location: 'Portale studenti',
        isAllDay: true,
      ),
    );

    final json = model.toRequestJson();

    expect(json['title'], 'Scadenza borsa di studio');
    expect(json['description'], 'Caricare la documentazione');
    expect(json['type'], 'REMINDER');
    expect(json['notes'], 'Portale studenti');
    expect(json['allDay'], isTrue);
    expect(json['startDate'], contains('2026-08-10T09:00:00.000Z'));
    expect(json['endDate'], contains('2026-08-10T10:00:00.000Z'));
  });
}

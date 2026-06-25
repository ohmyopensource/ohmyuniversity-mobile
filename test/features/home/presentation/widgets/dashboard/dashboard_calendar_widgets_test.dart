import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';
import 'package:ohmyuniversity/features/home/presentation/widgets/dashboard/dashboard_calendar_widgets.dart';

void main() {
  testWidgets('dashboard agenda shows today and tomorrow events in order', (
    tester,
  ) async {
    final today = DateTime(2026, 6, 25);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 304,
            height: 180,
            child: DashboardCalendarAgendaWidget(
              date: today,
              events: [
                _event(
                  id: 'tomorrow',
                  title: 'Ricevimento',
                  start: DateTime(2026, 6, 26, 11),
                  end: DateTime(2026, 6, 26, 12),
                  type: CalendarEventType.reminder,
                ),
                _event(
                  id: 'today',
                  title: 'Lezione Flutter',
                  start: DateTime(2026, 6, 25, 9),
                  end: DateTime(2026, 6, 25, 11),
                  type: CalendarEventType.event,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Agenda'), findsOneWidget);
    expect(find.text('Gio 25 Giu'), findsOneWidget);
    expect(find.text('Lezione Flutter'), findsOneWidget);
    expect(find.text('Ricevimento'), findsOneWidget);
    expect(find.text('09:00'), findsOneWidget);
  });

  testWidgets('dashboard agenda shows empty state without visible events', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 304,
            height: 160,
            child: DashboardCalendarAgendaWidget(
              date: DateTime(2026, 6, 25),
              events: [
                _event(
                  id: 'old',
                  title: 'Evento vecchio',
                  start: DateTime(2026, 6, 20, 9),
                  end: DateTime(2026, 6, 20, 10),
                  type: CalendarEventType.event,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Nessun evento in agenda'), findsOneWidget);
    expect(find.text('Evento vecchio'), findsNothing);
  });
}

CalendarEventEntity _event({
  required String id,
  required String title,
  required DateTime start,
  required DateTime end,
  required CalendarEventType type,
}) {
  return CalendarEventEntity(
    id: id,
    title: title,
    description: '',
    startDate: start,
    endDate: end,
    type: type,
    location: 'Aula 1',
  );
}

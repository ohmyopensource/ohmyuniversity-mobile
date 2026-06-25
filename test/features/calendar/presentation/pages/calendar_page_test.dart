import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';
import 'package:ohmyuniversity/features/calendar/presentation/pages/calendar_page.dart';
import 'package:ohmyuniversity/features/calendar/presentation/providers/calendar_providers.dart';

void main() {
  testWidgets('calendar page renders day timeline and event data', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          calendarEventsProvider.overrideWith((ref) async => [_event]),
          calendarClockProvider.overrideWith(
            (ref) => Stream.value(DateTime(2026, 6, 25, 10)),
          ),
        ],
        child: const MaterialApp(home: CalendarPage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(CalendarPage), findsOneWidget);
    expect(find.text('Lezione Flutter'), findsOneWidget);
    expect(find.byIcon(Icons.add), findsNothing);
  });
}

final _event = CalendarEventEntity(
  id: 'event-1',
  title: 'Lezione Flutter',
  description: 'Aula laboratorio',
  startDate: DateTime(2026, 6, 25, 9),
  endDate: DateTime(2026, 6, 25, 11),
  type: CalendarEventType.event,
  location: 'Aula 1',
);

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_entity.dart';
import 'package:ohmyuniversity/features/calendar/domain/entities/calendar_event_type.dart';
import 'package:ohmyuniversity/features/calendar/presentation/providers/calendar_providers.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_day_strip.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_empty_state.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_event_card.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_event_detail_sheet.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_event_form_sheet.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_header.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_month_view.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_year_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('calendar cards and empty state render event details', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CalendarEventCard(event: _event, onTap: () => tapped = true),
              CalendarEventCard(event: _event, compact: true),
              const CalendarEmptyState(),
            ],
          ),
        ),
      ),
    );

    expect(find.text('Esame Basi di Dati'), findsWidgets);
    expect(find.text('Aula 5'), findsOneWidget);
    expect(find.text('Nessun evento in programma'), findsOneWidget);

    await tester.tap(find.text('Esame Basi di Dati').first);
    await tester.pump();
    expect(tapped, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('day strip, header, month and year views emit navigation events', (
    tester,
  ) async {
    final selectedDates = <DateTime>[];
    final changedViews = <CalendarView>[];
    final changedMonths = <DateTime>[];
    final changedYears = <DateTime>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            height: 900,
            child: Column(
              children: [
                CalendarHeader(
                  selectedDate: DateTime(2026, 6, 25),
                  selectedView: CalendarView.month,
                  onViewChanged: changedViews.add,
                  onOpenDatePicker: () => selectedDates.add(DateTime(2026)),
                  onBack: () => selectedDates.add(DateTime(2025)),
                ),
                CalendarDayStrip(
                  selectedDate: DateTime(2026, 6, 25),
                  onDateSelected: selectedDates.add,
                ),
                Expanded(
                  child: CalendarMonthView(
                    focusedDate: DateTime(2026, 6),
                    events: [_event],
                    onDaySelected: selectedDates.add,
                    onMonthChanged: changedMonths.add,
                  ),
                ),
                Expanded(
                  child: CalendarYearView(
                    focusedDate: DateTime(2026, 6),
                    events: [_event],
                    onMonthSelected: selectedDates.add,
                    onYearChanged: changedYears.add,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.text('Anno'));
    await tester.tap(find.byTooltip('Mese successivo'));
    await tester.tap(find.byTooltip('Anno precedente'));
    await tester.tap(find.text('25').first);
    await tester.pump();

    expect(changedViews, contains(CalendarView.year));
    expect(changedMonths.single.month, 7);
    expect(changedYears.single.year, 2025);
    expect(selectedDates, isNotEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('detail sheet renders event actions', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: CalendarEventDetailSheet(event: _event),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Modifica'), findsWidgets);
    expect(find.text('Elimina'), findsOneWidget);
    expect(find.text('Chiudi'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });

  testWidgets('form sheet shows create, edit and validation states', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              height: 1200,
              child: Column(
                children: [
                  Expanded(
                    child: CalendarEventFormSheet(
                      initialDate: DateTime(2026, 6, 25),
                    ),
                  ),
                  Expanded(
                    child: CalendarEventFormSheet(
                      initialDate: DateTime(2026, 6, 25),
                      event: _event,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Nuovo elemento'), findsOneWidget);
    expect(find.text('Modifica elemento'), findsOneWidget);

    await tester.ensureVisible(find.text('Salva').first);
    await tester.tap(find.text('Salva').first);
    await tester.pump();

    expect(find.text('Inserisci un titolo.'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

final _event = CalendarEventEntity(
  id: 'calendar-event-1',
  title: 'Esame Basi di Dati',
  description: 'Prova scritta',
  startDate: DateTime(2026, 6, 25, 9),
  endDate: DateTime(2026, 6, 25, 11),
  type: CalendarEventType.exam,
  location: 'Aula 5',
);

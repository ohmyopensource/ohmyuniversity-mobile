import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/calendar/presentation/widgets/calendar_timeline.dart';

void main() {
  testWidgets('shows the full day timeline from 00:00 to 23:00', (
    tester,
  ) async {
    final selectedDate = DateTime(2026, 6, 24);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: CalendarTimeline(
            events: const [],
            selectedDate: selectedDate,
            currentTime: DateTime(2026, 6, 24, 12),
            selectedHour: null,
            onHourSelected: (_) {},
            onEventSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('00:00'), findsOneWidget);
    expect(find.text('23:00'), findsOneWidget);
  });
}

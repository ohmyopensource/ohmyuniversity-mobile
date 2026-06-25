import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_entity.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_format.dart';
import 'package:ohmyuniversity/features/timetable/presentation/pages/timetable_page.dart';
import 'package:ohmyuniversity/features/timetable/presentation/providers/timetable_providers.dart';

void main() {
  testWidgets('timetable page renders semester documents and search prompt', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          studentTimetablesProvider.overrideWith((ref) async => [_document]),
        ],
        child: const MaterialApp(home: TimetablePage()),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Orario Lezioni'), findsWidgets);
    expect(find.text('I miei corsi'), findsOneWidget);
    expect(find.text('Informatica'), findsOneWidget);
    expect(find.text('2025/2026'), findsOneWidget);
  });
}

final _document = TimetableDocumentEntity(
  id: 'doc-1',
  title: 'Informatica',
  universityName: 'Universita degli Studi del Molise',
  department: 'Bioscienze e territorio',
  degreeClass: 'L-31',
  academicYear: '2025/2026',
  semester: 1,
  updatedAt: DateTime(2026, 6, 25),
  format: TimetableDocumentFormat.pdf,
  sourceUrl: 'https://www.unimol.it/orari',
  fileUrl: 'https://www.unimol.it/orari/informatica.pdf',
);

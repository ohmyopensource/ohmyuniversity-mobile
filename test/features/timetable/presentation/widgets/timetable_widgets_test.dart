import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_entity.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_format.dart';
import 'package:ohmyuniversity/features/timetable/presentation/widgets/timetable_card.dart';
import 'package:ohmyuniversity/features/timetable/presentation/widgets/timetable_search_modal.dart';
import 'package:ohmyuniversity/features/timetable/presentation/widgets/timetable_search_prompt.dart';
import 'package:ohmyuniversity/features/timetable/presentation/widgets/timetable_semester_switch.dart';

void main() {
  testWidgets('timetable card renders metadata and action callbacks', (
    tester,
  ) async {
    TimetableDocumentEntity? viewed;
    TimetableDocumentEntity? downloaded;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 430,
            child: TimetableCard(
              document: _documents.first,
              onView: (document) => viewed = document,
              onDownload: (document) => downloaded = document,
            ),
          ),
        ),
      ),
    );

    expect(find.text('Informatica'), findsOneWidget);
    expect(find.text('UNIMOL - Dipartimento di Bioscienze'), findsOneWidget);
    expect(find.text('L-31'), findsOneWidget);
    expect(find.text('2025/2026'), findsOneWidget);

    await tester.tap(find.text('Scarica PDF'));
    await tester.tap(find.text('Visualizza online'));
    await tester.pump();

    expect(downloaded?.id, 'inf-1');
    expect(viewed?.id, 'inf-1');
  });

  testWidgets('timetable search prompt and semester switch emit callbacks', (
    tester,
  ) async {
    var searchTapped = false;
    int? selectedSemester;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 320,
            child: Column(
              children: [
                TimetableSearchPrompt(onSearch: () => searchTapped = true),
                TimetableSemesterSwitch(
                  selectedSemester: 1,
                  onChanged: (semester) => selectedSemester = semester,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Non e l\'orario che cercavi?'), findsOneWidget);
    expect(find.text('Primo semestre'), findsOneWidget);
    expect(find.text('Secondo semestre'), findsOneWidget);

    await tester.tap(find.text('Cerca orario'));
    await tester.tap(find.text('Secondo semestre'));
    await tester.pump();

    expect(searchTapped, isTrue);
    expect(selectedSemester, 2);
  });

  testWidgets('timetable search modal shows matching and empty states', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 430,
              child: TimetableSearchModal(
                documents: _documents,
                initialSemester: 2,
                onView: (_) {},
                onDownload: (_) {},
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Cerca orario lezioni'), findsOneWidget);
    expect(find.text('Seleziona dipartimento, corso e semestre.'), findsOneWidget);
    expect(find.text('Fisica'), findsWidgets);
    expect(find.text('Semestre 2'), findsOneWidget);
    expect(find.text('2025/2026'), findsOneWidget);
  });

  testWidgets('timetable search modal handles empty document lists', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 430,
            child: TimetableSearchModal(
              documents: const [],
              initialSemester: 1,
              onView: (_) {},
              onDownload: (_) {},
            ),
          ),
        ),
      ),
    );

    expect(find.text('Cerca orario lezioni'), findsOneWidget);
    expect(find.text('Nessun orario trovato per i filtri selezionati.'), findsOneWidget);
  });
}

final _documents = [
  TimetableDocumentEntity(
    id: 'inf-1',
    title: 'Informatica',
    universityName: 'UNIMOL',
    department: 'Dipartimento di Bioscienze',
    degreeClass: 'L-31',
    academicYear: '2025/2026',
    semester: 1,
    updatedAt: DateTime(2026, 6, 1),
    format: TimetableDocumentFormat.pdf,
    sourceUrl: 'https://www.unimol.it/informatica',
    fileUrl: 'https://www.unimol.it/informatica.pdf',
  ),
  TimetableDocumentEntity(
    id: 'fis-2',
    title: 'Fisica',
    universityName: 'UNIMOL',
    department: 'Dipartimento di Bioscienze',
    degreeClass: 'L-30',
    academicYear: '2025/2026',
    semester: 2,
    updatedAt: DateTime(2026, 6, 2),
    format: TimetableDocumentFormat.web,
    sourceUrl: 'https://www.unimol.it/fisica',
  ),
  TimetableDocumentEntity(
    id: 'eco-1',
    title: 'Economia',
    universityName: 'UNIMOL',
    department: 'Dipartimento di Economia',
    degreeClass: 'L-18',
    academicYear: '2025/2026',
    semester: 1,
    updatedAt: DateTime(2026, 6, 3),
    format: TimetableDocumentFormat.web,
    sourceUrl: 'https://www.unimol.it/economia',
  ),
];

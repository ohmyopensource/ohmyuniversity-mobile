import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_exam_widgets.dart';

void main() {
  testWidgets('academic exams panel filters by year and semester', (
    tester,
  ) async {
    int? selectedYear;
    int? selectedSemester;
    final provisionalGrades = <String, int>{};

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 430,
            child: AcademicExamsPanel(
              courses: _courses,
              years: const [1, 2],
              selectedYear: 1,
              selectedSemester: 0,
              provisionalGrades: const {'math': 26},
              onYearChanged: (year) => selectedYear = year,
              onSemesterChanged: (semester) => selectedSemester = semester,
              onProvisionalGradeChanged: (courseId, grade) {
                provisionalGrades[courseId] = grade;
              },
            ),
          ),
        ),
      ),
    );

    expect(find.text('Anno 1'), findsOneWidget);
    expect(find.text('Primo semestre'), findsOneWidget);
    expect(find.text('Analisi matematica'), findsOneWidget);
    expect(find.text('Fisica'), findsNothing);

    await tester.tap(find.text('Anno 2'));
    await tester.tap(find.text('Secondo semestre'));
    await tester.pump();

    expect(selectedYear, 2);
    expect(selectedSemester, 1);

    expect(tester.takeException(), isNull);
  });

  testWidgets('academic appeals panel renders status filters and booking modal', (
    tester,
  ) async {
    AcademicExamAppealMonthData? selectedMonth;
    int? selectedStatus;
    AcademicExamAppealData? bookedAppeal;

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(
              child: SizedBox(
                width: 430,
                child: AcademicExamAppealsPanel(
                  months: _months,
                  selectedMonth: _months.first,
                  selectedStatus: 1,
                  appeals: _appeals,
                  showQuestionnaireAction: true,
                  onMonthChanged: (month) => selectedMonth = month,
                  onStatusChanged: (status) => selectedStatus = status,
                  onBookingConfirmed: (appeal) => bookedAppeal = appeal,
                ),
              ),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Giugno'), findsOneWidget);
    expect(find.text('Appelli in apertura'), findsOneWidget);
    expect(find.text('Analisi matematica'), findsOneWidget);
    expect(find.text('Prenotabile'), findsOneWidget);

    await tester.tap(find.text('Luglio'));
    await tester.tap(find.text('Appelli prenotati'));
    await tester.pump();

    expect(selectedMonth?.id, '2026-7');
    expect(selectedStatus, 0);

    await tester.tap(find.text('Prenotabile'));
    await tester.pumpAndSettle();

    expect(find.text('Prenota esame'), findsOneWidget);
    await tester.tap(find.text('Prenota').last);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(seconds: 4));

    expect(bookedAppeal?.id, 'appeal-1');
    expect(tester.takeException(), isNull);
  });
}

const _courses = [
  AcademicExamCourseData(
    id: 'math',
    year: 1,
    semester: 1,
    name: 'Analisi matematica',
    code: 'MAT01',
    credits: 9,
    passed: false,
  ),
  AcademicExamCourseData(
    id: 'physics',
    year: 1,
    semester: 2,
    name: 'Fisica',
    code: 'FIS01',
    credits: 6,
    passed: true,
    grade: '30L',
  ),
  AcademicExamCourseData(
    id: 'ai',
    year: 2,
    semester: 1,
    name: 'Intelligenza artificiale',
    code: 'INF02',
    credits: 9,
    passed: false,
  ),
];

const _months = [
  AcademicExamAppealMonthData(month: 6, year: 2026),
  AcademicExamAppealMonthData(month: 7, year: 2026),
];

final _appeals = [
  AcademicExamAppealData(
    id: 'appeal-1',
    examName: 'Analisi matematica',
    month: 6,
    date: DateTime(2026, 6, 20),
    time: '09:00',
    isBooked: false,
    isBookable: true,
    room: 'Aula 1',
  ),
  AcademicExamAppealData(
    id: 'appeal-2',
    examName: 'Fisica',
    month: 7,
    date: DateTime(2026, 7, 12),
    time: '11:00',
    isBooked: true,
  ),
];

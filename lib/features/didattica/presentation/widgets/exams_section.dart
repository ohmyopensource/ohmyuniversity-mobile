import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/academic/academic_exam_widgets.dart';
import '../../domain/entities/didattica_exam_course_entity.dart';
import '../providers/exam_courses_provider.dart';

class ExamsSection extends ConsumerStatefulWidget {
  const ExamsSection({super.key});

  @override
  ConsumerState<ExamsSection> createState() => _ExamsSectionState();
}

class _ExamsSectionState extends ConsumerState<ExamsSection>
    with TickerProviderStateMixin {
  int _selectedYear = 1;
  int _selectedSemester = 0;
  final Map<String, int> _provisionalGrades = {};

  List<int> _availableYears(List<DidatticaExamCourseEntity> courses) {
    final years = courses.map((course) => course.year).toSet().toList()..sort();

    return years;
  }

  void _changeYear(int year) {
    if (year == _selectedYear) return;

    setState(() {
      _selectedYear = year;
      _selectedSemester = 0;
    });
  }

  void _changeSemester(int semester) {
    if (semester == _selectedSemester) return;

    setState(() => _selectedSemester = semester);
  }

  void _changeProvisionalGrade(String courseId, int grade) {
    setState(() => _provisionalGrades[courseId] = grade);
  }

  @override
  Widget build(BuildContext context) {
    final courses = ref.watch(didatticaExamCoursesProvider);
    final years = _availableYears(courses);
    final selectedYear = years.contains(_selectedYear)
        ? _selectedYear
        : years.isNotEmpty
        ? years.first
        : _selectedYear;

    return AcademicExamsPanel(
      courses: courses.map(_mapCourse).toList(),
      years: years,
      selectedYear: selectedYear,
      selectedSemester: _selectedSemester,
      provisionalGrades: _provisionalGrades,
      onYearChanged: _changeYear,
      onSemesterChanged: _changeSemester,
      onProvisionalGradeChanged: _changeProvisionalGrade,
    );
  }

  AcademicExamCourseData _mapCourse(DidatticaExamCourseEntity course) {
    return AcademicExamCourseData(
      id: course.id,
      year: course.year,
      semester: course.semester,
      name: course.name,
      code: course.code,
      credits: course.credits,
      passed: course.passed,
      grade: course.grade,
    );
  }
}

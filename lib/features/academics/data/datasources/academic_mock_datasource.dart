import '../../../../shared/mocks/app_mock_data.dart';
import '../../domain/entities/academic_course_type.dart';
import '../../domain/entities/academic_cfu_breakdown_entity.dart';
import '../models/academic_exam_course_model.dart';

class AcademicMockDataSource {
  const AcademicMockDataSource();

  List<AcademicExamCourseModel> getExamCourses() {
    return AppMockData.academicExamCourses.map(_toExamCourseModel).toList();
  }

  AcademicExamCourseModel _toExamCourseModel(MockExamCourseData course) {
    return AcademicExamCourseModel(
      id: course.id,
      year: course.year,
      semester: course.semester,
      name: course.name,
      code: course.code,
      credits: course.credits,
      grade: course.grade,
      passed: course.passed,
      completedAt: course.completedAt,
      courseType: AcademicCourseType.values.byName(course.courseType),
      language: course.name.contains('Inglese') ? 'Inglese' : 'Italiano',
      durationHours: course.credits * 8,
      attendanceMandatory: _requiresAttendance(course.name),
      scientificSector: course.code,
      location: _locationFor(course.year),
      prerequisites: _prerequisitesFor(course.name),
      cfuBreakdown: _buildCfuBreakdown(course),
    );
  }

  bool _requiresAttendance(String courseName) {
    return courseName == 'Tirocinio' || courseName == 'Sviluppo Mobile';
  }

  String _locationFor(int year) {
    return switch (year) {
      1 => 'Campobasso',
      2 => 'Pesche',
      _ => 'Termoli',
    };
  }

  List<String> _prerequisitesFor(String courseName) {
    return switch (courseName) {
      'Programmazione I' => const ['Fondamenti di Informatica'],
      'Algoritmi e Strutture Dati' => const ['Programmazione I'],
      'Sviluppo Mobile' => const ['Programmazione I'],
      'Machine Learning' => const ['Statistica', 'Algebra Lineare'],
      _ => const [],
    };
  }

  List<AcademicCfuBreakdownEntity> _buildCfuBreakdown(
    MockExamCourseData course,
  ) {
    return List.generate(
      course.credits,
      (index) => AcademicCfuBreakdownEntity(
        cfuNumber: index + 1,
        description: _cfuDescription(course.name, index + 1),
      ),
      growable: false,
    );
  }

  String _cfuDescription(String courseName, int cfuNumber) {
    const topics = [
      'Fondamenti e concetti introduttivi',
      'Metodi e strumenti principali',
      'Modelli teorici e applicazioni',
      'Laboratorio ed esercitazioni',
      'Casi di studio e approfondimenti',
      'Verifica delle competenze acquisite',
    ];
    final topic = topics[(cfuNumber - 1) % topics.length];
    return '$topic di $courseName.';
  }
}

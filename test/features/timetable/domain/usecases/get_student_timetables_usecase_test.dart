import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_entity.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_format.dart';
import 'package:ohmyuniversity/features/timetable/domain/repositories/timetable_repository.dart';
import 'package:ohmyuniversity/features/timetable/domain/usecases/get_student_timetables_usecase.dart';

void main() {
  test(
    'get student timetables forwards university and course to repository',
    () async {
      final repository = _FakeTimetableRepository();
      final useCase = GetStudentTimetablesUseCase(repository);

      final result = await useCase(
        universityId: 'UNIMOL',
        courseName: 'Informatica',
      );

      expect(repository.lastUniversityId, 'UNIMOL');
      expect(repository.lastCourseName, 'Informatica');
      expect(result.single.title, 'Orario Informatica');
    },
  );
}

class _FakeTimetableRepository implements TimetableRepository {
  String? lastUniversityId;
  String? lastCourseName;

  @override
  Future<List<TimetableDocumentEntity>> getStudentTimetables({
    required String universityId,
    required String courseName,
  }) async {
    lastUniversityId = universityId;
    lastCourseName = courseName;
    return [
      TimetableDocumentEntity(
        id: 'timetable-1',
        title: 'Orario Informatica',
        universityName: 'Universita degli Studi del Molise',
        department: 'Bioscienze e Territorio',
        degreeClass: 'L-31',
        updatedAt: DateTime(2026, 6, 25),
        format: TimetableDocumentFormat.pdf,
        sourceUrl: 'https://www.unimol.it/orari',
        fileUrl: 'https://www.unimol.it/orari/informatica.pdf',
      ),
    ];
  }
}

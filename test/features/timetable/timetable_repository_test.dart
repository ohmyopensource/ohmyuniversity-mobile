import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/timetable/data/datasources/timetable_mock_datasource.dart';
import 'package:ohmyuniversity/features/timetable/data/datasources/timetable_remote_datasource.dart';
import 'package:ohmyuniversity/features/timetable/data/models/timetable_model.dart';
import 'package:ohmyuniversity/features/timetable/data/repositories/timetable_repository_impl.dart';
import 'package:ohmyuniversity/features/timetable/domain/entities/timetable_document_format.dart';
import 'package:dio/dio.dart';

void main() {
  test('maps timetable backend documents with PDF metadata', () {
    final model = TimetableModel.fromJson({
      'id': 7,
      'label': 'Informatica - primo semestre',
      'universityId': 'UNIMOL',
      'departmentName': 'Dipartimento di Bioscienze e Territorio',
      'degreeType': 'L-31',
      'timetablePageUrl': 'https://www.unimol.it/informatica_lezioni',
      'pdfUrl': 'https://www.unimol.it/informatica.pdf',
      'fetchedAt': '2026-06-20T09:00:00Z',
    });

    expect(model.id, '7');
    expect(model.title, 'Informatica - primo semestre');
    expect(model.universityName, 'UNIMOL');
    expect(model.format, TimetableDocumentFormat.pdf);
    expect(model.hasPdf, isTrue);
  });

  test('filters timetable documents by the active student course', () async {
    final repository = TimetableRepositoryImpl(
      TimetableRemoteDataSource(Dio()),
      const TimetableMockDataSource(),
      useMock: true,
    );

    final informatica = await repository.getStudentTimetables(
      universityId: 'UNIMOL',
      courseName: 'Informatica',
    );
    final economia = await repository.getStudentTimetables(
      universityId: 'UNIMOL',
      courseName: 'Economia Aziendale',
    );

    expect(informatica, isNotEmpty);
    expect(
      informatica.every((document) => document.title == 'Informatica'),
      isTrue,
    );
    expect(economia, isNotEmpty);
  });
}

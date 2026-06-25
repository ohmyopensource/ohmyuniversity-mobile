import '../../domain/entities/timetable_document_entity.dart';
import '../../domain/repositories/timetable_repository.dart';
import '../datasources/timetable_mock_datasource.dart';
import '../datasources/timetable_remote_datasource.dart';

class TimetableRepositoryImpl implements TimetableRepository {
  const TimetableRepositoryImpl(
      this._remoteDataSource,
      this._mockDataSource, {
        required bool useMock,
      }) : _useMock = useMock;

  final TimetableRemoteDataSource _remoteDataSource;
  final TimetableMockDataSource _mockDataSource;
  final bool _useMock;

  @override
  Future<List<TimetableDocumentEntity>> getStudentTimetables({
    required String universityId,
    required String courseName,
  }) async {
    final documents = _useMock
        ? _mockDataSource.getStudentTimetables()
        : await _remoteDataSource.getStudentTimetables(
      universityId: universityId,
      courseName: courseName,
    );

    final studentDocuments = documents
        .where((document) => _belongsToCourse(document, courseName))
        .toList(growable: false);

    if (studentDocuments.isNotEmpty) {
      return List<TimetableDocumentEntity>.unmodifiable(studentDocuments);
    }

    return List<TimetableDocumentEntity>.unmodifiable(documents);
  }

  bool _belongsToCourse(TimetableDocumentEntity document, String courseName) {
    final courseTokens = _tokens(courseName);
    if (courseTokens.isEmpty) return true;

    final searchableText = [
      document.title,
      document.department,
      document.degreeClass,
      document.sourceUrl,
      document.fileUrl ?? '',
    ].join(' ');

    final documentTokens = _tokens(searchableText);
    if (documentTokens.isEmpty) return false;

    final matches = courseTokens
        .where(
          (courseToken) => documentTokens.any(
            (documentToken) => _tokensMatch(courseToken, documentToken),
      ),
    )
        .length;

    final minimumMatches = courseTokens.length == 1 ? 1 : 2;

    return matches >= minimumMatches && matches / courseTokens.length >= 0.55;
  }

  Set<String> _tokens(String value) {
    const ignored = {
      'corso',
      'laurea',
      'triennale',
      'magistrale',
      'della',
      'delle',
      'degli',
      'dello',
      'del',
      'dei',
      'di',
      'e',
      'in',
      'per',
      'classe',
      'lezioni',
      'orario',
    };

    return value
        .toLowerCase()
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .split(' ')
        .where((token) => token.length > 2 && !ignored.contains(token))
        .toSet();
  }

  bool _tokensMatch(String first, String second) {
    if (first == second) return true;
    if (first.length < 5 || second.length < 5) return false;
    return first.substring(0, 5) == second.substring(0, 5);
  }
}
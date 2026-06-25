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
          );
    final studentDocuments = _useMock
        ? documents
        : documents
              .where((document) => _belongsToCourse(document, courseName))
              .toList(growable: false);

    return List<TimetableDocumentEntity>.unmodifiable(studentDocuments);
  }

  bool _belongsToCourse(TimetableDocumentEntity document, String courseName) {
    final uri = Uri.tryParse(document.sourceUrl);
    if (uri == null || uri.pathSegments.isEmpty) return false;

    final slug = uri.pathSegments.last.replaceFirst(RegExp(r'_lezioni$'), '');
    final courseTokens = _tokens(courseName);
    final slugTokens = _tokens(slug);
    if (courseTokens.isEmpty || slugTokens.isEmpty) return false;

    final matches = courseTokens
        .where(
          (courseToken) => slugTokens.any(
            (slugToken) => _tokensMatch(courseToken, slugToken),
          ),
        )
        .length;
    final minimumMatches = courseTokens.length == 1 ? 1 : 2;

    return matches >= minimumMatches && matches / courseTokens.length >= 0.6;
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

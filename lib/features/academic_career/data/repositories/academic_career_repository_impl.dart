import '../../domain/entities/academic_career_entity.dart';
import '../../domain/repositories/academic_career_repository.dart';
import '../datasources/academic_career_mock_datasource.dart';

class AcademicCareerRepositoryImpl implements AcademicCareerRepository {
  const AcademicCareerRepositoryImpl(this._dataSource);

  final AcademicCareerMockDataSource _dataSource;

  @override
  Future<AcademicCareerEntity> getAcademicCareer() {
    return _dataSource.getAcademicCareer();
  }
}

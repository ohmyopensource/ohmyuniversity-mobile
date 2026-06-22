import '../../domain/entities/student_badge_entity.dart';
import '../../domain/repositories/student_badge_repository.dart';
import '../datasources/student_badge_remote_datasource.dart';

class StudentBadgeRepositoryImpl implements StudentBadgeRepository {
  const StudentBadgeRepositoryImpl(this._dataSource);

  final StudentBadgeRemoteDataSource _dataSource;

  @override
  Future<StudentBadgeEntity?> getBadge() => _dataSource.getBadge();
}

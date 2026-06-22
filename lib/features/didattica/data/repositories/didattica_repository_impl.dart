import '../../domain/entities/career_snapshot_entity.dart';
import '../../domain/entities/didattica_statistics_entity.dart';
import '../../domain/repositories/didattica_repository.dart';
import '../../domain/services/didattica_statistics_calculator.dart';
import '../datasources/didattica_remote_datasource.dart';

class DidatticaRepositoryImpl implements DidatticaRepository {
  const DidatticaRepositoryImpl(
    this._dataSource, [
    this._calculator = const DidatticaStatisticsCalculator(),
  ]);

  final DidatticaRemoteDataSource _dataSource;
  final DidatticaStatisticsCalculator _calculator;

  @override
  Future<CareerSnapshotEntity> getCareerSnapshot() async {
    final apiData = await _dataSource.getCareerData();
    final courses = apiData.studyPlan.mergeTranscript(
      apiData.transcript.courses,
    );
    final derived = _calculator.calculate(courses);
    final metrics = apiData.metrics;

    return CareerSnapshotEntity(
      courses: courses,
      statistics: DidatticaStatisticsEntity(
        arithmeticAverage:
            metrics.arithmeticAverage ?? derived.arithmeticAverage,
        weightedAverage: metrics.weightedAverage ?? derived.weightedAverage,
        acquiredCredits: metrics.acquiredCredits ?? derived.acquiredCredits,
        totalCredits: metrics.totalCredits ?? derived.totalCredits,
        graduationBase: metrics.graduationBase ?? derived.graduationBase,
        projectedGraduationScore:
            metrics.graduationBase ?? derived.projectedGraduationScore,
        honorsCount: derived.honorsCount,
        gradeHistory: derived.gradeHistory,
        averageTrend: derived.averageTrend,
        hasSimulation: false,
      ),
    );
  }
}

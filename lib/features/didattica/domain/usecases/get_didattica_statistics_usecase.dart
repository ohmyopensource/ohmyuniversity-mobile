import '../entities/didattica_statistics_entity.dart';
import '../repositories/didattica_repository.dart';
import '../services/didattica_statistics_calculator.dart';

class GetDidatticaStatisticsUseCase {
  const GetDidatticaStatisticsUseCase(
    this._repository, [
    this._calculator = const DidatticaStatisticsCalculator(),
  ]);

  final DidatticaRepository _repository;
  final DidatticaStatisticsCalculator _calculator;

  DidatticaStatisticsEntity call() {
    return _calculator.calculate(_repository.getExamCourses());
  }
}

import '../entities/didattica_statistics_entity.dart';
import '../repositories/didattica_repository.dart';

class GetDidatticaStatisticsUseCase {
  const GetDidatticaStatisticsUseCase(this._repository);

  final DidatticaRepository _repository;

  DidatticaStatisticsEntity call() {
    return _repository.getStatistics();
  }
}

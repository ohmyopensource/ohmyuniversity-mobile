import '../../../../core/usecases/usecase.dart';
import '../entities/academic_career_entity.dart';
import '../repositories/academic_career_repository.dart';

class GetAcademicCareerUseCase
    implements UseCase<AcademicCareerEntity, NoParams> {
  const GetAcademicCareerUseCase(this._repository);

  final AcademicCareerRepository _repository;

  @override
  Future<AcademicCareerEntity> call(NoParams params) {
    return _repository.getAcademicCareer();
  }
}

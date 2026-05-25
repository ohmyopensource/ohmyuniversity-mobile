import '../entities/academic_career_entity.dart';

abstract interface class AcademicCareerRepository {
  Future<AcademicCareerEntity> getAcademicCareer();
}

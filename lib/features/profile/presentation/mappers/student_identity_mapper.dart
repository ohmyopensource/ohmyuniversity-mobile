import '../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../../didattica/domain/entities/didattica_statistics_entity.dart';
import '../../domain/entities/student_badge_entity.dart';

StudentIdentityData mapStudentIdentityData({
  required StudentBadgeEntity? badge,
  required DidatticaStatisticsEntity statistics,
  required int totalExams,
  required int passedExams,
}) {
  return StudentIdentityData(
    fullName: badge?.fullName.isNotEmpty == true
        ? badge!.fullName
        : 'Studente',
    studentNumber: badge?.studentNumber ?? '',
    universityName: badge?.universityName ?? '',
    courseName: badge?.courseName ?? '',
    badgeId: badge?.badgeId == null ? '' : 'ID ${badge!.badgeId}',
    rfid: badge?.rfid ?? '',
    honorsCount: statistics.honorsCount,
    passedExamCount: passedExams,
    pendingExamCount: (totalExams - passedExams).clamp(0, totalExams),
  );
}

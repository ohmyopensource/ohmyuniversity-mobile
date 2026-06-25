import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/academic_statistics_entity.dart';
import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/presentation/mappers/student_identity_mapper.dart';

void main() {
  test('maps student badge data into dashboard identity data', () {
    final identity = mapStudentIdentityData(
      badge: _badge,
      statistics: _statistics,
      totalExams: 12,
      passedExams: 8,
    );

    expect(identity.fullName, 'Mario Rossi');
    expect(identity.studentNumber, '123456');
    expect(identity.universityName, 'UNIMOL');
    expect(identity.courseName, 'Informatica');
    expect(identity.badgeId, 'ID 7');
    expect(identity.rfid, 'RFID-7');
    expect(identity.honorsCount, 3);
    expect(identity.passedExamCount, 8);
    expect(identity.pendingExamCount, 4);
  });

  test('maps missing badge data with safe fallbacks', () {
    final identity = mapStudentIdentityData(
      badge: null,
      statistics: AcademicStatisticsEntity.empty,
      totalExams: 3,
      passedExams: 6,
    );

    expect(identity.fullName, 'Studente');
    expect(identity.studentNumber, isEmpty);
    expect(identity.badgeId, isEmpty);
    expect(identity.pendingExamCount, 0);
  });
}

final _statistics = AcademicStatisticsEntity.empty.copyWithHonors(3);

const _badge = StudentBadgeEntity(
  badgeId: 7,
  studentNumber: '123456',
  firstName: 'Mario',
  lastName: 'Rossi',
  taxCode: 'RSSMRA00A01F205X',
  courseCode: 'INF',
  courseName: 'Informatica',
  facultyCode: 'DIBT',
  facultyName: 'Dipartimento di Bioscienze',
  enrollmentYear: 2025,
  rfid: 'RFID-7',
  universityName: 'UNIMOL',
  statusCode: 'A',
  validFrom: null,
  validUntil: null,
  frontImagePresent: true,
  photoUrl: '',
  rearImagePresent: true,
);

extension on AcademicStatisticsEntity {
  AcademicStatisticsEntity copyWithHonors(int honorsCount) {
    return AcademicStatisticsEntity(
      arithmeticAverage: arithmeticAverage,
      weightedAverage: weightedAverage,
      acquiredCredits: acquiredCredits,
      totalCredits: totalCredits,
      graduationBase: graduationBase,
      projectedGraduationScore: projectedGraduationScore,
      honorsCount: honorsCount,
      gradeHistory: gradeHistory,
      averageTrend: averageTrend,
      hasSimulation: hasSimulation,
    );
  }
}

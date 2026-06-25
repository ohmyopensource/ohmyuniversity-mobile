import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/domain/repositories/student_badge_repository.dart';
import 'package:ohmyuniversity/features/profile/domain/usecases/get_student_badge_usecase.dart';

void main() {
  test('student badge use case returns repository data', () async {
    final badge = await GetStudentBadgeUseCase(
      _StudentBadgeRepositoryFake(),
    ).call();

    expect(badge?.fullName, 'Ada Lovelace');
    expect(badge?.academicYear, 'A.A. 2025/2026');
  });
}

class _StudentBadgeRepositoryFake implements StudentBadgeRepository {
  @override
  Future<StudentBadgeEntity?> getBadge() async {
    return StudentBadgeEntity(
      badgeId: 1,
      studentNumber: '12345',
      firstName: 'Ada',
      lastName: 'Lovelace',
      taxCode: 'LVLDAX00A00A000A',
      courseCode: 'L31',
      courseName: 'Informatica',
      facultyCode: 'DIBT',
      facultyName: 'Bioscienze e Territorio',
      enrollmentYear: 2025,
      rfid: 'rfid',
      universityName: 'UNIMOL',
      statusCode: 'ACTIVE',
      validFrom: DateTime(2025, 10, 1),
      validUntil: DateTime(2026, 9, 30),
      frontImagePresent: true,
      photoUrl: '',
      rearImagePresent: true,
    );
  }
}

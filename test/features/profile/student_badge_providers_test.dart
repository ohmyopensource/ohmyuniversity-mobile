import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/domain/repositories/student_badge_repository.dart';
import 'package:ohmyuniversity/features/profile/presentation/providers/student_badge_providers.dart';

void main() {
  test('student badge provider exposes repository badge', () async {
    final container = ProviderContainer(
      overrides: [
        studentBadgeRepositoryProvider.overrideWithValue(
          const _StudentBadgeRepositoryFake(),
        ),
      ],
    );
    addTearDown(container.dispose);

    final badge = await container.read(studentBadgeProvider.future);

    expect(badge?.studentNumber, '123456');
    expect(badge?.academicYear, 'A.A. 2025/2026');
  });
}

class _StudentBadgeRepositoryFake implements StudentBadgeRepository {
  const _StudentBadgeRepositoryFake();

  @override
  Future<StudentBadgeEntity?> getBadge() async {
    return const StudentBadgeEntity(
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
  }
}

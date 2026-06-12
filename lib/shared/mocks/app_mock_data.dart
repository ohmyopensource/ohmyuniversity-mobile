enum MockAccountStatus { active, warning, suspended, withdrawn, graduated }

class MockStudentData {
  const MockStudentData({
    required this.fullName,
    required this.firstName,
    required this.studentId,
    required this.email,
    required this.universityName,
    required this.honorsCount,
    required this.passedExamCount,
    required this.failedExamCount,
  });

  final String fullName;
  final String firstName;
  final String studentId;
  final String email;
  final String universityName;
  final int honorsCount;
  final int passedExamCount;
  final int failedExamCount;

  String get badgeIdLabel => 'ID $studentId';
}

class MockAcademicInfoData {
  const MockAcademicInfoData({
    required this.universityName,
    required this.courseName,
    required this.degreeName,
    required this.academicYear,
  });

  final String universityName;
  final String courseName;
  final String degreeName;
  final String academicYear;
}

class MockAccountData {
  const MockAccountData({
    required this.id,
    required this.name,
    required this.email,
    required this.courseLabel,
    required this.universityLabel,
    required this.courseAcronym,
    required this.status,
    this.isCurrent = false,
  });

  final String id;
  final String name;
  final String email;
  final String courseLabel;
  final String universityLabel;
  final String courseAcronym;
  final MockAccountStatus status;
  final bool isCurrent;
}

abstract final class AppMockData {
  // Mock data used for auth responses until real user profile data is available.
  static const mockUserId = 'mock-user-1';

  // Mock data used for student identity cards and profile greetings.
  static const student = MockStudentData(
    fullName: 'Mario Rossi',
    firstName: 'Mario',
    studentId: '178034',
    email: 'mario.rossi@studenti.unimol.it',
    universityName: 'Universita degli Studi del Molise',
    honorsCount: 2,
    passedExamCount: 21,
    failedExamCount: 6,
  );

  // Mock data used for the Home academic information card.
  static const academicInfo = MockAcademicInfoData(
    universityName: 'Universita Degli Studi Del Molise',
    courseName: 'Informatica',
    degreeName: 'Laurea Triennale',
    academicYear: 'A.A. 2025/2026',
  );

  // Mock data used for the top bar profile switcher until account data is provided.
  static final List<MockAccountData> topBarAccounts = [
    MockAccountData(
      id: '1',
      name: student.fullName,
      email: student.email,
      courseLabel: 'Ingegneria Informatica',
      universityLabel: 'Universita degli Studi di Milano',
      courseAcronym: 'LM',
      status: MockAccountStatus.active,
      isCurrent: true,
    ),
    MockAccountData(
      id: '2',
      name: student.fullName,
      email: student.email,
      courseLabel: academicInfo.courseName,
      universityLabel: 'Universita degli Studi di Milano',
      courseAcronym: 'L',
      status: MockAccountStatus.graduated,
    ),
    MockAccountData(
      id: '3',
      name: student.fullName,
      email: student.email,
      courseLabel: 'Fisica Teorica',
      universityLabel: 'Universita degli Studi di Milano',
      courseAcronym: 'LM',
      status: MockAccountStatus.withdrawn,
    ),
  ];
}

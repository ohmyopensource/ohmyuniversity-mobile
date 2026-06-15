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

class MockUniversityData {
  const MockUniversityData({
    required this.name,
    required this.websiteUrl,
    required this.mailUrl,
  });

  final String name;
  final String websiteUrl;
  final String mailUrl;
}

class MockExamCourseData {
  const MockExamCourseData({
    required this.id,
    required this.year,
    required this.semester,
    required this.name,
    required this.code,
    required this.credits,
    required this.passed,
    this.grade,
    this.courseType = 'mandatory',
    this.completedAt,
  });

  final String id;
  final int year;
  final int semester;
  final String name;
  final String code;
  final int credits;
  final bool passed;
  final String? grade;
  final String courseType;
  final DateTime? completedAt;
}

class MockExamAppealData {
  const MockExamAppealData({
    required this.id,
    required this.examName,
    required this.month,
    required this.date,
    required this.time,
    required this.isBooked,
    this.isBookable = false,
    this.room,
  });

  final String id;
  final String examName;
  final int month;
  final DateTime date;
  final String time;
  final bool isBooked;
  final bool isBookable;
  final String? room;
}

class MockExamAppealMonthData {
  const MockExamAppealMonthData({required this.month, required this.year});

  final int month;
  final int year;
}

class MockTuitionFeeData {
  const MockTuitionFeeData({
    required this.id,
    required this.title,
    required this.amount,
    required this.isPaid,
  });

  final String id;
  final String title;
  final double amount;
  final bool isPaid;
}

class MockAverageTrendPointData {
  const MockAverageTrendPointData({required this.date, required this.value});

  final DateTime date;
  final double value;
}

class MockAcademicCareerExamData {
  const MockAcademicCareerExamData({
    required this.id,
    required this.name,
    required this.grade,
    required this.credits,
    required this.date,
    this.hasHonors = false,
  });

  final String id;
  final String name;
  final int grade;
  final int credits;
  final DateTime date;
  final bool hasHonors;
}

class MockCalendarEventData {
  const MockCalendarEventData({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.endDate,
    required this.type,
    required this.location,
    this.isAllDay = false,
  });

  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;
  final String type;
  final String location;
  final bool isAllDay;
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

  // Mock data used by the app drawer until university service links are provided.
  static const university = MockUniversityData(
    name: 'UNIMOL',
    websiteUrl: 'https://www.unimol.it',
    mailUrl: 'https://mail.unimol.it',
  );

  // Mock data used by Didattica exam lists until real study plan data is available.
  static final List<MockExamCourseData> didatticaExamCourses = [
    MockExamCourseData(
      id: 'exam-1-1-1',
      year: 1,
      semester: 1,
      name: 'Fondamenti di Informatica',
      code: 'INF/01',
      credits: 9,
      grade: '30',
      passed: true,
      completedAt: DateTime(2024, 2, 14),
    ),
    MockExamCourseData(
      id: 'exam-1-1-2',
      year: 1,
      semester: 1,
      name: 'Algebra Lineare',
      code: 'MAT/03',
      credits: 6,
      grade: '30',
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-1-1-3',
      year: 1,
      semester: 1,
      name: 'Architettura degli Elaboratori',
      code: 'INF/01',
      credits: 9,
      grade: '27',
      passed: true,
      completedAt: DateTime(2024, 3, 4),
    ),
    MockExamCourseData(
      id: 'exam-1-1-4',
      year: 1,
      semester: 1,
      name: 'Matematica Discreta',
      code: 'MAT/02',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-1-2-1',
      year: 1,
      semester: 2,
      name: 'Programmazione I',
      code: 'INF/01',
      credits: 12,
      grade: '28',
      passed: true,
      completedAt: DateTime(2024, 6, 20),
    ),
    MockExamCourseData(
      id: 'exam-1-2-2',
      year: 1,
      semester: 2,
      name: 'Analisi Matematica I',
      code: 'MAT/05',
      credits: 9,
      grade: '26',
      passed: true,
      completedAt: DateTime(2024, 7, 8),
    ),
    MockExamCourseData(
      id: 'exam-1-2-3',
      year: 1,
      semester: 2,
      name: 'Fisica Generale',
      code: 'FIS/01',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-1-2-4',
      year: 1,
      semester: 2,
      name: 'Statistica',
      code: 'SECS-S/01',
      credits: 6,
      grade: '25',
      passed: true,
      completedAt: DateTime(2024, 9, 12),
    ),
    MockExamCourseData(
      id: 'exam-1-2-5',
      year: 1,
      semester: 2,
      name: 'Economia Aziendale',
      code: 'SECS-P/07',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-2-1-1',
      year: 2,
      semester: 1,
      name: 'Basi di Dati',
      code: 'INF/01',
      credits: 9,
      grade: '30L',
      passed: true,
      completedAt: DateTime(2025, 2, 18),
    ),
    MockExamCourseData(
      id: 'exam-2-1-2',
      year: 2,
      semester: 1,
      name: 'Sistemi Operativi',
      code: 'INF/01',
      credits: 9,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-2-1-3',
      year: 2,
      semester: 1,
      name: 'Algoritmi e Strutture Dati',
      code: 'INF/01',
      credits: 12,
      grade: '28',
      passed: true,
      completedAt: DateTime(2025, 3, 7),
    ),
    MockExamCourseData(
      id: 'exam-2-1-4',
      year: 2,
      semester: 1,
      name: 'Calcolo delle Probabilita',
      code: 'MAT/06',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-2-2-1',
      year: 2,
      semester: 2,
      name: 'Reti di Calcolatori',
      code: 'INF/01',
      credits: 9,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-2-2-2',
      year: 2,
      semester: 2,
      name: 'Ingegneria del Software',
      code: 'INF/01',
      credits: 9,
      grade: '29',
      passed: true,
      completedAt: DateTime(2025, 6, 16),
    ),
    MockExamCourseData(
      id: 'exam-2-2-3',
      year: 2,
      semester: 2,
      name: 'Sistemi Informativi',
      code: 'INF/01',
      credits: 6,
      grade: '27',
      passed: true,
      completedAt: DateTime(2025, 7, 3),
    ),
    MockExamCourseData(
      id: 'exam-2-2-4',
      year: 2,
      semester: 2,
      name: 'Interazione Uomo-Macchina',
      code: 'INF/01',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-3-1-1',
      year: 3,
      semester: 1,
      name: 'Machine Learning',
      code: 'INF/01',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-3-1-2',
      year: 3,
      semester: 1,
      name: 'Sicurezza Informatica',
      code: 'INF/01',
      credits: 6,
      grade: '27',
      passed: true,
      completedAt: DateTime(2026, 2, 10),
    ),
    MockExamCourseData(
      id: 'exam-3-1-3',
      year: 3,
      semester: 1,
      name: 'Sviluppo Mobile',
      code: 'INF/01',
      credits: 6,
      grade: '30',
      passed: true,
      completedAt: DateTime(2026, 3, 2),
    ),
    MockExamCourseData(
      id: 'exam-3-1-4',
      year: 3,
      semester: 1,
      name: 'Cloud Computing',
      code: 'INF/01',
      credits: 6,
      passed: false,
      courseType: 'elective',
    ),
    MockExamCourseData(
      id: 'exam-3-2-1',
      year: 3,
      semester: 2,
      name: 'Tirocinio',
      code: 'Stage',
      credits: 12,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-3-2-2',
      year: 3,
      semester: 2,
      name: 'Prova finale',
      code: 'Tesi',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'exam-3-2-3',
      year: 3,
      semester: 2,
      name: 'Data Visualization',
      code: 'INF/01',
      credits: 6,
      grade: '28',
      passed: true,
      completedAt: DateTime(2026, 6, 5),
      courseType: 'elective',
    ),
    MockExamCourseData(
      id: 'exam-3-2-4',
      year: 3,
      semester: 2,
      name: "Etica e Diritto dell'Informatica",
      code: 'IUS/20',
      credits: 6,
      passed: false,
      courseType: 'elective',
    ),
  ];

  // Mock data used by Didattica exam appeals until real booking data is available.
  static final List<MockExamAppealData> examAppeals = [
    MockExamAppealData(
      id: 'appeal-june-1',
      examName: 'Fondamenti di Informatica',
      month: 6,
      date: DateTime(2026, 6, 18),
      time: '09:30',
      room: 'Aula Magna',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-june-3',
      examName: 'Architettura degli Elaboratori',
      month: 6,
      date: DateTime(2026, 6, 27),
      time: '11:00',
      room: 'Aula A3',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-june-4',
      examName: 'Matematica Discreta',
      month: 6,
      date: DateTime(2026, 6, 30),
      time: '16:00',
      room: 'Aula M2',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-june-5',
      examName: 'Lingua Inglese',
      month: 6,
      date: DateTime(2026, 6, 12),
      time: '08:45',
      room: 'Aula L1',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-june-2',
      examName: 'Algebra Lineare',
      month: 6,
      date: DateTime(2026, 6, 24),
      time: '14:00',
      room: 'Aula B2',
      isBooked: false,
      isBookable: true,
    ),
    MockExamAppealData(
      id: 'appeal-june-6',
      examName: 'Fisica Generale',
      month: 6,
      date: DateTime(2026, 6, 26),
      time: '12:30',
      room: 'Aula F1',
      isBooked: false,
      isBookable: false,
    ),
    MockExamAppealData(
      id: 'appeal-july-1',
      examName: 'Programmazione I',
      month: 7,
      date: DateTime(2026, 7, 9),
      time: '10:00',
      room: 'Lab 3',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-july-2',
      examName: 'Analisi Matematica I',
      month: 7,
      date: DateTime(2026, 7, 16),
      time: '11:30',
      room: 'Aula C1',
      isBooked: false,
      isBookable: false,
    ),
    MockExamAppealData(
      id: 'appeal-september-1',
      examName: 'Basi di Dati',
      month: 9,
      date: DateTime(2026, 9, 8),
      time: '09:00',
      room: 'Aula 5',
      isBooked: false,
      isBookable: true,
    ),
    MockExamAppealData(
      id: 'appeal-september-2',
      examName: 'Sistemi Operativi',
      month: 9,
      date: DateTime(2026, 9, 21),
      time: '15:00',
      room: 'Aula D4',
      isBooked: true,
    ),
    MockExamAppealData(
      id: 'appeal-october-1',
      examName: 'Reti di Calcolatori',
      month: 10,
      date: DateTime(2026, 10, 6),
      time: '12:00',
      room: 'Aula B1',
      isBooked: false,
      isBookable: false,
    ),
    MockExamAppealData(
      id: 'appeal-january-1',
      examName: 'Machine Learning',
      month: 1,
      date: DateTime(2027, 1, 19),
      time: '10:30',
      room: 'Lab AI',
      isBooked: false,
      isBookable: true,
    ),
    MockExamAppealData(
      id: 'appeal-february-1',
      examName: 'Sicurezza Informatica',
      month: 2,
      date: DateTime(2027, 2, 4),
      time: '09:30',
      room: 'Aula S1',
      isBooked: true,
    ),
  ];

  // Mock data used by Home dashboard exam preview widgets.
  static const dashboardExamCourses = [
    MockExamCourseData(
      id: 'fondamenti-informatica',
      year: 1,
      semester: 1,
      name: 'Fondamenti di Informatica',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '30',
    ),
    MockExamCourseData(
      id: 'algebra-lineare',
      year: 1,
      semester: 1,
      name: 'Algebra Lineare',
      code: 'MAT/03',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'architettura-elaboratori',
      year: 1,
      semester: 2,
      name: 'Architettura degli Elaboratori',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '27',
    ),
    MockExamCourseData(
      id: 'matematica-discreta',
      year: 1,
      semester: 2,
      name: 'Matematica Discreta',
      code: 'MAT/02',
      credits: 6,
      passed: false,
    ),
    MockExamCourseData(
      id: 'basi-dati',
      year: 2,
      semester: 1,
      name: 'Basi di Dati',
      code: 'INF/01',
      credits: 9,
      passed: true,
      grade: '30L',
    ),
    MockExamCourseData(
      id: 'sistemi-operativi',
      year: 2,
      semester: 1,
      name: 'Sistemi Operativi',
      code: 'INF/01',
      credits: 9,
      passed: false,
    ),
    MockExamCourseData(
      id: 'reti-calcolatori',
      year: 3,
      semester: 1,
      name: 'Reti di Calcolatori',
      code: 'INF/01',
      credits: 6,
      passed: false,
    ),
  ];

  // Mock data used by Home dashboard exam appeal preview widgets.
  static const dashboardAppealMonths = [
    MockExamAppealMonthData(month: 6, year: 2026),
    MockExamAppealMonthData(month: 7, year: 2026),
    MockExamAppealMonthData(month: 9, year: 2026),
  ];

  // Mock data used by Home dashboard exam appeal preview widgets.
  static final List<MockExamAppealData> dashboardExamAppeals = [
    MockExamAppealData(
      id: 'programmazione-booked',
      examName: 'Programmazione I',
      month: 6,
      date: DateTime(2026, 6, 18),
      time: '09:30',
      isBooked: true,
      room: 'Aula 2',
    ),
    MockExamAppealData(
      id: 'analisi-booked',
      examName: 'Analisi Matematica',
      month: 6,
      date: DateTime(2026, 6, 26),
      time: '11:00',
      isBooked: true,
      room: 'Aula Magna',
    ),
    MockExamAppealData(
      id: 'basi-dati-open',
      examName: 'Basi di Dati',
      month: 6,
      date: DateTime(2026, 6, 30),
      time: '10:00',
      isBooked: false,
      isBookable: true,
      room: 'Lab 1',
    ),
    MockExamAppealData(
      id: 'reti-disabled',
      examName: 'Reti di Calcolatori',
      month: 6,
      date: DateTime(2026, 6, 28),
      time: '15:00',
      isBooked: false,
      isBookable: false,
      room: 'Aula 5',
    ),
  ];

  // Mock data used by Home dashboard tuition widgets.
  static const tuitionFees = [
    MockTuitionFeeData(
      id: 'regional-tax',
      title: 'Tassa Regionale',
      amount: 150,
      isPaid: false,
    ),
  ];

  // Mock data used by Home dashboard average trend widgets.
  static final List<MockAverageTrendPointData> averageTrend = [
    MockAverageTrendPointData(date: DateTime(2026, 5, 23), value: 30),
    MockAverageTrendPointData(date: DateTime(2026, 6, 20), value: 28.8),
    MockAverageTrendPointData(date: DateTime(2026, 7, 18), value: 27.2),
    MockAverageTrendPointData(date: DateTime(2026, 8, 28), value: 25.5),
  ];

  // Mock data used by Home dashboard graduation projection widgets.
  static const graduationProjection = 90.0;
  static const graduationProjectionMax = 110.0;

  // Mock data used by Home dashboard academic metric widgets.
  static const dashboardArithmeticAverage = '25.5';
  static const dashboardWeightedAverage = '25.5';
  static const dashboardAcquiredCredits = 90;
  static const dashboardTotalCredits = 180;
  static const dashboardCreditsProgress = 0.5;
  static const dashboardCreditsValue = '90/180';
  static const dashboardCreditsCaption = '90 CFU completati su 180';

  // Mock data used by Academic Career until real career data is available.
  static final List<MockAcademicCareerExamData> academicCareerExams = [
    MockAcademicCareerExamData(
      id: 'exam-1',
      name: 'Programmazione I',
      grade: 28,
      credits: 9,
      date: DateTime(2025, 2, 12),
    ),
    MockAcademicCareerExamData(
      id: 'exam-2',
      name: 'Analisi Matematica',
      grade: 26,
      credits: 12,
      date: DateTime(2025, 6, 18),
    ),
    MockAcademicCareerExamData(
      id: 'exam-3',
      name: 'Basi di Dati',
      grade: 30,
      credits: 9,
      date: DateTime(2026, 1, 24),
      hasHonors: true,
    ),
  ];

  // Mock data used by Academic Career until real total credits data is available.
  static const academicCareerTotalCredits = 180;

  // Mock data used by Calendar agenda until backend CRUD is available.
  static final List<MockCalendarEventData> calendarEvents = [
    MockCalendarEventData(
      id: 'calendar-event-1',
      title: 'Sprint Planning',
      description: 'Pianificazione settimanale delle attivita.',
      startDate: _calendarDateAt(hour: 10),
      endDate: _calendarDateAt(hour: 11),
      type: 'event',
      location: 'Aula virtuale',
    ),
    MockCalendarEventData(
      id: 'calendar-event-2',
      title: 'Design Review',
      description: 'Revisione interfacce calendario.',
      startDate: _calendarDateAt(hour: 11),
      endDate: _calendarDateAt(hour: 11, minute: 30),
      type: 'reminder',
      location: 'Laboratorio',
    ),
    MockCalendarEventData(
      id: 'calendar-event-3',
      title: 'Esame Basi di Dati',
      description: 'Appello scritto.',
      startDate: _calendarDateAt(hour: 11, minute: 45),
      endDate: _calendarDateAt(hour: 13, minute: 15),
      type: 'exam',
      location: 'Aula 5',
    ),
    MockCalendarEventData(
      id: 'calendar-event-4',
      title: 'Promemoria iscrizione',
      description: 'Controllare la scadenza di prenotazione.',
      startDate: _calendarDateAt(hour: 14),
      endDate: _calendarDateAt(hour: 14, minute: 30),
      type: 'reminder',
      location: 'Segreteria online',
    ),
    MockCalendarEventData(
      id: 'calendar-event-5',
      title: 'Ricevimento docente',
      description: 'Incontro per chiarimenti sul progetto.',
      startDate: _calendarDateAt(hour: 15, minute: 30),
      endDate: _calendarDateAt(hour: 16, minute: 30),
      type: 'event',
      location: 'Studio docente',
    ),
  ];

  static DateTime _calendarDateAt({required int hour, int minute = 0}) {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }
}

import '../../domain/entities/course_questionnaire_entity.dart';

final questionnairesMockData = <CourseQuestionnaireEntity>[
  CourseQuestionnaireEntity(
    id: 'q1',
    courseName: 'Algoritmi e Strutture Dati',
    professor: 'Prof. Mario Bianchi',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.pending,
    deadline: DateTime(2026, 6, 25),
  ),
  CourseQuestionnaireEntity(
    id: 'q2',
    courseName: 'Sistemi Operativi',
    professor: 'Prof. Laura Conti',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.pending,
    deadline: DateTime(2026, 6, 28),
  ),
  CourseQuestionnaireEntity(
    id: 'q3',
    courseName: 'Analisi Matematica II',
    professor: 'Prof. Carla Russo',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.completed,
    completedAt: DateTime(2026, 5, 15),
  ),
  CourseQuestionnaireEntity(
    id: 'q4',
    courseName: 'Programmazione I',
    professor: 'Prof. Marco Esposito',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.completed,
    completedAt: DateTime(2026, 2, 2),
  ),
  CourseQuestionnaireEntity(
    id: 'q5',
    courseName: 'Basi di Dati',
    professor: 'Prof. Giovanni Serra',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.pending,
    deadline: DateTime(2026, 7, 1),
  ),
  CourseQuestionnaireEntity(
    id: 'q6',
    courseName: 'Ingegneria del Software',
    professor: 'Prof. Federica Longo',
    type: 'Valutazione della didattica',
    status: CourseQuestionnaireStatus.completed,
    completedAt: DateTime(2026, 5, 30),
  ),
];

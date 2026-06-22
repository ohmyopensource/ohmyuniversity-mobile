import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/didattica/domain/entities/didattica_course_type.dart';
import 'package:ohmyuniversity/features/didattica/presentation/providers/career_data_providers.dart';
import 'package:ohmyuniversity/features/didattica/presentation/providers/career_provider.dart';
import 'package:ohmyuniversity/features/didattica/presentation/views/career_overview_view.dart';

import '../../helpers/career_test_snapshot.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('renders the career dashboard at 320 px without overflow', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          careerSnapshotProvider.overrideWith(
            (ref) async => buildCareerTestSnapshot(),
          ),
        ],
        child: const MaterialApp(home: Scaffold(body: CareerOverviewView())),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('AVANZAMENTO PERCORSO'), findsOneWidget);
    expect(find.text('PROIEZIONE DI LAUREA'), findsOneWidget);
    expect(find.text('Media aritmetica'), findsOneWidget);
    expect(tester.takeException(), isNull);
    expect(
      tester.getSize(find.byKey(const Key('career-path-progress-card'))).height,
      tester
          .getSize(find.byKey(const Key('career-graduation-projection-card')))
          .height,
    );

    await tester.scrollUntilVisible(
      find.text('Piano di studi'),
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pump();
    expect(find.text('Piano di studi'), findsOneWidget);
    expect(find.text('Primo semestre'), findsWidgets);
    expect(find.text('Secondo semestre'), findsWidgets);
    expect(find.text('Esami a scelta'), findsNothing);
    expect(find.text('Data Visualization'), findsOneWidget);
    expect(tester.takeException(), isNull);

    final pendingExam = find.byKey(const Key('career-exam-exam-1-1-2'));
    await tester.scrollUntilVisible(
      pendingExam,
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.getSize(find.byKey(const Key('career-exam-exam-3-1-1'))).height,
      tester.getSize(find.byKey(const Key('career-exam-exam-3-1-2'))).height,
    );
    expect(
      tester.getSize(find.byKey(const Key('career-exam-exam-1-1-2'))).height,
      tester.getSize(find.byKey(const Key('career-exam-exam-1-1-3'))).height,
    );

    await tester.tap(find.byKey(const Key('course-info-exam-1-1-2')));
    await tester.pumpAndSettle();
    expect(find.byKey(const Key('course-details-list')), findsOneWidget);
    expect(find.text('Lingua'), findsOneWidget);
    expect(find.text('Vai alle prenotazioni'), findsNothing);
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows and clears the floating simulation indicator', (
    tester,
  ) async {
    final container = _careerContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: CareerOverviewView())),
      ),
    );
    await tester.pumpAndSettle();

    final pendingCourse = container
        .read(careerProvider)
        .courses
        .firstWhere((course) => !course.passed);
    container
        .read(careerProvider.notifier)
        .setSimulatedGrade(pendingCourse.id, '30');
    await tester.pump(const Duration(milliseconds: 250));

    var indicator = tester.widget<AnimatedScale>(
      find.byKey(const Key('simulation-mode-indicator')),
    );
    expect(indicator.scale, 1);
    expect(container.read(careerStatisticsProvider).hasSimulation, isTrue);
    final indicatorCenter = tester.getCenter(
      find.byKey(const Key('simulation-mode-indicator')),
    );
    final screenCenter =
        tester.view.physicalSize.width / tester.view.devicePixelRatio / 2;
    expect(indicatorCenter.dx, closeTo(screenCenter, 1));

    container.read(careerProvider.notifier).clearSimulations();
    await tester.pump(const Duration(milliseconds: 250));

    indicator = tester.widget<AnimatedScale>(
      find.byKey(const Key('simulation-mode-indicator')),
    );
    expect(indicator.scale, 0);
  });

  testWidgets('selects a simulated grade with the scrolling wheel', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final container = _careerContainer();
    addTearDown(container.dispose);
    const courseId = 'exam-1-1-2';

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: CareerOverviewView())),
      ),
    );
    await tester.pumpAndSettle();

    final simulateButton = find.byKey(const Key('simulate-$courseId'));
    await tester.scrollUntilVisible(
      simulateButton,
      500,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.ensureVisible(simulateButton);
    await tester.pump();
    await tester.tap(simulateButton);
    await tester.pumpAndSettle();

    expect(find.byKey(const Key('grade-wheel-picker')), findsOneWidget);
    expect(find.byKey(const Key('simulation-grade-18')), findsNothing);

    expect(find.byKey(const Key('confirm-simulated-grade')), findsNothing);
    await tester.tap(find.byKey(const Key('grade-wheel-value-18')));
    await tester.pumpAndSettle();

    expect(container.read(careerProvider).simulatedGrades[courseId], '18');
    expect(tester.takeException(), isNull);
  });

  test('combines year and status filters', () {
    final container = _careerContainer();
    addTearDown(container.dispose);
    final controller = container.read(careerProvider.notifier);

    controller.setYearFilter('elective');
    expect(
      container
          .read(careerProvider)
          .visibleCourses
          .every((course) => course.courseType == DidatticaCourseType.elective),
      isTrue,
    );

    controller.setExamFilter(CareerExamFilter.passed);
    expect(
      container
          .read(careerProvider)
          .visibleCourses
          .every((course) => course.passed),
      isTrue,
    );
  });
}

ProviderContainer _careerContainer() {
  return ProviderContainer(
    overrides: [
      careerSnapshotProvider.overrideWith(
        (ref) async => buildCareerTestSnapshot(),
      ),
    ],
  );
}

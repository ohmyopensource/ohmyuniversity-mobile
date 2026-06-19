import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/didattica/domain/entities/didattica_course_type.dart';
import 'package:ohmyuniversity/features/didattica/presentation/providers/career_provider.dart';
import 'package:ohmyuniversity/features/didattica/presentation/views/career_overview_view.dart';

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
      const ProviderScope(
        child: MaterialApp(home: Scaffold(body: CareerOverviewView())),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

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
    expect(tester.takeException(), isNull);
  });

  testWidgets('shows and clears the floating simulation indicator', (
    tester,
  ) async {
    final container = ProviderContainer();
    addTearDown(container.dispose);

    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const MaterialApp(home: Scaffold(body: CareerOverviewView())),
      ),
    );
    await tester.pump();

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

    container.read(careerProvider.notifier).clearSimulations();
    await tester.pump(const Duration(milliseconds: 250));

    indicator = tester.widget<AnimatedScale>(
      find.byKey(const Key('simulation-mode-indicator')),
    );
    expect(indicator.scale, 0);
  });

  test('combines year and status filters', () {
    final container = ProviderContainer();
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

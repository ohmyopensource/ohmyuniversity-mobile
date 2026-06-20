import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ohmyuniversity/features/home/presentation/models/dashboard_widget_option.dart';
import 'package:ohmyuniversity/features/home/presentation/widgets/dashboard/dashboard_widget_content.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_summary_tiles.dart';
import 'package:ohmyuniversity/shared/widgets/academic/academic_history_chart.dart';
import 'package:ohmyuniversity/shared/widgets/custom_tab/custom_tab_widget.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final careerOptions = [
    DashboardWidgetOptions.arithmeticAverage,
    DashboardWidgetOptions.weightedAverage,
    DashboardWidgetOptions.averagePair,
    DashboardWidgetOptions.acquiredCredits,
    DashboardWidgetOptions.acquiredCreditsCompact,
    DashboardWidgetOptions.graduationProjection,
    DashboardWidgetOptions.graduationBase,
    DashboardWidgetOptions.honors,
    DashboardWidgetOptions.gradeHistory,
    DashboardWidgetOptions.averageTrend,
  ];

  for (final option in careerOptions) {
    testWidgets('${option.key} renders inside its dashboard size', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(
                child: SizedBox(
                  width: option.size.width,
                  height: option.size.height,
                  child: DashboardWidgetContent(option: option),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));

      expect(tester.takeException(), isNull);
    });
  }

  testWidgets('average widgets keep their original layout on white surfaces', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 96,
              height: 98,
              child: DashboardWidgetContent(
                option: DashboardWidgetOptions.arithmeticAverage,
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      tester
          .widget<CareerMetricTile>(find.byType(CareerMetricTile))
          .whiteSurface,
      isTrue,
    );
    expect(_hasVisibleWhiteValuePill(tester), isTrue);

    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 204,
              height: 98,
              child: DashboardWidgetContent(
                option: DashboardWidgetOptions.averagePair,
              ),
            ),
          ),
        ),
      ),
    );

    expect(
      tester
          .widget<CareerAveragePairTile>(find.byType(CareerAveragePairTile))
          .whiteSurface,
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('exam filters use symmetric full-width pill tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 304,
              height: 322,
              child: DashboardWidgetContent(
                option: DashboardWidgetOptions.exams,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final yearTabs = tester.widget<CustomTabWidget>(
      find.byKey(const Key('home-exams-year-tabs')),
    );
    final semesterTabs = tester.widget<CustomTabWidget>(
      find.byKey(const Key('home-exams-semester-tabs')),
    );
    expect(yearTabs.fullWidth, isTrue);
    expect(semesterTabs.fullWidth, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('appeals widget follows the new compact visual language', (
    tester,
  ) async {
    const option = DashboardWidgetOptions.appeals;
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SizedBox(
                width: 304,
                height: 314,
                child: DashboardWidgetContent(option: option),
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('Prossimi appelli'), findsOneWidget);
    final firstAppealPill = tester.widget<Container>(
      find.byKey(const Key('home-appeal-pill-e1')),
    );
    expect((firstAppealPill.decoration as BoxDecoration).color, Colors.white);
    expect(tester.takeException(), isNull);
  });

  testWidgets('history chart exposes mobile axes and forgiving dot touch', (
    tester,
  ) async {
    final points = [
      AcademicHistoryPoint(date: DateTime(2026, 1, 10), value: 18),
      AcademicHistoryPoint(date: DateTime(2026, 2, 12), value: 24),
      AcademicHistoryPoint(date: DateTime(2026, 3, 14), value: 30),
    ];
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: SizedBox(
              width: 280,
              height: 210,
              child: AcademicHistoryChart(
                title: 'Storico media ponderata',
                points: points,
                color: Colors.blue,
                compact: true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 350));

    final chart = tester.widget<LineChart>(find.byType(LineChart));
    expect(chart.data.minY, 18);
    expect(chart.data.maxY, 30.5);
    expect(chart.data.titlesData.leftTitles.sideTitles.showTitles, isTrue);
    expect(chart.data.titlesData.bottomTitles.sideTitles.showTitles, isTrue);
    expect(chart.data.lineTouchData.touchSpotThreshold, 24);
    expect(find.textContaining('Ultimo'), findsOneWidget);
    expect(find.textContaining('Min'), findsOneWidget);
    expect(find.textContaining('Max'), findsOneWidget);

    final bounds = tester.getRect(find.byType(LineChart));
    await tester.tapAt(
      Offset(
        bounds.left + bounds.width * .53,
        bounds.top + bounds.height * .52,
      ),
    );
    await tester.pump();
    expect(tester.takeException(), isNull);
  });
}

bool _hasVisibleWhiteValuePill(WidgetTester tester) {
  return tester
      .widgetList<Container>(find.byType(Container))
      .map((container) => container.decoration)
      .whereType<BoxDecoration>()
      .any((decoration) {
        final radius = decoration.borderRadius;
        return decoration.color == Colors.white &&
            radius is BorderRadius &&
            radius.topLeft.x == 999 &&
            decoration.boxShadow?.isNotEmpty == true;
      });
}

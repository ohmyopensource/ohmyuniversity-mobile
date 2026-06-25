import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_geographic_study_section.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_how_university_works_section.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_university_access_section.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_university_life_section.dart';

void main() {
  testWidgets('university access section renders access types and TOLC cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: OrientationUniversityAccessSection(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Libero o a numero chiuso?'), findsOneWidget);
    expect(find.textContaining('TOLC'), findsWidgets);
    expect(find.text('CISIA - Simulazioni gratuite dei TOLC'), findsOneWidget);
    expect(find.text('Cosa fare concretamente'), findsOneWidget);
  });

  testWidgets('geographic section switches area and expands a city', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: OrientationGeographicStudySection(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Confronto tra aree geografiche'), findsOneWidget);
    expect(find.text('Costi medi per area geografica'), findsOneWidget);

    await tester.tap(find.text('Centro').first);
    await tester.pump();

    expect(find.textContaining('Costi'), findsWidgets);

    await tester.ensureVisible(find.textContaining('Bologna').first);
    await tester.tap(find.textContaining('Bologna').first);
    await tester.pumpAndSettle();

    expect(find.textContaining('categoria'), findsWidgets);
  });

  testWidgets('how university works section expands difference cards', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: OrientationHowUniversityWorksSection(),
            ),
          ),
        ),
      ),
    );

    expect(find.textContaining('Scuola vs'), findsOneWidget);
    expect(find.text('Cosa sono i CFU?'), findsOneWidget);
    expect(find.text('Tipi di esame'), findsOneWidget);

    await tester.tap(find.text('Frequenza'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Universit'), findsWidgets);
  });

  testWidgets('university life section renders weekly workload and study tips', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: OrientationUniversityLifeSection(),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Come si distribuisce la settimana'), findsOneWidget);
    expect(find.text('Gli orari delle lezioni'), findsOneWidget);
    expect(find.textContaining('Studio individuale'), findsWidgets);
    expect(find.textContaining('ore'), findsWidgets);
  });
}

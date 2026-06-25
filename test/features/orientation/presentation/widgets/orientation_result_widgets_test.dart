import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/features/orientation/domain/entities/orientation_answer_entity.dart';
import 'package:ohmyuniversity/features/orientation/domain/entities/orientation_question_entity.dart';
import 'package:ohmyuniversity/features/orientation/domain/entities/orientation_result_entity.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_answer_summary_card.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_area_score_card.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_expandable_card.dart';
import 'package:ohmyuniversity/features/orientation/presentation/widgets/orientation_lesson_card.dart';

void main() {
  testWidgets('orientation score and expandable cards render details', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                OrientationAreaScoreCard(
                  area: _area,
                  position: 1,
                ),
                OrientationExpandableCard(
                  icon: LucideIcons.bookOpen,
                  title: 'Area scientifica',
                  subtitle: 'Metodo, logica e laboratorio',
                  description: 'Approfondisci corsi e sbocchi prima di scegliere.',
                  chips: ['STEM', 'Laboratori'],
                ),
                OrientationLessonCard(
                  icon: LucideIcons.clock,
                  title: 'Organizza lo studio',
                  description: 'Pianifica blocchi realistici.',
                  detail: 'Alterna lezioni, ripasso e pause per mantenere continuita.',
                  chips: ['Metodo', 'Routine'],
                  tappable: true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('#1'), findsOneWidget);
    expect(find.text('Scientifica'), findsOneWidget);
    expect(find.text('78%'), findsOneWidget);
    expect(find.text('Area scientifica'), findsOneWidget);
    expect(find.text('Organizza lo studio'), findsOneWidget);
    expect(find.text('Scopri'), findsOneWidget);

    await tester.tap(find.text('Area scientifica'));
    await tester.tap(find.text('Organizza lo studio'));
    await tester.pumpAndSettle();

    expect(find.text('Approfondisci corsi e sbocchi prima di scegliere.'), findsOneWidget);
    expect(find.text('STEM'), findsOneWidget);
    expect(find.text('Alterna lezioni, ripasso e pause per mantenere continuita.'), findsOneWidget);
    expect(find.text('Routine'), findsOneWidget);
    expect(find.text('Riduci'), findsOneWidget);
  });

  testWidgets('answer summary expands and emits selected option', (tester) async {
    OrientationOptionEntity? selected;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrientationAnswerSummaryCard(
            question: _question,
            answer: _answer,
            onSelected: (option) => selected = option,
          ),
        ),
      ),
    );

    expect(find.text('Quale area preferisci?'), findsOneWidget);
    expect(find.text('Scientifica'), findsOneWidget);
    expect(find.text('Economica'), findsNothing);

    await tester.tap(find.text('Quale area preferisci?'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Economica'));
    await tester.pump();

    expect(selected?.value, 'economica');
  });

  testWidgets('answer summary shows missing answer state', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: OrientationAnswerSummaryCard(
            question: _question,
            answer: null,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(find.text('Risposta mancante'), findsOneWidget);
  });
}

const _area = OrientationAreaScoreEntity(
  id: 'scientifica',
  label: 'Scientifica',
  score: 14,
  percentage: 78,
);

const _question = OrientationQuestionEntity(
  id: 'area',
  topicId: 'corso',
  text: 'Quale area preferisci?',
  required: true,
  options: [
    OrientationOptionEntity(value: 'scientifica', label: 'Scientifica'),
    OrientationOptionEntity(value: 'economica', label: 'Economica'),
  ],
);

const _answer = OrientationAnswerEntity(
  questionId: 'area',
  topicId: 'corso',
  value: 'scientifica',
  label: 'Scientifica',
);

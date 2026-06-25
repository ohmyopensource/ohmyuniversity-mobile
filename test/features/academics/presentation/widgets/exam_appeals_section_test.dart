import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_entity.dart';
import 'package:ohmyuniversity/features/academics/domain/entities/exam_appeal_month_entity.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeal_months_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/providers/exam_appeals_provider.dart';
import 'package:ohmyuniversity/features/academics/presentation/widgets/exam_appeals_section.dart';

void main() {
  testWidgets('exam appeals section maps appeals and months into the panel', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          examAppealsProvider.overrideWithValue([
            ExamAppealEntity(
              id: 'appeal-1',
              examName: 'Programmazione',
              month: 6,
              date: DateTime(2026, 6, 25),
              time: '09:00',
              isBooked: false,
              isBookable: true,
              room: 'Aula 1',
            ),
          ]),
          visibleExamAppealMonthsProvider.overrideWithValue([
            const ExamAppealMonthEntity(month: 6, year: 2026),
          ]),
        ],
        child: const MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: ExamAppealsSection()),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(ExamAppealsSection), findsOneWidget);
    expect(find.textContaining('Giugno'), findsWidgets);
  });
}

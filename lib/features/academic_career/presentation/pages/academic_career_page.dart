import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/academic_career_provider.dart';
import '../widgets/academic_career_summary_card.dart';
import '../widgets/exam_list_tile.dart';

class AcademicCareerPage extends ConsumerWidget {
  const AcademicCareerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final careerAsync = ref.watch(academicCareerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Carriera accademica')),
      body: careerAsync.when(
        data: (career) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              AcademicCareerSummaryCard(career: career),
              const SizedBox(height: 16),
              Text(
                'Esami',
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final exam in career.exams) ExamListTile(exam: exam),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stackTrace) {
          return Center(child: Text('Errore: $error'));
        },
      ),
    );
  }
}

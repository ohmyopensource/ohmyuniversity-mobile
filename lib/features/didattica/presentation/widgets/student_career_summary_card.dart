import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../providers/exam_courses_provider.dart';

class StudentCareerSummaryCard extends ConsumerWidget {
  const StudentCareerSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(didatticaStatisticsProvider);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Expanded(flex: 14, child: StudentIdentityTile()),
        const SizedBox(width: 10),
        Expanded(
          flex: 23,
          child: CareerMetricsGrid(
            arithmeticAverage: _formatAverage(statistics.arithmeticAverage),
            weightedAverage: _formatAverage(statistics.weightedAverage),
            acquiredCredits: statistics.acquiredCredits,
            totalCredits: statistics.totalCredits,
          ),
        ),
      ],
    );
  }

  String _formatAverage(double value) {
    if (value == 0) return '-';
    return value.toStringAsFixed(2);
  }
}

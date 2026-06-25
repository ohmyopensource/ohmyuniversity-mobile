import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/academic/academic_statistics_tiles.dart';
import '../providers/exam_courses_provider.dart';

class StatisticsSection extends ConsumerWidget {
  const StatisticsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(academicStatisticsProvider);
    final averageTrend = [
      for (final point in statistics.averageTrend)
        AcademicAverageTrendPoint(date: point.date, value: point.value),
    ];

    return Column(
      children: [
        GraduationProjectionTile(
          value: statistics.projectedGraduationBase,
          maxValue: statistics.maxGraduationBase,
        ),
        const SizedBox(height: 14),
        AverageTrendTile(points: averageTrend),
      ],
    );
  }
}

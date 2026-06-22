import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/academic/academic_summary_tiles.dart';
import '../../../profile/presentation/mappers/student_identity_mapper.dart';
import '../../../profile/presentation/providers/student_badge_providers.dart';
import '../providers/career_provider.dart';
import '../providers/exam_courses_provider.dart';

class StudentCareerSummaryCard extends ConsumerWidget {
  const StudentCareerSummaryCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statistics = ref.watch(didatticaStatisticsProvider);
    final careerState = ref.watch(careerProvider);
    final badge = ref.watch(studentBadgeProvider).value;
    final identity = mapStudentIdentityData(
      badge: badge,
      statistics: statistics,
      totalExams: careerState.courses.length,
      passedExams: careerState.courses.where((course) => course.passed).length,
    );

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 14, child: StudentIdentityTile(data: identity)),
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

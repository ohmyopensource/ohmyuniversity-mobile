import 'package:flutter/material.dart';

import '../../../../shared/widgets/academic/academic_summary_tiles.dart';

class StudentCareerSummaryCard extends StatelessWidget {
  const StudentCareerSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(flex: 14, child: StudentIdentityTile()),
        SizedBox(width: 10),
        Expanded(flex: 23, child: CareerMetricsGrid()),
      ],
    );
  }
}

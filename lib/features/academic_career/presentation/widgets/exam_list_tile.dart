import 'package:flutter/material.dart';

import '../../domain/entities/exam_entity.dart';

class ExamListTile extends StatelessWidget {
  const ExamListTile({super.key, required this.exam});

  final ExamEntity exam;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grade = exam.hasHonors ? '${exam.grade}L' : '${exam.grade}';

    return Card(
      child: ListTile(
        title: Text(exam.name),
        subtitle: Text('${exam.credits} CFU'),
        trailing: Text(
          grade,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
    );
  }
}

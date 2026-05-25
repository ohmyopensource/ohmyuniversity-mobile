import 'package:flutter/material.dart';

import '../../domain/entities/academic_career_entity.dart';

class AcademicCareerSummaryCard extends StatelessWidget {
  const AcademicCareerSummaryCard({super.key, required this.career});

  final AcademicCareerEntity career;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              career.studentName,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _SummaryValue(
                  label: 'Media aritmetica',
                  value: career.arithmeticAverage.toStringAsFixed(2),
                ),
                _SummaryValue(
                  label: 'Media ponderata',
                  value: career.weightedAverage.toStringAsFixed(2),
                ),
                _SummaryValue(
                  label: 'CFU',
                  value: '${career.acquiredCredits}/${career.totalCredits}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SummaryValue extends StatelessWidget {
  const _SummaryValue({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: 140,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: theme.textTheme.bodySmall),
        ],
      ),
    );
  }
}

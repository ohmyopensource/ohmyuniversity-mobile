import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';

Future<String?> showGradeSimulationSheet({
  required BuildContext context,
  required String courseName,
  String? currentGrade,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    useSafeArea: true,
    isScrollControlled: true,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) => _GradeSimulationSheet(
      courseName: courseName,
      currentGrade: currentGrade,
    ),
  );
}

class _GradeSimulationSheet extends StatelessWidget {
  const _GradeSimulationSheet({
    required this.courseName,
    required this.currentGrade,
  });

  final String courseName;
  final String? currentGrade;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final grades = [for (var grade = 18; grade <= 30; grade++) '$grade', '30L'];

    return SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(
        20,
        18,
        20,
        20 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 42,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.colorNeutral300,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            'Simula un voto',
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.colorNeutral900,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            courseName,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.colorNeutral500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final grade in grades)
                CustomButtonWidget(
                  key: Key('simulation-grade-$grade'),
                  label: grade,
                  size: ButtonSize.sm,
                  variant: grade == currentGrade
                      ? ButtonVariant.secondary
                      : ButtonVariant.outline,
                  onPressed: () => Navigator.of(context).pop(grade),
                ),
            ],
          ),
          if (currentGrade != null) ...[
            const SizedBox(height: 18),
            CustomButtonWidget(
              key: const Key('remove-simulated-grade'),
              label: 'Rimuovi simulazione',
              icon: LucideIcons.trash2,
              variant: ButtonVariant.ghost,
              fullWidth: true,
              onPressed: () => Navigator.of(context).pop('remove'),
            ),
          ],
        ],
      ),
    );
  }
}

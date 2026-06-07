import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/academic/academic_tuition_widgets.dart';

class TuitionFeesPage extends StatelessWidget {
  const TuitionFeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tasse da pagare')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: AcademicTuitionEmptyState(),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class TuitionFeesPage extends StatelessWidget {
  const TuitionFeesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Tasse da pagare')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFE7FBFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  LucideIcons.creditCard,
                  color: Color(0xFF14185E),
                  size: 30,
                ),
              ),
              const SizedBox(height: 18),
              Text(
                'Non c\'e niente da pagare',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

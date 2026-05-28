import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class HomeExamCallCard extends StatelessWidget {
  const HomeExamCallCard({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      height: 118,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.textPrimary.withValues(alpha: 0.44),
        ),
      ),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: Icon(icon, size: 22, color: AppColors.textPrimary),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              title,
              style: theme.textTheme.titleSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Text(
              value,
              style: theme.textTheme.displayLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                height: 0.92,
                shadows: [
                  Shadow(
                    color: Colors.black.withValues(alpha: 0.22),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../../config/constants/app_day_greeting.dart';
import '../../../../../config/theme/app_colors.dart';

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = AppDayGreeting.resolve();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background.withValues(alpha: 0.88),
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Text(
        '$greeting, Mario',
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: theme.textTheme.titleLarge?.copyWith(
          color: AppColors.textPrimary,
          fontWeight: FontWeight.w900,
          height: 1,
        ),
      ),
    );
  }
}

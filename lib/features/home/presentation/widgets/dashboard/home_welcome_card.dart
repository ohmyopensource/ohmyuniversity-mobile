import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../config/constants/app_day_greeting.dart';
import '../../../../../config/theme/app_colors.dart';

class HomeWelcomeCard extends StatelessWidget {
  const HomeWelcomeCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final greeting = AppDayGreeting.resolve();

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.08),
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.secondary.withValues(alpha: 0.16),
            ),
          ),
          child: const Icon(
            LucideIcons.userCircle,
            color: AppColors.textPrimary,
            size: 25,
          ),
        ),
        const SizedBox(height: 8),
        Text.rich(
          TextSpan(
            children: [
              TextSpan(text: '$greeting, '),
              const TextSpan(
                text: 'Mario',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
            ],
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w800,
            height: 1,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class OnboardingAccentShape extends StatelessWidget {
  const OnboardingAccentShape({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: -92,
      top: MediaQuery.sizeOf(context).height * 0.39,
      child: Container(
        width: 282,
        height: 142,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.72),
          borderRadius: BorderRadius.circular(160),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class HomeHeaderBackground extends StatelessWidget {
  const HomeHeaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: -118,
      left: -72,
      right: -72,
      child: Container(
        height: 280,
        decoration: BoxDecoration(
          color: AppColors.secondary.withValues(alpha: 0.38),
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(240),
            bottomRight: Radius.circular(240),
          ),
        ),
      ),
    );
  }
}

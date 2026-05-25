import 'package:flutter/material.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingTextEllipse extends StatelessWidget {
  final String title;
  final String subtitle;
  final double width;
  final double height;
  final double left;
  final double bottom;

  const OnboardingTextEllipse({
    super.key,
    required this.title,
    required this.subtitle,
    this.width = 480,
    this.height = 440,
    this.left = -158,
    this.bottom = 98,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Positioned(
      left: left,
      bottom: bottom,
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(begin: const Offset(-180, 0), end: Offset.zero),
        duration: const Duration(milliseconds: 850),
        curve: Curves.easeOutCubic,
        builder: (context, offset, child) {
          return Transform.translate(offset: offset, child: child);
        },
        child: Container(
          width: width,
          height: height,
          padding: const EdgeInsets.only(
            left: 175,
            right: 70,
            top: 20,
            bottom: 20,
          ),
          decoration: BoxDecoration(
            color: AppColors.secondary.withValues(alpha: 0.72),
            borderRadius: BorderRadius.circular(height / 2),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

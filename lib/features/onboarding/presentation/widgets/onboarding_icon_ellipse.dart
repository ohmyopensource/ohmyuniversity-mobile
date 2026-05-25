import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../../config/theme/app_colors.dart';

class OnboardingIconEllipse extends StatelessWidget {
  const OnboardingIconEllipse({
    super.key,
    required this.animationAsset,
    this.width = 480,
    this.height = 440,
    this.right = -102,
    this.top = 22,
    this.iconSize = 260,
  });

  final String animationAsset;
  final double width;
  final double height;
  final double right;
  final double top;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: right,
      top: top,
      child: TweenAnimationBuilder<Offset>(
        tween: Tween(begin: const Offset(90, 0), end: Offset.zero),
        duration: const Duration(milliseconds: 680),
        curve: Curves.easeOutCubic,
        builder: (context, offset, child) {
          return Transform.translate(offset: offset, child: child);
        },
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.cta.withValues(alpha: 0.78),
            borderRadius: BorderRadius.circular(height),
          ),
          child: Align(
            alignment: const Alignment(0.08, 0.0),
            child: Lottie.asset(
              animationAsset,
              width: iconSize,
              height: iconSize,
              fit: BoxFit.contain,
              repeat: false,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../models/onboarding_slide_data.dart';
import 'onboarding_icon_ellipse.dart';
import 'onboarding_text_ellipse.dart';

class OnboardingSlide extends StatelessWidget {
  const OnboardingSlide({super.key, required this.slide});

  final OnboardingSlideData slide;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        OnboardingIconEllipse(animationAsset: slide.animationAsset),
        OnboardingTextEllipse(title: slide.title, subtitle: slide.subtitle),
      ],
    );
  }
}

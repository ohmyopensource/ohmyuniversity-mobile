import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/constants/app_assets.dart';

class OnboardingBackgroundLogo extends StatelessWidget {
  const OnboardingBackgroundLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 36,
      right: -8,
      child: Opacity(
        opacity: 0.22,
        child: SvgPicture.asset(
          AppAssets.logo,
          width: 148,
          height: 148,
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}

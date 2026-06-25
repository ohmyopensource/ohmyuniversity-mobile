import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';

class OrientationAreaStyle {
  const OrientationAreaStyle({
    required this.accent,
    required this.accentLight,
    required this.textColor,
  });

  final Color accent;
  final Color accentLight;
  final Color textColor;
}

abstract final class OrientationStyleHelper {
  static OrientationAreaStyle area(String id) {
    return switch (id) {
      'umanistica' => const OrientationAreaStyle(
        accent: AppColors.colorWarningDark,
        accentLight: AppColors.colorWarningLight,
        textColor: AppColors.colorWarningText,
      ),
      'scientifica' => const OrientationAreaStyle(
        accent: AppColors.colorPrimaryDark,
        accentLight: AppColors.colorPrimaryLight,
        textColor: AppColors.colorPrimaryText,
      ),
      'ingegneria' => const OrientationAreaStyle(
        accent: AppColors.colorInfoDark,
        accentLight: AppColors.colorInfoLight,
        textColor: AppColors.colorInfoText,
      ),
      'economica' => const OrientationAreaStyle(
        accent: AppColors.colorSuccessDark,
        accentLight: AppColors.colorSuccessLight,
        textColor: AppColors.colorSuccessText,
      ),
      'sanitaria' => const OrientationAreaStyle(
        accent: AppColors.colorErrorDark,
        accentLight: AppColors.colorErrorLight,
        textColor: AppColors.colorErrorText,
      ),
      'artistica' => const OrientationAreaStyle(
        accent: AppColors.colorSecondaryDark,
        accentLight: AppColors.colorSecondaryLight,
        textColor: AppColors.colorSecondaryText,
      ),
      _ => const OrientationAreaStyle(
        accent: AppColors.colorNeutral500,
        accentLight: AppColors.colorNeutral100,
        textColor: AppColors.textPrimary,
      ),
    };
  }
}

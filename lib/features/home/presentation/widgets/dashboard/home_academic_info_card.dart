import 'package:flutter/material.dart';

import '../../../../../config/theme/app_colors.dart';
import '../../../../../shared/mocks/app_mock_data.dart';

class HomeAcademicInfoCard extends StatelessWidget {
  const HomeAcademicInfoCard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final academicInfo = AppMockData.academicInfo;

    return Container(
      width: double.infinity,
      height: 66,
      padding: const EdgeInsets.fromLTRB(14, 7, 14, 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.cta.withValues(alpha: 0.22),
          width: 1.1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.cta.withValues(alpha: 0.07),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            academicInfo.universityName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textPrimary.withValues(alpha: 0.32),
              fontSize: 10.5,
              fontWeight: FontWeight.w800,
              height: 1,
            ),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: _AcademicInfoValue(
                  text: academicInfo.courseName,
                  textAlign: TextAlign.left,
                ),
              ),
              Expanded(
                child: _AcademicInfoValue(
                  text: academicInfo.degreeName,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: _AcademicInfoValue(
                  text: academicInfo.academicYear,
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AcademicInfoValue extends StatelessWidget {
  const _AcademicInfoValue({required this.text, required this.textAlign});

  final String text;
  final TextAlign textAlign;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Text(
      text,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      textAlign: textAlign,
      style: theme.textTheme.labelLarge?.copyWith(
        color: AppColors.primary,
        fontSize: 12.6,
        fontWeight: FontWeight.w900,
        height: 1,
      ),
    );
  }
}

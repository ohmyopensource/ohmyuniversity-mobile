import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';

class DashboardWidgetOption {
  const DashboardWidgetOption({
    required this.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
    required this.accentBackgroundColor,
    required this.columnSpan,
    required this.rowSpan,
    required this.size,
  });

  final String key;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color accentColor;
  final Color accentBackgroundColor;
  final int columnSpan;
  final int rowSpan;
  final Size size;
}

abstract final class DashboardWidgetOptions {
  static const placeholder = DashboardWidgetOption(
    key: 'placeholder',
    title: 'Widget',
    subtitle: 'Elemento dashboard',
    icon: LucideIcons.square,
    accentColor: AppColors.colorSecondaryDark,
    accentBackgroundColor: AppColors.colorSecondaryLight,
    columnSpan: 5,
    rowSpan: 3,
    size: Size(204, 98),
  );

  static const student = DashboardWidgetOption(
    key: 'student',
    title: 'Studente',
    subtitle: 'Badge studente',
    icon: LucideIcons.badgeCheck,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 4,
    rowSpan: 6,
    size: Size(126, 208),
  );

  static const arithmeticAverage = DashboardWidgetOption(
    key: 'arithmetic_average',
    title: 'Media aritmetica',
    subtitle: 'Valore attuale',
    icon: LucideIcons.calculator,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 3,
    rowSpan: 3,
    size: Size(96, 98),
  );

  static const weightedAverage = DashboardWidgetOption(
    key: 'weighted_average',
    title: 'Media ponderata',
    subtitle: 'Valore pesato',
    icon: LucideIcons.sigma,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 3,
    rowSpan: 3,
    size: Size(96, 98),
  );

  static const averagePair = DashboardWidgetOption(
    key: 'average_pair',
    title: 'Medie',
    subtitle: 'Aritmetica e ponderata',
    icon: LucideIcons.chartNoAxesCombined,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 6,
    rowSpan: 3,
    size: Size(204, 98),
  );

  static const calendarAgenda = DashboardWidgetOption(
    key: 'calendar_agenda',
    title: 'Agenda',
    subtitle: 'Oggi e domani',
    icon: LucideIcons.calendarDays,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 10,
    rowSpan: 4,
    size: Size(304, 132),
  );

  static const acquiredCredits = DashboardWidgetOption(
    key: 'acquired_credits',
    title: 'CFU acquisiti',
    subtitle: 'Formato largo home',
    icon: LucideIcons.graduationCap,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 10,
    rowSpan: 3,
    size: Size(304, 98),
  );

  static const acquiredCreditsCompact = DashboardWidgetOption(
    key: 'acquired_credits_compact',
    title: 'CFU acquisiti compatto',
    subtitle: 'Formato card didattica',
    icon: LucideIcons.graduationCap,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 6,
    rowSpan: 3,
    size: Size(204, 98),
  );

  static const graduationProjection = DashboardWidgetOption(
    key: 'graduation_projection',
    title: 'Proiezione voto',
    subtitle: 'Voto finale proiettato',
    icon: LucideIcons.trendingUp,
    accentColor: AppColors.colorSuccessDark,
    accentBackgroundColor: AppColors.colorSuccessLight,
    columnSpan: 10,
    rowSpan: 4,
    size: Size(304, 132),
  );

  static const averageTrend = DashboardWidgetOption(
    key: 'average_trend',
    title: 'Andamento media',
    subtitle: 'Storico della media',
    icon: LucideIcons.lineChart,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 10,
    rowSpan: 6,
    size: Size(304, 184),
  );

  static const exams = DashboardWidgetOption(
    key: 'exams',
    title: 'Esami',
    subtitle: 'Esami e voti',
    icon: LucideIcons.bookOpenCheck,
    accentColor: AppColors.colorPrimaryDark,
    accentBackgroundColor: AppColors.colorPrimaryLight,
    columnSpan: 10,
    rowSpan: 10,
    size: Size(304, 322),
  );

  static const appeals = DashboardWidgetOption(
    key: 'appeals',
    title: 'Appelli',
    subtitle: 'Prenotazioni esami',
    icon: LucideIcons.calendarDays,
    accentColor: AppColors.colorPrimaryDark,
    accentBackgroundColor: AppColors.colorPrimaryLight,
    columnSpan: 10,
    rowSpan: 10,
    size: Size(304, 314),
  );

  static const tuitionFees = DashboardWidgetOption(
    key: 'tuition_fees',
    title: 'Tasse',
    subtitle: 'Pagamenti e scadenze',
    icon: LucideIcons.creditCard,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 10,
    rowSpan: 9,
    size: Size(304, 296),
  );

  static const tuitionFeesCompact = DashboardWidgetOption(
    key: 'tuition_fees_compact',
    title: 'Tasse compatto',
    subtitle: 'Da pagare e pagate',
    icon: LucideIcons.creditCard,
    accentColor: AppColors.colorWarningDark,
    accentBackgroundColor: AppColors.colorWarningLight,
    columnSpan: 6,
    rowSpan: 3,
    size: Size(204, 98),
  );

  static const all = [
    student,
    arithmeticAverage,
    weightedAverage,
    averagePair,
    calendarAgenda,
    acquiredCredits,
    acquiredCreditsCompact,
    graduationProjection,
    averageTrend,
    exams,
    appeals,
    tuitionFees,
    tuitionFeesCompact,
  ];
}

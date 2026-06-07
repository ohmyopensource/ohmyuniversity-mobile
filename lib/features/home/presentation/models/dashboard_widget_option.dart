import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

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
    accentColor: Color(0xFF357266),
    accentBackgroundColor: Color(0xFFEAF4F2),
    columnSpan: 2,
    rowSpan: 1,
    size: Size(204, 98),
  );

  static const student = DashboardWidgetOption(
    key: 'student',
    title: 'Studente',
    subtitle: 'Badge studente',
    icon: LucideIcons.badgeCheck,
    accentColor: Color(0xFF357266),
    accentBackgroundColor: Color(0xFFEAF4F2),
    columnSpan: 2,
    rowSpan: 3,
    size: Size(126, 208),
  );

  static const arithmeticAverage = DashboardWidgetOption(
    key: 'arithmetic_average',
    title: 'Media aritmetica',
    subtitle: 'Valore attuale',
    icon: LucideIcons.calculator,
    accentColor: Color(0xFF4285F4),
    accentBackgroundColor: Color(0xFFE8F0FE),
    columnSpan: 1,
    rowSpan: 1,
    size: Size(96, 98),
  );

  static const weightedAverage = DashboardWidgetOption(
    key: 'weighted_average',
    title: 'Media ponderata',
    subtitle: 'Valore pesato',
    icon: LucideIcons.sigma,
    accentColor: Color(0xFFC58444),
    accentBackgroundColor: Color(0xFFF8F2DF),
    columnSpan: 1,
    rowSpan: 1,
    size: Size(96, 98),
  );

  static const acquiredCredits = DashboardWidgetOption(
    key: 'acquired_credits',
    title: 'CFU acquisiti',
    subtitle: 'Progresso carriera',
    icon: LucideIcons.graduationCap,
    accentColor: Color(0xFF34A853),
    accentBackgroundColor: Color(0xFFE7F6EC),
    columnSpan: 4,
    rowSpan: 1,
    size: Size(204, 98),
  );

  static const graduationProjection = DashboardWidgetOption(
    key: 'graduation_projection',
    title: 'Proiezione voto',
    subtitle: 'Voto finale proiettato',
    icon: LucideIcons.trendingUp,
    accentColor: Color(0xFF95F2A5),
    accentBackgroundColor: Color(0xFFE7F6EC),
    columnSpan: 4,
    rowSpan: 2,
    size: Size(304, 132),
  );

  static const averageTrend = DashboardWidgetOption(
    key: 'average_trend',
    title: 'Andamento media',
    subtitle: 'Storico della media',
    icon: LucideIcons.lineChart,
    accentColor: Color(0xFFC58444),
    accentBackgroundColor: Color(0xFFF8F2DF),
    columnSpan: 4,
    rowSpan: 3,
    size: Size(304, 184),
  );

  static const exams = DashboardWidgetOption(
    key: 'exams',
    title: 'Esami',
    subtitle: 'Esami e voti',
    icon: LucideIcons.bookOpenCheck,
    accentColor: Color(0xFF5B93AE),
    accentBackgroundColor: Color(0xFFEAF1F5),
    columnSpan: 4,
    rowSpan: 5,
    size: Size(304, 322),
  );

  static const appeals = DashboardWidgetOption(
    key: 'appeals',
    title: 'Appelli',
    subtitle: 'Prenotazioni esami',
    icon: LucideIcons.calendarDays,
    accentColor: Color(0xFF62A77D),
    accentBackgroundColor: Color(0xFFEAF5EE),
    columnSpan: 4,
    rowSpan: 4,
    size: Size(304, 314),
  );

  static const tuitionFees = DashboardWidgetOption(
    key: 'tuition_fees',
    title: 'Tasse',
    subtitle: 'Pagamenti e scadenze',
    icon: LucideIcons.creditCard,
    accentColor: Color(0xFFE1A72F),
    accentBackgroundColor: Color(0xFFF8F2DF),
    columnSpan: 4,
    rowSpan: 4,
    size: Size(304, 296),
  );

  static const all = [
    student,
    arithmeticAverage,
    weightedAverage,
    acquiredCredits,
    graduationProjection,
    averageTrend,
    exams,
    appeals,
    tuitionFees,
  ];
}

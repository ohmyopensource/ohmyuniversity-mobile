import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/calendar_event_type.dart';

extension CalendarEventTypeUi on CalendarEventType {
  String get label {
    return switch (this) {
      CalendarEventType.exam => 'Esame',
      CalendarEventType.reminder => 'Promemoria',
      CalendarEventType.event => 'Evento',
    };
  }

  IconData get icon {
    return switch (this) {
      CalendarEventType.exam => LucideIcons.graduationCap,
      CalendarEventType.reminder => LucideIcons.bell,
      CalendarEventType.event => LucideIcons.calendarDays,
    };
  }

  Color get foregroundColor {
    return switch (this) {
      CalendarEventType.exam => AppColors.colorErrorText,
      CalendarEventType.reminder => AppColors.colorSecondaryText,
      CalendarEventType.event => AppColors.colorWarningText,
    };
  }

  CardVariant get cardVariant {
    return switch (this) {
      CalendarEventType.exam => CardVariant.error,
      CalendarEventType.reminder => CardVariant.secondary,
      CalendarEventType.event => CardVariant.warning,
    };
  }

  BadgeVariant get badgeVariant {
    return switch (this) {
      CalendarEventType.exam => BadgeVariant.error,
      CalendarEventType.reminder => BadgeVariant.secondary,
      CalendarEventType.event => BadgeVariant.warning,
    };
  }
}

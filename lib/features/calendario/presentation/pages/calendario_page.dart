import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../../config/theme/app_colors.dart';
import '../providers/calendar_providers.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../widgets/calendar_day_strip.dart';
import '../widgets/calendar_event_detail_sheet.dart';
import '../widgets/calendar_event_form_sheet.dart';
import '../widgets/calendar_header.dart';
import '../widgets/calendar_timeline.dart';

class CalendarioPage extends ConsumerWidget {
  const CalendarioPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedCalendarDateProvider);
    final selectedHour = ref.watch(selectedCalendarHourProvider);
    final currentTime =
        ref.watch(calendarClockProvider).value ?? DateTime.now();
    final eventsAsync = ref.watch(calendarEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            CalendarHeader(
              selectedDate: selectedDate,
              onOpenDatePicker: () => _openDatePicker(context, ref),
              onBack: () => context.goNamed(AppRoutes.homeName),
            ),
            CalendarDayStrip(
              selectedDate: selectedDate,
              onDateSelected: (date) {
                ref
                    .read(selectedCalendarDateProvider.notifier)
                    .selectDate(date);
                ref
                    .read(selectedCalendarHourProvider.notifier)
                    .clearSelection();
              },
            ),
            Expanded(
              child: eventsAsync.when(
                data: (events) => CalendarTimeline(
                  events: events,
                  selectedDate: selectedDate,
                  currentTime: currentTime,
                  selectedHour: selectedHour,
                  onHourSelected: ref
                      .read(selectedCalendarHourProvider.notifier)
                      .selectHour,
                  onEventSelected: (event) => _openEventDetail(context, event),
                ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stackTrace) =>
                    _CalendarErrorView(message: error.toString()),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'calendar-event-picker',
        backgroundColor: AppColors.background,
        foregroundColor: AppColors.textPrimary,
        elevation: 4,
        shape: const CircleBorder(),
        onPressed: () => _openEventForm(context, selectedDate),
        child: const Icon(LucideIcons.plus),
      ),
    );
  }

  Future<void> _openDatePicker(BuildContext context, WidgetRef ref) async {
    final selectedDate = ref.read(selectedCalendarDateProvider);
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );

    if (pickedDate == null || !context.mounted) return;

    ref.read(selectedCalendarDateProvider.notifier).selectDate(pickedDate);
    ref.read(selectedCalendarHourProvider.notifier).clearSelection();
  }

  Future<void> _openEventForm(
    BuildContext context,
    DateTime selectedDate,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarEventFormSheet(initialDate: selectedDate),
    );
  }

  Future<void> _openEventDetail(
    BuildContext context,
    CalendarEventEntity event,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CalendarEventDetailSheet(event: event),
    );
  }
}

class _CalendarErrorView extends StatelessWidget {
  const _CalendarErrorView({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              LucideIcons.triangleAlert,
              size: 36,
              color: AppColors.examFailed,
            ),
            const SizedBox(height: 12),
            Text(
              'Impossibile caricare il calendario',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textPrimary.withValues(alpha: 0.58),
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

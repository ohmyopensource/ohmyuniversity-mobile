import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../providers/calendar_providers.dart';
import 'calendar_date_labels.dart';
import 'calendar_event_type_ui.dart';

class CalendarEventDetailSheet extends ConsumerStatefulWidget {
  const CalendarEventDetailSheet({super.key, required this.event});

  final CalendarEventEntity event;

  @override
  ConsumerState<CalendarEventDetailSheet> createState() =>
      _CalendarEventDetailSheetState();
}

class _CalendarEventDetailSheetState
    extends ConsumerState<CalendarEventDetailSheet> {
  bool _isDeleting = false;
  String _errorMessage = '';

  Future<void> _deleteEvent() async {
    if (_isDeleting) return;

    setState(() {
      _isDeleting = true;
      _errorMessage = '';
    });

    try {
      await ref.read(deleteCalendarEventUseCaseProvider).call(widget.event.id);
      ref.invalidate(calendarEventsProvider);
      ref.invalidate(homeCalendarEventsProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Evento non eliminato. Riprova.');
    } finally {
      if (mounted) setState(() => _isDeleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final event = widget.event;
    final theme = Theme.of(context);
    final foregroundColor = event.type.foregroundColor;
    final description = event.description.trim().isEmpty
        ? 'Nessuna descrizione disponibile.'
        : event.description.trim();

    return SafeArea(
      top: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: CustomCardWidget(
            variant: CardVariant.neutral,
            padding: CardPadding.none,
            shadow: CardShadow.lg,
            radius: CardRadius.lg,
            bordered: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 42,
                    height: 4,
                    decoration: BoxDecoration(
                      color: AppColors.textPrimary.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(AppColors.radiusFull),
                    ),
                  ),
                  const SizedBox(height: 26),
                  _EventIcon(typeColor: foregroundColor, icon: event.type.icon),
                  const SizedBox(height: 22),
                  Text(
                    event.title,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1.05,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    description,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.58),
                      fontWeight: FontWeight.w700,
                      height: 1.25,
                    ),
                  ),
                  const SizedBox(height: 22),
                  _EventDetailInfoGrid(event: event),
                  if (_errorMessage.isNotEmpty) ...[
                    const SizedBox(height: 14),
                    Text(
                      _errorMessage,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.examFailed,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButtonWidget(
                          label: 'Modifica',
                          icon: LucideIcons.pencil,
                          fullWidth: true,
                          variant: ButtonVariant.outline,
                          onPressed: _isDeleting
                              ? null
                              : () => Navigator.of(context).pop(true),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: CustomButtonWidget(
                          label: 'Elimina',
                          icon: LucideIcons.trash2,
                          fullWidth: true,
                          loading: _isDeleting,
                          variant: ButtonVariant.error,
                          onPressed: _deleteEvent,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  CustomButtonWidget(
                    label: 'Chiudi',
                    icon: LucideIcons.x,
                    fullWidth: true,
                    variant: ButtonVariant.ghost,
                    onPressed: _isDeleting
                        ? null
                        : () => Navigator.of(context).pop(false),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.typeColor, required this.icon});

  final Color typeColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92,
      height: 92,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: typeColor.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: typeColor.withValues(alpha: 0.14),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Icon(icon, size: 44, color: typeColor),
    );
  }
}

class _EventDetailInfoGrid extends StatelessWidget {
  const _EventDetailInfoGrid({required this.event});

  final CalendarEventEntity event;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _EventInfoTile(
                icon: LucideIcons.calendarDays,
                label: 'Data',
                value: CalendarDateLabels.dayMonth(event.startDate),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _EventInfoTile(
                icon: LucideIcons.clock,
                label: 'Orario',
                value: CalendarDateLabels.eventTimeRange(
                  event.startDate,
                  event.endDate,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _EventInfoTile(
                icon: LucideIcons.timer,
                label: 'Durata',
                value: CalendarDateLabels.duration(
                  event.startDate,
                  event.endDate,
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _EventInfoTile(
                icon: LucideIcons.mapPin,
                label: 'Luogo',
                value: event.location.trim().isEmpty
                    ? 'Non indicato'
                    : event.location.trim(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _EventInfoTile extends StatelessWidget {
  const _EventInfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.none,
      shadow: CardShadow.sm,
      radius: CardRadius.md,
      bordered: false,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(icon, size: 17, color: AppColors.colorPrimaryDark),
            const SizedBox(width: 9),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.textPrimary.withValues(alpha: 0.48),
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    value,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w900,
                      height: 1,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

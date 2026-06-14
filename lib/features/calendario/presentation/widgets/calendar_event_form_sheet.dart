import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../../../shared/widgets/custom_input/custom_input_widget.dart';
import '../../domain/entities/calendar_event_entity.dart';
import '../../domain/entities/calendar_event_type.dart';
import '../providers/calendar_providers.dart';
import 'calendar_event_type_ui.dart';

class CalendarEventFormSheet extends ConsumerStatefulWidget {
  const CalendarEventFormSheet({super.key, required this.initialDate});

  final DateTime initialDate;

  @override
  ConsumerState<CalendarEventFormSheet> createState() =>
      _CalendarEventFormSheetState();
}

class _CalendarEventFormSheetState
    extends ConsumerState<CalendarEventFormSheet> {
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _startTimeController = TextEditingController(text: '09:00');
  final _durationController = TextEditingController(text: '60');

  CalendarEventType _selectedType = CalendarEventType.event;
  bool _isSaving = false;
  String _errorMessage = '';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _startTimeController.dispose();
    _durationController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_isSaving) return;

    FocusScope.of(context).unfocus();

    final title = _titleController.text.trim();
    final time = _parseTime(_startTimeController.text.trim());
    final durationMinutes = int.tryParse(_durationController.text.trim());

    if (title.isEmpty) {
      setState(() => _errorMessage = 'Inserisci un titolo.');
      return;
    }

    if (time == null) {
      setState(() => _errorMessage = 'Inserisci un orario valido, es. 09:30.');
      return;
    }

    if (durationMinutes == null || durationMinutes <= 0) {
      setState(() => _errorMessage = 'Inserisci una durata valida in minuti.');
      return;
    }

    setState(() {
      _isSaving = true;
      _errorMessage = '';
    });

    final startDate = DateTime(
      widget.initialDate.year,
      widget.initialDate.month,
      widget.initialDate.day,
      time.hour,
      time.minute,
    );
    final event = CalendarEventEntity(
      id: 'calendar-event-${DateTime.now().millisecondsSinceEpoch}',
      title: title,
      description: _descriptionController.text.trim(),
      startDate: startDate,
      endDate: startDate.add(Duration(minutes: durationMinutes)),
      type: _selectedType,
      location: _locationController.text.trim(),
    );

    try {
      await ref.read(createCalendarEventUseCaseProvider).call(event);
      ref.read(selectedCalendarDateProvider.notifier).selectDate(startDate);
      ref.invalidate(calendarEventsProvider);

      if (!mounted) return;
      Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => _errorMessage = 'Evento non salvato. Riprova.');
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  _ParsedTime? _parseTime(String value) {
    final match = RegExp(r'^(\d{1,2}):(\d{2})$').firstMatch(value);
    if (match == null) return null;

    final hour = int.tryParse(match.group(1)!);
    final minute = int.tryParse(match.group(2)!);

    if (hour == null || minute == null) return null;
    if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;

    return _ParsedTime(hour: hour, minute: minute);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(14, 0, 14, bottomInset + 12),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: CustomCardWidget(
            variant: CardVariant.neutral,
            padding: CardPadding.none,
            shadow: CardShadow.lg,
            radius: CardRadius.lg,
            bordered: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 18),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 42,
                        height: 4,
                        decoration: BoxDecoration(
                          color: AppColors.textPrimary.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(
                            AppColors.radiusFull,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Nuovo elemento',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w900,
                        height: 1,
                      ),
                    ),
                    const SizedBox(height: 14),
                    Row(
                      children: CalendarEventType.values
                          .map((type) {
                            return Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  right: type == CalendarEventType.values.last
                                      ? 0
                                      : 8,
                                ),
                                child: _CalendarTypeButton(
                                  type: type,
                                  isSelected: _selectedType == type,
                                  onTap: () =>
                                      setState(() => _selectedType = type),
                                ),
                              ),
                            );
                          })
                          .toList(growable: false),
                    ),
                    const SizedBox(height: 16),
                    CustomInputWidget(
                      controller: _titleController,
                      label: 'Titolo',
                      placeholder: 'Es. Esame Basi di Dati',
                      iconLeft: LucideIcons.calendarPlus,
                      required: true,
                      onChanged: (_) => setState(() => _errorMessage = ''),
                    ),
                    const SizedBox(height: 12),
                    CustomInputWidget(
                      controller: _descriptionController,
                      label: 'Descrizione',
                      placeholder: 'Aggiungi una nota',
                      type: InputType.textarea,
                      rows: 3,
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: CustomInputWidget(
                            controller: _startTimeController,
                            label: 'Ora',
                            placeholder: '09:00',
                            iconLeft: LucideIcons.clock,
                            required: true,
                            onChanged: (_) =>
                                setState(() => _errorMessage = ''),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomInputWidget(
                            controller: _durationController,
                            label: 'Durata (min)',
                            placeholder: '60',
                            type: InputType.number,
                            iconLeft: LucideIcons.timer,
                            required: true,
                            onChanged: (_) =>
                                setState(() => _errorMessage = ''),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    CustomInputWidget(
                      controller: _locationController,
                      label: 'Luogo',
                      placeholder: 'Es. Aula 5',
                      iconLeft: LucideIcons.mapPin,
                    ),
                    if (_errorMessage.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorMessage,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.examFailed,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButtonWidget(
                            label: 'Annulla',
                            variant: ButtonVariant.ghost,
                            fullWidth: true,
                            onPressed: () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: CustomButtonWidget(
                            label: 'Salva',
                            icon: LucideIcons.check,
                            fullWidth: true,
                            loading: _isSaving,
                            onPressed: _submit,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CalendarTypeButton extends StatelessWidget {
  const _CalendarTypeButton({
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  final CalendarEventType type;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedScale(
      duration: const Duration(milliseconds: 180),
      scale: isSelected ? 1 : 0.97,
      child: CustomCardWidget(
        variant: isSelected ? type.cardVariant : CardVariant.neutral,
        padding: CardPadding.none,
        shadow: isSelected ? CardShadow.md : CardShadow.sm,
        radius: CardRadius.lg,
        bordered: isSelected,
        clickable: true,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(type.icon, size: 20, color: type.foregroundColor),
              const SizedBox(height: 7),
              Text(
                type.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: isSelected
                      ? type.foregroundColor
                      : AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                  height: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ParsedTime {
  const _ParsedTime({required this.hour, required this.minute});

  final int hour;
  final int minute;
}

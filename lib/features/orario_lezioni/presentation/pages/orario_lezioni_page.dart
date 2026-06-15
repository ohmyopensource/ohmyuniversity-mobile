import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import '../../domain/entities/timetable_document_entity.dart';
import '../providers/timetable_providers.dart';
import '../widgets/timetable_card.dart';
import '../widgets/timetable_search_prompt.dart';
import '../widgets/timetable_search_sheet.dart';
import '../widgets/timetable_semester_switch.dart';

class OrarioLezioniPage extends ConsumerStatefulWidget {
  const OrarioLezioniPage({super.key});

  @override
  ConsumerState<OrarioLezioniPage> createState() => _OrarioLezioniPageState();
}

class _OrarioLezioniPageState extends ConsumerState<OrarioLezioniPage> {
  int _selectedSemester = 1;

  @override
  Widget build(BuildContext context) {
    final allDocuments = ref.watch(studentTimetablesProvider);
    final documents = allDocuments
        .where((document) => document.semester == _selectedSemester)
        .toList();
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(title: const Text('Orario Lezioni')),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
          physics: const BouncingScrollPhysics(),
          children: [
            Text(
              'Orario Lezioni',
              style: textTheme.headlineSmall?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Consulta gli orari dei corsi seguiti e apri il documento disponibile.',
              style: textTheme.bodyMedium?.copyWith(
                color: AppColors.colorNeutral500,
                height: 1.35,
              ),
            ),
            const SizedBox(height: 22),
            TimetableSemesterSwitch(
              selectedSemester: _selectedSemester,
              onChanged: (semester) {
                setState(() => _selectedSemester = semester);
              },
            ),
            const SizedBox(height: 24),
            Text(
              'I miei corsi',
              style: textTheme.titleMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            if (documents.isEmpty)
              const _TimetableEmptyState()
            else
              ...documents.map(
                (document) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TimetableCard(
                    document: document,
                    onView: (item) => _openDocument(context, item),
                    onDownload: (item) => _downloadDocument(context, item),
                  ),
                ),
              ),
            const SizedBox(height: 4),
            TimetableSearchPrompt(
              onSearch: () => _openSearchSheet(context, allDocuments),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _openSearchSheet(
    BuildContext context,
    List<TimetableDocumentEntity> documents,
  ) async {
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) => TimetableSearchSheet(
        documents: documents,
        initialSemester: _selectedSemester,
        onView: (document) => _openDocument(context, document),
        onDownload: (document) => _downloadDocument(context, document),
      ),
    );
  }

  Future<void> _openDocument(
    BuildContext context,
    TimetableDocumentEntity document,
  ) async {
    await _launch(context, document.sourceUrl);
  }

  Future<void> _downloadDocument(
    BuildContext context,
    TimetableDocumentEntity document,
  ) async {
    await _launch(context, document.fileUrl ?? document.sourceUrl);
  }

  Future<void> _launch(BuildContext context, String url) async {
    final uri = Uri.parse(url);
    final opened = await launchUrl(uri, mode: LaunchMode.externalApplication);

    if (!opened && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Documento non disponibile.')),
      );
    }
  }
}

class _TimetableEmptyState extends StatelessWidget {
  const _TimetableEmptyState();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return CustomCardWidget(
      variant: CardVariant.neutral,
      padding: CardPadding.md,
      shadow: CardShadow.sm,
      radius: CardRadius.lg,
      bordered: false,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Nessun orario disponibile',
            style: textTheme.titleSmall?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Gli orari del semestre selezionato verranno mostrati qui appena disponibili.',
            style: textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral500,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

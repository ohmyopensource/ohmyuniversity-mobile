import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../utils/orientation_area_style.dart';

class OrientationStudyAreaAccordion extends StatefulWidget {
  const OrientationStudyAreaAccordion({super.key});

  @override
  State<OrientationStudyAreaAccordion> createState() =>
      _OrientationStudyAreaAccordionState();
}

class _OrientationStudyAreaAccordionState
    extends State<OrientationStudyAreaAccordion> {
  int? _expandedIndex;

  static const _areas = [
    _StudyArea(
      'umanistica',
      LucideIcons.bookOpen,
      'Umanistica',
      'Lettere, Filosofia, Lingue, Beni culturali, Storia',
      'È indicata se ami leggere, scrivere, interpretare testi e comprendere culture e linguaggi. Nei corsi incontrerai analisi critica, ricerca, comunicazione e studio del patrimonio culturale.',
      ['Letteratura', 'Storia', 'Lingue', 'Filosofia'],
    ),
    _StudyArea(
      'scientifica',
      LucideIcons.flaskConical,
      'Scientifica',
      'Matematica, Fisica, Chimica, Biologia, Scienze naturali',
      'È indicata se ti interessano dati, esperimenti, metodo scientifico e problemi logici. Richiede curiosità, precisione e disponibilità a verificare ipotesi con calcoli o attività di laboratorio.',
      ['Matematica', 'Fisica', 'Chimica', 'Biologia'],
    ),
    _StudyArea(
      'ingegneria',
      LucideIcons.cpu,
      'Ingegneria & Informatica',
      'Informatica, Ingegneria informatica, Meccanica, Elettronica',
      'È indicata se ami tecnologia, programmazione, progettazione e risoluzione di problemi pratici. Teoria ed esercitazioni procedono insieme: dovrai costruire soluzioni e verificarne il funzionamento.',
      ['Programmazione', 'Sistemi', 'Elettronica', 'Meccanica'],
    ),
    _StudyArea(
      'economica',
      LucideIcons.landmark,
      'Economica & Giuridica',
      'Economia, Giurisprudenza, Scienze politiche, Management',
      'È indicata se ti interessano imprese, diritto, mercati, amministrazione e istituzioni. I corsi combinano regole, interpretazione, dati e decisioni organizzative.',
      ['Economia', 'Diritto', 'Management', 'Politica'],
    ),
    _StudyArea(
      'sanitaria',
      LucideIcons.heartPulse,
      'Sanitaria',
      'Medicina, Infermieristica, Farmacia, Professioni sanitarie',
      'È indicata se vuoi lavorare con salute, cura, prevenzione e benessere. Richiede studio scientifico, responsabilità e capacità relazionali.',
      ['Anatomia', 'Biologia', 'Farmacologia', 'Prevenzione'],
    ),
    _StudyArea(
      'artistica',
      LucideIcons.palette,
      'Artistica & del Design',
      'Architettura, Design, Arti, Moda, Comunicazione visiva',
      'È indicata se hai creatività, sensibilità estetica e interesse per immagini, spazi e comunicazione. Le idee devono diventare progetti concreti attraverso laboratori e portfolio.',
      ['Design', 'Arti', 'Architettura', 'Comunicazione visiva'],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Le grandi aree di studio',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Apri un’area per leggere materie, corsi e interessi collegati.',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        for (var index = 0; index < _areas.length; index++) ...[
          _StudyAreaCard(
            area: _areas[index],
            expanded: _expandedIndex == index,
            onTap: () => setState(
              () => _expandedIndex = _expandedIndex == index ? null : index,
            ),
          ),
          if (index != _areas.length - 1) const SizedBox(height: 9),
        ],
      ],
    );
  }
}

class _StudyAreaCard extends StatelessWidget {
  const _StudyAreaCard({
    required this.area,
    required this.expanded,
    required this.onTap,
  });

  final _StudyArea area;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final style = OrientationStyleHelper.area(area.id);
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(
          color: expanded ? style.accent : AppColors.colorNeutral200,
          width: expanded ? 1.5 : 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: AnimatedSize(
            duration: const Duration(milliseconds: 180),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: style.accentLight,
                        borderRadius: BorderRadius.circular(AppColors.radiusMd),
                      ),
                      child: Icon(area.icon, size: 20, color: style.textColor),
                    ),
                    const SizedBox(width: 11),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            area.title,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w900,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            area.subtitle,
                            maxLines: expanded ? 3 : 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: AppColors.colorNeutral500),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      expanded
                          ? LucideIcons.chevronUp
                          : LucideIcons.chevronDown,
                      size: 18,
                      color: style.accent,
                    ),
                  ],
                ),
                if (expanded) ...[
                  const SizedBox(height: 13),
                  Text(
                    area.detail,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.colorNeutral600,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 11),
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    children: area.subjects
                        .map(
                          (subject) => CustomBadgeWidget(
                            label: subject,
                            variant: BadgeVariant.info,
                            size: BadgeSize.sm,
                            shape: BadgeShape.pill,
                          ),
                        )
                        .toList(growable: false),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StudyArea {
  const _StudyArea(
    this.id,
    this.icon,
    this.title,
    this.subtitle,
    this.detail,
    this.subjects,
  );

  final String id;
  final IconData icon;
  final String title;
  final String subtitle;
  final String detail;
  final List<String> subjects;
}

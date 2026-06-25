import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';

class OrientationCourseChoiceSection extends StatefulWidget {
  const OrientationCourseChoiceSection({super.key});

  @override
  State<OrientationCourseChoiceSection> createState() =>
      _OrientationCourseChoiceSectionState();
}

class _OrientationCourseChoiceSectionState
    extends State<OrientationCourseChoiceSection> {
  String? _expandedArea;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Le grandi aree di studio',
          subtitle:
              "Clicca su un'area per scoprire di cosa si occupa e quali facoltà include.",
        ),
        const SizedBox(height: 14),
        DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            border: Border.all(color: AppColors.colorNeutral200),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            child: Column(
              children: [
                for (var index = 0; index < _studyAreas.length; index++) ...[
                  _StudyAreaTile(
                    area: _studyAreas[index],
                    expanded: _expandedArea == _studyAreas[index].value,
                    onTap: () => setState(
                      () => _expandedArea =
                          _expandedArea == _studyAreas[index].value
                          ? null
                          : _studyAreas[index].value,
                    ),
                  ),
                  if (index != _studyAreas.length - 1)
                    const Divider(height: 1, color: AppColors.colorNeutral100),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Come orientarsi nella scelta',
          subtitle:
              'Quattro principi che fanno la differenza tra una scelta consapevole e una frettolosa.',
        ),
        const SizedBox(height: 14),
        for (final tip in _studyAreaTips) ...[
          _SuccessTipCard(tip: tip),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _StudyAreaTile extends StatelessWidget {
  const _StudyAreaTile({
    required this.area,
    required this.expanded,
    required this.onTap,
  });

  final _StudyArea area;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          child: Container(
            color: expanded ? AppColors.colorNeutral100 : Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: expanded ? area.color : area.lightColor,
                    borderRadius: BorderRadius.circular(AppColors.radiusLg),
                  ),
                  child: Icon(
                    area.icon,
                    size: 19,
                    color: expanded ? Colors.white : area.color,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        area.label,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: expanded ? area.color : AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      if (!expanded) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${area.faculties.take(3).join(' · ')}...',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: AppColors.colorNeutral400),
                        ),
                      ],
                    ],
                  ),
                ),
                AnimatedRotation(
                  turns: expanded ? 0.25 : 0,
                  duration: const Duration(milliseconds: 180),
                  child: const Icon(
                    LucideIcons.chevronRight,
                    size: 17,
                    color: AppColors.colorNeutral400,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (expanded)
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: area.borderColor)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  area.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Facoltà principali',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.colorNeutral400,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: area.faculties
                      .map(
                        (faculty) => CustomBadgeWidget(
                          label: faculty,
                          variant: BadgeVariant.neutral,
                          shape: BadgeShape.rounded,
                          size: BadgeSize.sm,
                        ),
                      )
                      .toList(growable: false),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _SuccessTipCard extends StatelessWidget {
  const _SuccessTipCard({required this.tip});

  final _Tip tip;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: AppColors.colorSuccessLight,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: const Icon(
              LucideIcons.circleCheck,
              size: 18,
              color: AppColors.colorSuccessText,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  tip.text,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral500,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.colorNeutral500,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _StudyArea {
  const _StudyArea({
    required this.value,
    required this.label,
    required this.icon,
    required this.color,
    required this.lightColor,
    required this.borderColor,
    required this.description,
    required this.faculties,
  });

  final String value;
  final String label;
  final IconData icon;
  final Color color;
  final Color lightColor;
  final Color borderColor;
  final String description;
  final List<String> faculties;
}

class _Tip {
  const _Tip(this.title, this.text);

  final String title;
  final String text;
}

const _studyAreas = [
  _StudyArea(
    value: 'umanistica',
    label: 'Umanistica',
    icon: LucideIcons.bookOpen,
    color: Color(0xFFF59E0B),
    lightColor: Color(0xFFFFFBEB),
    borderColor: Color(0xFFFEF3C7),
    description:
        "Studia il pensiero, il linguaggio e la storia dell'umanità. Forma capacità critiche, comunicative e interpretative molto richieste in ambiti come editoria, comunicazione, cultura e pubblica amministrazione.",
    faculties: [
      'Lettere e Filosofia',
      'Lingue e Letterature Straniere',
      'Storia',
      'Scienze della Comunicazione',
      'Beni Culturali',
      'Pedagogia',
    ],
  ),
  _StudyArea(
    value: 'scientifica',
    label: 'Scientifica',
    icon: LucideIcons.zap,
    color: Color(0xFF3B82F6),
    lightColor: Color(0xFFEFF6FF),
    borderColor: Color(0xFFDBEAFE),
    description:
        'Indaga i fenomeni naturali attraverso il metodo sperimentale. Richiede solide basi matematiche e logiche. Sbocca in ricerca, industria farmaceutica, ambiente e tecnologia.',
    faculties: [
      'Matematica',
      'Fisica',
      'Chimica',
      'Biologia',
      'Scienze Naturali',
      'Scienze Geologiche',
      'Biotecnologie',
    ],
  ),
  _StudyArea(
    value: 'ingegneria',
    label: 'Ingegneria & Informatica',
    icon: LucideIcons.monitor,
    color: Color(0xFF2563EB),
    lightColor: Color(0xFFEFF6FF),
    borderColor: Color(0xFFDBEAFE),
    description:
        "Progetta sistemi, processi e soluzioni tecnologiche. È l'area con i tassi di occupazione più alti in Italia. Richiede attitudine al problem solving e buone basi matematiche.",
    faculties: [
      'Ingegneria Informatica',
      'Ingegneria Elettronica',
      'Ingegneria Meccanica',
      'Ingegneria Civile',
      'Informatica',
      'Ingegneria Gestionale',
      'Ingegneria Biomedica',
    ],
  ),
  _StudyArea(
    value: 'economica',
    label: 'Economica & Giuridica',
    icon: LucideIcons.briefcaseBusiness,
    color: Color(0xFF22C55E),
    lightColor: Color(0xFFF0FDF4),
    borderColor: Color(0xFFDCFCE7),
    description:
        'Analizza mercati, organizzazioni e sistemi normativi. Forma profili versatili richiesti in aziende, studi professionali, banche e pubblica amministrazione.',
    faculties: [
      'Economia e Commercio',
      'Giurisprudenza',
      'Scienze Politiche',
      'Management',
      'Economia Aziendale',
      'Finanza',
      'Relazioni Internazionali',
    ],
  ),
  _StudyArea(
    value: 'sanitaria',
    label: 'Sanitaria',
    icon: LucideIcons.heart,
    color: Color(0xFFF43F5E),
    lightColor: Color(0xFFFFF1F2),
    borderColor: Color(0xFFFFE4E6),
    description:
        'Si occupa della salute umana a 360 gradi, dalla diagnosi alla cura, dalla prevenzione alla riabilitazione. Molti corsi sono a numero chiuso e richiedono il superamento del TOLC-MED.',
    faculties: [
      'Medicina e Chirurgia',
      'Farmacia',
      'Infermieristica',
      'Fisioterapia',
      'Odontoiatria',
      'Veterinaria',
      'Scienze Motorie',
    ],
  ),
  _StudyArea(
    value: 'artistica',
    label: 'Artistica & del Design',
    icon: LucideIcons.layers,
    color: Color(0xFFA855F7),
    lightColor: Color(0xFFFAF5FF),
    borderColor: Color(0xFFF3E8FF),
    description:
        'Combina creatività e tecnica per progettare spazi, oggetti, esperienze visive e digitali. Richiede portfolio e spesso si affianca ad Accademie di Belle Arti e istituti AFAM.',
    faculties: [
      'Architettura',
      'Design del Prodotto',
      'Design della Comunicazione',
      'DAMS',
      'Belle Arti',
      'Moda e Costume',
      'Scenografia',
    ],
  ),
];

const _studyAreaTips = [
  _Tip(
    'Parti dalle materie che ami davvero',
    'Non scegliere un corso perché è "il migliore" se le materie ti annoiano. La motivazione intrinseca è il fattore numero uno nel completare gli studi nei tempi.',
  ),
  _Tip(
    'Considera la sede geografica',
    'Studiare lontano da casa ha costi e benefici reali: indipendenza, rete di contatti più ampia, ma anche affitto, distanza dalla famiglia e maggiore autogestione richiesta.',
  ),
  _Tip(
    'Triennale vs magistrale',
    'La triennale da sola apre già molte porte. Non è obbligatorio proseguire con la magistrale, dipende dal settore. Valuta entrambe le opzioni prima di scegliere il percorso.',
  ),
  _Tip(
    'Open day e visite in ateneo',
    'Prima di iscriverti, vai a un open day. Parla con gli studenti del corso che ti interessa, non solo con i professori. Loro ti diranno la verità su carichi, esami e organizzazione.',
  ),
];

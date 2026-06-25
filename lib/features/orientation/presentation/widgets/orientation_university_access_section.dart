import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';

class OrientationUniversityAccessSection extends StatelessWidget {
  const OrientationUniversityAccessSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Libero o a numero chiuso?',
          subtitle:
              'In Italia esistono tre modalità di accesso. Capire in quale categoria rientra il corso che ti interessa è il primo passo.',
        ),
        const SizedBox(height: 14),
        for (final type in _accessTypes) ...[
          _AccessTypeCard(type: type),
          const SizedBox(height: 12),
        ],
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'I TOLC - il sistema di test più diffuso',
          subtitle:
              "I TOLC sono test standardizzati gestiti dal consorzio CISIA, somministrati in modalità informatizzata. Ogni tipo è specifico per un'area disciplinare e può essere ripetuto una volta al mese.",
        ),
        const SizedBox(height: 14),
        for (final test in _tolcTests) ...[
          _TolcCard(test: test),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.colorInfoLight.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(AppColors.radiusLg),
            border: Border.all(
              color: AppColors.colorInfoDark.withValues(alpha: 0.25),
            ),
          ),
          child: Row(
            children: [
              const Icon(
                LucideIcons.externalLink,
                size: 17,
                color: AppColors.colorInfoText,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'CISIA - Simulazioni gratuite dei TOLC',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorInfoText,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Cosa fare concretamente',
          subtitle:
              'Quattro cose che fanno la differenza tra chi si trova impreparato e chi no.',
        ),
        const SizedBox(height: 14),
        for (final tip in _accessTips) ...[
          _SuccessTipCard(tip: tip),
          const SizedBox(height: 10),
        ],
      ],
    );
  }
}

class _AccessTypeCard extends StatelessWidget {
  const _AccessTypeCard({required this.type});

  final _AccessType type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: type.lightColor,
                  borderRadius: BorderRadius.circular(AppColors.radiusMd),
                ),
                child: Icon(type.icon, size: 18, color: type.color),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  type.title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            type.description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral500,
              height: 1.45,
            ),
          ),
          const SizedBox(height: 15),
          Text(
            'Esempi di corsi',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.colorNeutral400,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 9),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: type.examples
                .map(
                  (example) => CustomBadgeWidget(
                    label: example,
                    variant: BadgeVariant.neutral,
                    shape: BadgeShape.rounded,
                    size: BadgeSize.sm,
                  ),
                )
                .toList(growable: false),
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.colorNeutral100,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Text(
              '💡 ${type.note}',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.colorNeutral500,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TolcCard extends StatelessWidget {
  const _TolcCard({required this.test});

  final _TolcTest test;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.colorNeutral100,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: AppColors.colorNeutral200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                test.type,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '- ${test.course}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: AppColors.colorNeutral400,
                  ),
                ),
              ),
              CustomBadgeWidget(
                label: test.university,
                variant: BadgeVariant.primary,
                shape: BadgeShape.pill,
                size: BadgeSize.xs,
              ),
            ],
          ),
          const SizedBox(height: 11),
          Wrap(
            spacing: 7,
            runSpacing: 7,
            children: test.subjects
                .map(
                  (subject) => CustomBadgeWidget(
                    label: subject,
                    variant: BadgeVariant.neutral,
                    shape: BadgeShape.rounded,
                    size: BadgeSize.xs,
                  ),
                )
                .toList(growable: false),
          ),
        ],
      ),
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

class _AccessType {
  const _AccessType({
    required this.id,
    required this.title,
    required this.description,
    required this.examples,
    required this.note,
    required this.icon,
    required this.color,
    required this.lightColor,
  });

  final String id;
  final String title;
  final String description;
  final List<String> examples;
  final String note;
  final IconData icon;
  final Color color;
  final Color lightColor;
}

class _TolcTest {
  const _TolcTest({
    required this.university,
    required this.course,
    required this.type,
    required this.subjects,
  });

  final String university;
  final String course;
  final String type;
  final List<String> subjects;
}

class _Tip {
  const _Tip(this.title, this.text);

  final String title;
  final String text;
}

const _accessTypes = [
  _AccessType(
    id: 'free',
    title: 'Accesso libero',
    description:
        'Puoi iscriverti senza superare alcun test selettivo. In alcuni casi è previsto un TOLC orientativo: non è uno sbarramento, ma il risultato può influenzare il tuo piano di studi o darti crediti aggiuntivi.',
    examples: [
      'Lettere e Filosofia',
      'Scienze Politiche',
      'Sociologia',
      'Economia',
      'Giurisprudenza',
      'Comunicazione',
    ],
    note:
        'Accesso libero non significa corso facile. Il carico didattico può essere elevato quanto un corso a numero chiuso.',
    icon: LucideIcons.bookOpen,
    color: Color(0xFF22C55E),
    lightColor: Color(0xFFF0FDF4),
  ),
  _AccessType(
    id: 'national-restricted',
    title: 'Programmato nazionale',
    description:
        'I posti sono stabiliti a livello nazionale dal MIUR. Il test di ammissione è unico per tutti gli atenei italiani e si sostiene in una data fissa. La graduatoria è nazionale.',
    examples: [
      'Medicina e Chirurgia',
      'Odontoiatria',
      'Medicina Veterinaria',
      'Architettura',
    ],
    note:
        'Per Medicina il test si chiama TOLC-MED dal 2023. Si può tentare più volte: la graduatoria considera il punteggio migliore.',
    icon: LucideIcons.users,
    color: Color(0xFFEF4444),
    lightColor: Color(0xFFFEF2F2),
  ),
  _AccessType(
    id: 'local-restricted',
    title: 'Programmato locale',
    description:
        "Ogni ateneo fissa autonomamente i propri posti e le modalità di ammissione. Il test può variare da università a università: verifica sempre il bando del singolo ateneo.",
    examples: [
      'Infermieristica',
      'Fisioterapia',
      'Farmacia',
      'Ingegneria',
      'Psicologia',
      'Scienze della Formazione Primaria',
    ],
    note:
        'Per i corsi a programmazione locale puoi candidarti a più atenei contemporaneamente.',
    icon: LucideIcons.calendarDays,
    color: Color(0xFFF59E0B),
    lightColor: Color(0xFFFFFBEB),
  ),
];

const _tolcTests = [
  _TolcTest(
    university: 'Vari atenei',
    course: 'Medicina e Chirurgia',
    type: 'TOLC-MED',
    subjects: [
      'Biologia',
      'Chimica',
      'Fisica e Matematica',
      'Ragionamento logico',
      'Comprensione del testo',
    ],
  ),
  _TolcTest(
    university: 'Vari atenei',
    course: 'Ingegneria',
    type: 'TOLC-I',
    subjects: ['Matematica', 'Logica', 'Scienze', 'Comprensione verbale'],
  ),
  _TolcTest(
    university: 'Vari atenei',
    course: 'Economia',
    type: 'TOLC-E',
    subjects: ['Matematica', 'Comprensione verbale', 'Logica', 'Inglese'],
  ),
  _TolcTest(
    university: 'Vari atenei',
    course: 'Scienze (bio, chim, farm)',
    type: 'TOLC-S',
    subjects: [
      'Biologia',
      'Chimica',
      'Matematica e Fisica',
      'Ragionamento logico',
    ],
  ),
];

const _accessTips = [
  _Tip(
    'Controlla il bando ogni anno',
    "Le modalità di accesso cambiano ogni anno accademico. Un corso che era libero può diventare programmato. Verifica sempre il sito ufficiale dell'ateneo e il portale universitaly.it.",
  ),
  _Tip(
    'Le scadenze sono rigide',
    "Per i corsi programmati, perdere la scadenza di iscrizione al test significa aspettare un anno. Segna tutte le date sul calendario con largo anticipo: alcune scadenze cadono in primavera per corsi che iniziano in ottobre.",
  ),
  _Tip(
    'Iscriviti al TOLC il prima possibile',
    "I TOLC si prenotano sul sito CISIA e i posti nelle sessioni si esauriscono. Non aspettare l'estate: le sessioni primaverili ti danno tempo di ritentare se il risultato non ti soddisfa.",
  ),
  _Tip(
    'Studia il piano di studi prima di iscriverti',
    'Per i corsi a numero chiuso, verifica il piano di studi completo prima di sostenere il test. È frustrante prepararsi mesi per un test e poi scoprire che il corso non è quello che immaginavi.',
  ),
];

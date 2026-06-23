import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_card/custom_card_widget.dart';
import 'orientation_expandable_card.dart';
import 'orientation_simple_charts.dart';

class OrientationHowUniversityWorksSection extends StatelessWidget {
  const OrientationHowUniversityWorksSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 28),
        const _SectionHeader(
          title: 'Scuola vs università - le differenze chiave',
          subtitle:
              'Prima di scegliere, è utile capire cosa cambia concretamente rispetto alla scuola superiore.',
        ),
        const SizedBox(height: 14),
        for (final item in _differences) ...[
          OrientationExpandableCard(
            icon: item.icon,
            title: item.title,
            subtitle: 'Scuola: ${item.school}',
            description: 'Università\n${item.university}',
            chips: const ['Scuola', 'Università'],
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        const _SectionHeader(
          title: 'Cosa sono i CFU?',
          subtitle:
              'I Crediti Formativi Universitari misurano il carico di lavoro di ogni esame. 1 CFU equivale a circa 25 ore; una laurea triennale richiede 180 CFU.',
        ),
        const SizedBox(height: 14),
        const OrientationCfuChart(),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Tipi di esame',
          subtitle:
              'Capire il tipo di esame aiuta a scegliere un corso coerente con il proprio stile di apprendimento.',
        ),
        const SizedBox(height: 14),
        for (final item in _examTypes) ...[
          OrientationExpandableCard(
            icon: item.icon,
            title: item.title,
            subtitle: item.description,
            description: item.description,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        const _SectionHeader(
          title: "Le sessioni d'esame",
          subtitle:
              'Gli esami sono concentrati in periodi precisi. Ogni sessione comprende più appelli tra cui scegliere.',
        ),
        const SizedBox(height: 14),
        for (final item in _sessions) ...[
          OrientationExpandableCard(
            icon: item.icon,
            title: item.title,
            subtitle: item.subtitle,
            description: item.description,
          ),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 14),
        const _StatusCard(
          icon: LucideIcons.triangleAlert,
          title: 'Autonomia totale - nessuno ti segue',
          description:
              "All'università sei responsabile del tuo percorso: devi gestire studio, scadenze e richieste di supporto.",
          color: AppColors.colorWarningDark,
          background: AppColors.colorWarningLight,
        ),
        const SizedBox(height: 24),
        const _SectionHeader(
          title: 'Come affrontarla nel modo giusto',
          subtitle:
              'Tre abitudini fanno la differenza tra chi resta al passo e chi accumula ritardi.',
        ),
        const SizedBox(height: 14),
        for (final item in _tips) ...[
          _StatusCard(
            icon: LucideIcons.circleCheck,
            title: item.title,
            description: item.description,
            color: AppColors.colorSuccessText,
            background: AppColors.colorSuccessLight,
          ),
          const SizedBox(height: 10),
        ],
      ],
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

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
    required this.background,
  });

  final IconData icon;
  final String title;
  final String description;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return CustomCardWidget(
      variant: CardVariant.defaultVariant,
      padding: CardPadding.md,
      shadow: CardShadow.none,
      radius: CardRadius.lg,
      bordered: true,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: background,
              borderRadius: BorderRadius.circular(AppColors.radiusMd),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral600,
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

class _Item {
  const _Item(this.icon, this.title, this.subtitle, this.description);

  final IconData icon;
  final String title;
  final String subtitle;
  final String description;
}

class _Difference {
  const _Difference(this.icon, this.title, this.school, this.university);

  final IconData icon;
  final String title;
  final String school;
  final String university;
}

class _Tip {
  const _Tip(this.title, this.description);

  final String title;
  final String description;
}

const _differences = [
  _Difference(
    LucideIcons.calendarCheck,
    'Frequenza',
    'Obbligatoria, controllata ogni giorno',
    'Spesso facoltativa: sei tu a scegliere.',
  ),
  _Difference(
    LucideIcons.filePenLine,
    'Verifiche',
    "Continue, distribuite durante l'anno",
    "Concentrate nelle sessioni d'esame.",
  ),
  _Difference(
    LucideIcons.handHelping,
    'Supporto',
    'I professori seguono ogni studente',
    'Sei autonomo e chiedi tu quando hai bisogno.',
  ),
  _Difference(
    LucideIcons.gauge,
    'Ritmo',
    "Scandito dall'istituto, poco flessibile",
    'Gestisci tu il piano e i tempi.',
  ),
];

const _examTypes = [
  _Item(
    LucideIcons.filePenLine,
    'Scritto',
    '',
    'Prova in aula a risposta aperta, multipla o mista, svolta in un tempo definito.',
  ),
  _Item(
    LucideIcons.messageSquare,
    'Orale',
    '',
    'Colloquio con il docente che valuta comprensione e capacità di esporre gli argomenti.',
  ),
  _Item(
    LucideIcons.layers,
    'Scritto + Orale',
    '',
    "Si supera prima lo scritto e poi si sostiene l'orale per definire il voto finale.",
  ),
  _Item(
    LucideIcons.folderOpen,
    'Progetto / Elaborato',
    '',
    'Si consegna un lavoro pratico, spesso discusso davanti al docente o alla commissione.',
  ),
];

const _sessions = [
  _Item(
    LucideIcons.calendarDays,
    'Sessione invernale',
    'Gennaio - Febbraio',
    'Esami del primo semestre.',
  ),
  _Item(
    LucideIcons.sun,
    'Sessione estiva',
    'Giugno - Luglio',
    'Esami del secondo semestre.',
  ),
  _Item(
    LucideIcons.calendarRange,
    'Sessione autunnale',
    'Settembre',
    'Recupero e appelli straordinari.',
  ),
];

const _tips = [
  _Tip(
    'Costruisci una routine fin dal primo mese',
    'Stabilisci subito orari fissi di studio: anche due ore al giorno dopo le lezioni fanno una grande differenza.',
  ),
  _Tip(
    'Non aspettare la sessione per studiare',
    'Distribuire lo studio durante il semestre permette di arrivare agli esami con gran parte del materiale già consolidato.',
  ),
  _Tip(
    'Chiedi aiuto prima che sia tardi',
    'Usa ricevimenti e tutor quando un argomento non è chiaro, senza rimandare il problema alla sessione.',
  ),
];


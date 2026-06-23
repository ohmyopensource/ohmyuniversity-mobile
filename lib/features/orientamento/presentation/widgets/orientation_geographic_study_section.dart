import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_badge/custom_badge_widget.dart';
import '../../../../shared/widgets/custom_button/custom_button_widget.dart';

class OrientationGeographicStudySection extends StatefulWidget {
  const OrientationGeographicStudySection({super.key});

  @override
  State<OrientationGeographicStudySection> createState() =>
      _OrientationGeographicStudySectionState();
}

class _OrientationGeographicStudySectionState
    extends State<OrientationGeographicStudySection> {
  String _activeArea = 'Nord';
  String? _expandedCity;

  _GeoAreaInfo get _selectedArea =>
      _geoAreaInfo.firstWhere((area) => area.area == _activeArea);

  void _toggleCity(String city) {
    setState(() => _expandedCity = _expandedCity == city ? null : city);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(
          title: 'Confronto tra aree geografiche',
          subtitle:
              "Seleziona un'area per vedere come si comporta su quattro dimensioni chiave della vita universitaria.",
        ),
        const SizedBox(height: 14),
        Row(
          children: _geoAreaInfo
              .map(
                (area) => Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 3),
                    child: CustomButtonWidget(
                      label: area.shortLabel,
                      icon: area.icon,
                      variant: _activeArea == area.area
                          ? area.buttonVariant
                          : ButtonVariant.outline,
                      size: ButtonSize.sm,
                      fullWidth: true,
                      onPressed: () => setState(() => _activeArea = area.area),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        ),
        const SizedBox(height: 14),
        _AreaRatingPanel(area: _selectedArea),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Costi medi per area geografica',
          subtitle:
              'Affitti e costo della vita variano enormemente tra Nord e Sud. Ecco una panoramica realistica.',
        ),
        const SizedBox(height: 14),
        for (final cost in _geographicAreaCosts) ...[
          _CostAreaCard(cost: cost),
          const SizedBox(height: 10),
        ],
        const SizedBox(height: 18),
        _SectionHeader(
          title: 'Città universitarie: le migliori per categoria',
          subtitle:
              'Non esiste la città perfetta per tutti. Apri una città per scoprire perché eccelle in quella categoria.',
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
                for (var index = 0; index < _topCities.length; index++) ...[
                  _CityTile(
                    city: _topCities[index],
                    expanded: _expandedCity == _topCities[index].city,
                    onTap: () => _toggleCity(_topCities[index].city),
                  ),
                  if (index != _topCities.length - 1)
                    const Divider(height: 1, color: AppColors.colorNeutral100),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 28),
        _SectionHeader(
          title: 'Come scegliere la città giusta',
          subtitle:
              'Tre consigli pratici prima di prendere una decisione definitiva.',
        ),
        const SizedBox(height: 14),
        for (var index = 0; index < _geoTips.length; index++)
          _TipItem(tip: _geoTips[index], last: index == _geoTips.length - 1),
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

class _AreaRatingPanel extends StatelessWidget {
  const _AreaRatingPanel({required this.area});

  final _GeoAreaInfo area;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      decoration: BoxDecoration(
        color: area.lightColor,
        borderRadius: BorderRadius.circular(AppColors.radiusLg),
        border: Border.all(color: area.borderColor),
      ),
      child: Column(
        children: area.ratings
            .map(
              (rating) => Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rating.aspect,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            rating.description,
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: AppColors.colorNeutral500,
                                  height: 1.3,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Container(
                          width: 9,
                          height: 9,
                          margin: const EdgeInsets.only(left: 4),
                          decoration: BoxDecoration(
                            color: index < rating.value
                                ? area.dotColor
                                : AppColors.colorNeutral200,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _CostAreaCard extends StatelessWidget {
  const _CostAreaCard({required this.cost});

  final _GeographicAreaCost cost;

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
              CustomBadgeWidget(
                label: cost.area,
                variant: cost.variant,
                shape: BadgeShape.pill,
                size: BadgeSize.sm,
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  cost.rent,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              CustomBadgeWidget(
                label: cost.livingCost,
                variant: BadgeVariant.neutral,
                shape: BadgeShape.rounded,
                size: BadgeSize.xs,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            cost.cities,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: AppColors.colorNeutral400,
              height: 1.35,
            ),
          ),
          const SizedBox(height: 7),
          Text(
            cost.note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.colorNeutral500,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _CityTile extends StatelessWidget {
  const _CityTile({
    required this.city,
    required this.expanded,
    required this.onTap,
  });

  final _TopCity city;
  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = _cityColors[city.city] ?? _cityColors['Bologna']!;
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
                    color: expanded ? colors.active : colors.light,
                    borderRadius: BorderRadius.circular(AppColors.radiusLg),
                  ),
                  child: Icon(
                    city.icon,
                    size: 19,
                    color: expanded ? Colors.white : colors.active,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        city.city,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      CustomBadgeWidget(
                        label: city.badge,
                        variant: BadgeVariant.primary,
                        shape: BadgeShape.pill,
                        size: BadgeSize.xs,
                      ),
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
              color: colors.light,
              border: Border(top: BorderSide(color: colors.border)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomBadgeWidget(
                  label: city.category,
                  variant: BadgeVariant.neutral,
                  shape: BadgeShape.rounded,
                  size: BadgeSize.xs,
                ),
                const SizedBox(height: 11),
                Text(
                  city.reason,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.colorNeutral600,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 13),
                Wrap(
                  spacing: 7,
                  runSpacing: 7,
                  children: city.stats
                      .map(
                        (stat) => CustomBadgeWidget(
                          label: stat,
                          variant: city.badgeVariant,
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

class _TipItem extends StatelessWidget {
  const _TipItem({required this.tip, required this.last});

  final _GeoTip tip;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 12,
              height: 12,
              margin: const EdgeInsets.only(top: 5),
              decoration: const BoxDecoration(
                color: AppColors.colorInfoDark,
                shape: BoxShape.circle,
              ),
            ),
            if (!last)
              Container(
                width: 1,
                height: 64,
                margin: const EdgeInsets.symmetric(vertical: 4),
                color: AppColors.colorInfoLight,
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(bottom: last ? 0 : 18),
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
        ),
      ],
    );
  }
}

class _GeoAreaInfo {
  const _GeoAreaInfo({
    required this.area,
    required this.shortLabel,
    required this.icon,
    required this.buttonVariant,
    required this.lightColor,
    required this.borderColor,
    required this.dotColor,
    required this.ratings,
  });

  final String area;
  final String shortLabel;
  final IconData icon;
  final ButtonVariant buttonVariant;
  final Color lightColor;
  final Color borderColor;
  final Color dotColor;
  final List<_GeoRating> ratings;
}

class _GeoRating {
  const _GeoRating(this.aspect, this.value, this.description);

  final String aspect;
  final int value;
  final String description;
}

class _GeographicAreaCost {
  const _GeographicAreaCost({
    required this.area,
    required this.rent,
    required this.livingCost,
    required this.cities,
    required this.note,
    required this.variant,
  });

  final String area;
  final String rent;
  final String livingCost;
  final String cities;
  final String note;
  final BadgeVariant variant;
}

class _TopCity {
  const _TopCity({
    required this.city,
    required this.area,
    required this.category,
    required this.reason,
    required this.badge,
    required this.stats,
    required this.icon,
  });

  final String city;
  final String area;
  final String category;
  final String reason;
  final String badge;
  final List<String> stats;
  final IconData icon;

  BadgeVariant get badgeVariant => switch (area) {
    'Nord' => BadgeVariant.primary,
    'Centro' => BadgeVariant.warning,
    _ => BadgeVariant.success,
  };
}

class _CityColors {
  const _CityColors({
    required this.active,
    required this.light,
    required this.border,
  });

  final Color active;
  final Color light;
  final Color border;
}

class _GeoTip {
  const _GeoTip(this.title, this.text);

  final String title;
  final String text;
}

const _geoAreaInfo = [
  _GeoAreaInfo(
    area: 'Nord',
    shortLabel: 'Nord',
    icon: LucideIcons.building2,
    buttonVariant: ButtonVariant.primary,
    lightColor: Color(0xFFEFF6FF),
    borderColor: Color(0xFFBFDBFE),
    dotColor: Color(0xFF3B82F6),
    ratings: [
      _GeoRating(
        'Opportunità lavoro',
        5,
        'Altissima concentrazione di aziende e stage',
      ),
      _GeoRating(
        'Costo della vita',
        2,
        "Tra i più alti d'Italia, soprattutto Milano",
      ),
      _GeoRating('Trasporti', 5, 'Reti metro, tram e treni efficienti'),
      _GeoRating('Vita sociale', 4, 'Molta offerta culturale e di svago'),
    ],
  ),
  _GeoAreaInfo(
    area: 'Centro',
    shortLabel: 'Centro',
    icon: LucideIcons.compass,
    buttonVariant: ButtonVariant.warning,
    lightColor: Color(0xFFFFFBEB),
    borderColor: Color(0xFFFDE68A),
    dotColor: Color(0xFFF59E0B),
    ratings: [
      _GeoRating(
        'Opportunità lavoro',
        3,
        'Buone opportunità, forte presenza del pubblico',
      ),
      _GeoRating(
        'Costo della vita',
        3,
        'Medio - Roma cara, altre città accessibili',
      ),
      _GeoRating('Trasporti', 3, 'Variabile - Roma complessa, Firenze ottima'),
      _GeoRating('Vita sociale', 5, 'Arte, storia e cultura ovunque'),
    ],
  ),
  _GeoAreaInfo(
    area: 'Sud e Isole',
    shortLabel: 'Sud',
    icon: LucideIcons.sun,
    buttonVariant: ButtonVariant.success,
    lightColor: Color(0xFFF0FDF4),
    borderColor: Color(0xFFBBF7D0),
    dotColor: Color(0xFF22C55E),
    ratings: [
      _GeoRating(
        'Opportunità lavoro',
        2,
        'Mercato più limitato, spesso si cerca altrove',
      ),
      _GeoRating(
        'Costo della vita',
        5,
        'Tra i più bassi - affitti e cibo molto economici',
      ),
      _GeoRating('Trasporti', 2, "Meno sviluppati, spesso necessaria l'auto"),
      _GeoRating(
        'Vita sociale',
        4,
        'Comunità studentesche vivaci e accoglienti',
      ),
    ],
  ),
];

const _geographicAreaCosts = [
  _GeographicAreaCost(
    area: 'Nord',
    rent: '450-700 €/mese',
    livingCost: 'Alto',
    cities: 'Milano, Torino, Bologna, Padova',
    note:
        "Milano è la città più cara d'Italia per gli studenti. Bologna e Padova sono più accessibili ma restano sopra la media.",
    variant: BadgeVariant.error,
  ),
  _GeographicAreaCost(
    area: 'Centro',
    rent: '350-550 €/mese',
    livingCost: 'Medio',
    cities: 'Roma, Firenze, Pisa, Perugia',
    note:
        'Roma ha costi simili al Nord nelle zone universitarie. Perugia e Pisa offrono un buon rapporto qualità-prezzo.',
    variant: BadgeVariant.warning,
  ),
  _GeographicAreaCost(
    area: 'Sud e Isole',
    rent: '200-400 €/mese',
    livingCost: 'Basso',
    cities: 'Napoli, Bari, Catania, Palermo, Salerno',
    note:
        "Il costo della vita significativamente più basso può compensare una minor reputazione dell'ateneo in alcuni settori.",
    variant: BadgeVariant.success,
  ),
];

const _topCities = [
  _TopCity(
    city: 'Bologna',
    area: 'Nord',
    category: 'Migliore per vita universitaria',
    reason:
        'Studentesca per eccellenza, una delle città con la più alta percentuale di studenti in Italia. Servizi, locali, cultura e ateneo di altissimo livello.',
    badge: 'Top assoluto',
    stats: [
      '100.000+ studenti universitari',
      'Affitto medio 500-650 €/mese',
      'Ateneo fondato nel 1088',
    ],
    icon: LucideIcons.bookMarked,
  ),
  _TopCity(
    city: 'Milano',
    area: 'Nord',
    category: 'Migliore per networking e lavoro',
    reason:
        'Hub economico italiano. Gli stage e le opportunità di lavoro durante gli studi sono incomparabili. Costi alti, ma il ritorno è spesso elevato.',
    badge: 'Carriera',
    stats: [
      '200+ aziende Fortune 500 presenti',
      'Affitto medio 700-950 €/mese',
      '85% laureati trova lavoro entro 1 anno',
    ],
    icon: LucideIcons.briefcase,
  ),
  _TopCity(
    city: 'Torino',
    area: 'Nord',
    category: 'Migliore per qualità/prezzo al Nord',
    reason:
        'Ottimi atenei tecnici, costi più accessibili di Milano, città vivace con forte identità culturale e buoni trasporti pubblici.',
    badge: 'Qualità/prezzo',
    stats: [
      'Politecnico tra i top 200 al mondo',
      'Affitto medio 400-550 €/mese',
      '100.000+ studenti in città',
    ],
    icon: LucideIcons.zap,
  ),
  _TopCity(
    city: 'Napoli',
    area: 'Sud',
    category: 'Migliore per risparmio con cultura',
    reason:
        "Costi tra i più bassi in Italia, università storiche, vita sociale intensa. Ideale per chi vuole un'esperienza universitaria autentica senza indebitarsi.",
    badge: 'Risparmio',
    stats: [
      'Affitto medio 250-380 €/mese',
      'Federico II: 80.000+ iscritti',
      'Pasto in mensa da 3 €',
    ],
    icon: LucideIcons.wallet,
  ),
  _TopCity(
    city: 'Pisa',
    area: 'Centro',
    category: 'Migliore per eccellenza accademica',
    reason:
        "Scuola Normale Superiore e Scuola Sant'Anna, due delle migliori istituzioni d'Italia. Città a misura di studente, costi contenuti, ambiente stimolante.",
    badge: 'Accademia',
    stats: [
      'Scuola Normale: 70+ premi Nobel tra alumni',
      'Affitto medio 350-500 €/mese',
      '1 studente ogni 3 abitanti',
    ],
    icon: LucideIcons.graduationCap,
  ),
  _TopCity(
    city: 'Bari',
    area: 'Sud',
    category: 'Migliore per vivibilità al Sud',
    reason:
        'Città moderna e dinamica, costi bassissimi, ateneo solido, ottimi collegamenti. Una delle mete emergenti per chi sceglie il Sud consapevolmente.',
    badge: 'Vivibilità',
    stats: [
      'Affitto medio 200-320 €/mese',
      'Hub ferroviario per tutto il Sud',
      '50.000+ studenti universitari',
    ],
    icon: LucideIcons.thumbsUp,
  ),
];

const _cityColors = {
  'Bologna': _CityColors(
    active: Color(0xFF3B82F6),
    light: Color(0xFFEFF6FF),
    border: Color(0xFFDBEAFE),
  ),
  'Milano': _CityColors(
    active: Color(0xFFA855F7),
    light: Color(0xFFFAF5FF),
    border: Color(0xFFF3E8FF),
  ),
  'Torino': _CityColors(
    active: Color(0xFF0EA5E9),
    light: Color(0xFFF0F9FF),
    border: Color(0xFFE0F2FE),
  ),
  'Napoli': _CityColors(
    active: Color(0xFF22C55E),
    light: Color(0xFFF0FDF4),
    border: Color(0xFFDCFCE7),
  ),
  'Pisa': _CityColors(
    active: Color(0xFFF59E0B),
    light: Color(0xFFFFFBEB),
    border: Color(0xFFFEF3C7),
  ),
  'Bari': _CityColors(
    active: Color(0xFFF43F5E),
    light: Color(0xFFFFF1F2),
    border: Color(0xFFFFE4E6),
  ),
};

const _geoTips = [
  _GeoTip(
    'Visita prima di scegliere',
    'Un weekend nella città che ti interessa vale più di mille recensioni online. Gira il quartiere universitario, parla con gli studenti e osserva il ritmo della città.',
  ),
  _GeoTip(
    'Cerca il gruppo Telegram del corso',
    'Quasi tutti i corsi hanno gruppi informali dove gli studenti condividono info su alloggi, costi reali e vita in città. Sono la fonte più onesta disponibile.',
  ),
  _GeoTip(
    'Il nord non è sempre la scelta migliore',
    'Laurearsi al Sud senza debiti e con una buona media spesso vale più di laurearsi al Nord con 30.000 € di spese alle spalle. Fai i conti prima di decidere.',
  ),
];

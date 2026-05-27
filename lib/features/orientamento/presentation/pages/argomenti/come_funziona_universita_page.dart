import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/theme/app_colors.dart';
import '../../widgets/info_section.dart';

const _pastelBackground = Color(0xFFEAF6F8);

class ComeFunzionaUniversitaPage extends StatefulWidget {
  const ComeFunzionaUniversitaPage({super.key});

  @override
  State<ComeFunzionaUniversitaPage> createState() =>
      _ComeFunzionaUniversitaPageState();
}

class _ComeFunzionaUniversitaPageState extends State<ComeFunzionaUniversitaPage> {
  late final PageController _pageController;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: _pastelBackground,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => context.goNamed(AppRoutes.orientamentoName),
                    icon: const Icon(LucideIcons.arrowLeft),
                    color: AppColors.textPrimary,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shape: const CircleBorder(),
                      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.34)),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Affronta l’università',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 48),
                ],
              ),
            ),
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => _currentPage = index);
                },
                children: const [
                  _OrientationScrollablePage(
                    title: 'Il salto di mentalità: gestione e autonomia',
                    child: _MindsetContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Cosa sono i CFU',
                    child: _CfuContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Come funzionano gli esami',
                    child: _ExamContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Frequenza obbligatoria?',
                    child: _AttendanceContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Manuale del fuorisede',
                    child: _OffCampusManualContent(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              child: _OrientationDots(
                count: 5,
                currentIndex: _currentPage,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrientationScrollablePage extends StatelessWidget {
  const _OrientationScrollablePage({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ColoredBox(
      color: Colors.transparent,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(28, 30, 28, 24),
        physics: const BouncingScrollPhysics(),
        children: [
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w900,
              color: AppColors.textPrimary,
              height: 1.18,
            ),
          ),
          const SizedBox(height: 34),
          child,
        ],
      ),
    );
  }
}

class _MindsetContent extends StatelessWidget {
  const _MindsetContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Gli orari “a groviera”.',
          body:
              'Dimentica la campanella e le cinque ore di fila al banco. All’università potresti avere una lezione alle 9:00 e la successiva alle 14:00. Il segreto per non impazzire è non restare indietro: è la massima organizzazione.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Il mistero dei CFU.',
          body:
              'I CFU misurano il tuo carico di lavoro reale. Per laurearti alla triennale te ne servono 180. La regola base è: 1 CFU = 25 ore di impegno totale, tra lezioni e studio individuale.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Il lavoro invisibile.',
          body:
              'L’università è un impegno a tempo pieno, anche quando non sei fisicamente in aula.',
        ),
        SizedBox(height: 42),
        Row(
          children: [
            Expanded(
              child: _CarouselStatHighlight(
                value: '40h',
                label: 'di impegno settimanale medio richiesto a uno studente',
                color: Color(0xFFF5B700),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: _CarouselStatHighlight(
                value: '3x',
                label: 'studio individuale vs ore di lezione',
                color: Color(0xFF20C997),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CfuContent extends StatelessWidget {
  const _CfuContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Cosa misurano davvero.',
          body:
              'I Crediti Formativi Universitari misurano il carico di studio complessivo: lezioni, esercitazioni, laboratori e studio personale.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'La regola pratica.',
          body:
              'Un CFU corrisponde a circa 25 ore di lavoro totale. Una laurea triennale richiede 180 CFU, una magistrale altri 120.',
        ),
        SizedBox(height: 42),
        Row(
          children: [
            Expanded(
              child: _CarouselStatHighlight(
                value: '180',
                label: 'CFU per completare una laurea triennale',
                color: Color(0xFF1A73E8),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: _CarouselStatHighlight(
                value: '25h',
                label: 'di studio e attività per ogni CFU',
                color: Color(0xFF34A853),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ExamContent extends StatelessWidget {
  const _ExamContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        TimelineStep(
          index: 1,
          title: 'Prenotazione',
          body:
              'Accedi al portale (Esse3/Cineca) e prenota l’esame entro la scadenza. Senza prenotazione non puoi sostenere l’esame.',
        ),
        TimelineStep(
          index: 2,
          title: 'Esame scritto o orale',
          body:
              'Ogni docente decide la forma: scritto, orale, o entrambi. I risultati vanno da 18 a 30/30, con la lode come riconoscimento eccezionale.',
        ),
        TimelineStep(
          index: 3,
          title: 'Verbalizzazione',
          body:
              'Dopo aver accettato il voto, viene verbalizzato: entra nel tuo libretto ufficiale e non può essere modificato.',
        ),
        TimelineStep(
          index: 4,
          title: 'Appelli e sessioni',
          body:
              'Gli esami si tengono nelle sessioni invernale, estiva e autunnale. Ogni sessione ha più appelli e puoi scegliere quando sostenerli.',
          isLast: true,
        ),
      ],
    );
  }
}

class _AttendanceContent extends StatelessWidget {
  const _AttendanceContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Dipende dal corso.',
          body:
              'Molti corsi non hanno obbligo di frequenza, ma frequentare ti aiuta a capire cosa porta all’esame e a fare domande.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Quando è obbligatoria.',
          body:
              'Laboratori, tirocini e corsi professionalizzanti possono avere frequenza obbligatoria per regolamento o per legge.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'La scelta intelligente.',
          body:
              'Anche quando puoi non frequentare, valuta bene: l’aula spesso ti fa risparmiare ore di studio individuale e chiarisce cosa interessa davvero al docente.',
        ),
      ],
    );
  }
}

class _OffCampusManualContent extends StatelessWidget {
  const _OffCampusManualContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Alloggi e contratti: il tempismo è tutto.',
          body:
              'La caccia alla stanza inizia mesi prima. Muoviti d’anticipo, sfruttando i periodi delle lauree, quando si liberano le stanze migliori e più vicine all’università. Infine, esigi sempre un contratto regolare.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Budget e coinquilini.',
          body:
              'L’affitto è solo il punto di partenza. Nel tuo budget mensile devi calcolare bollette e spese extra. Partire prima con la ricerca ti permette di trovare e bloccare prezzi molto più vantaggiosi. E per la convivenza? Armati di buon senso e spirito di collaborazione.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Sconti locali e trasporti.',
          body:
              'Ogni città ha il suo ente regionale per il diritto allo studio e mostrando il badge universitario puoi sbloccare abbonamenti ai mezzi pubblici a prezzi stracciati, pasti in mensa a pochi euro e sconti in palestre, cinema o locali convenzionati.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Regola d’oro.',
          body:
              'Mai pagare a prezzo pieno senza prima aver chiesto se c’è lo sconto studenti.',
        ),
        SizedBox(height: 42),
        Row(
          children: [
            Expanded(
              child: _CarouselStatHighlight(
                value: '450€',
                label: 'costo medio nazionale per singola stanza',
                color: Color(0xFFF5B700),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: _CityListHighlight(
                cities: ['Milano', 'Bologna', 'Roma'],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _CityListHighlight extends StatelessWidget {
  const _CityListHighlight({required this.cities});

  final List<String> cities;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.secondary.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: AppColors.secondary.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: cities.map((city) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(
              city,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.secondary,
                fontWeight: FontWeight.w900,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CarouselTextBlock extends StatelessWidget {
  const _CarouselTextBlock({
    required this.title,
    required this.body,
  });

  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          body,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.32,
            color: AppColors.textPrimary.withValues(alpha: 0.72),
          ),
        ),
      ],
    );
  }
}

class _CarouselStatHighlight extends StatelessWidget {
  const _CarouselStatHighlight({
    required this.value,
    required this.label,
    required this.color,
  });

  final String value;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      constraints: const BoxConstraints(minHeight: 112),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.24)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            value,
            style: theme.textTheme.headlineLarge?.copyWith(
              color: color,
              fontWeight: FontWeight.w900,
              height: 0.95,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              height: 1.16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrientationDots extends StatelessWidget {
  const _OrientationDots({
    required this.count,
    required this.currentIndex,
  });

  final int count;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (index) {
        final isActive = index == currentIndex;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 3),
          width: isActive ? 24 : 8,
          height: 8,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.primary),
            color: isActive
                ? AppColors.primary.withValues(alpha: 0.18)
                : Colors.transparent,
          ),
        );
      }),
    );
  }
}
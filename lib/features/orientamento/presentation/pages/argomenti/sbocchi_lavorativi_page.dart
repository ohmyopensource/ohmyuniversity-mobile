import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/theme/app_colors.dart';

const _pastelBackground = Color(0xFFE9F6ED);

class SbocchiLavorativiPage extends StatefulWidget {
  const SbocchiLavorativiPage({super.key});

  @override
  State<SbocchiLavorativiPage> createState() => _SbocchiLavorativiPageState();
}

class _SbocchiLavorativiPageState extends State<SbocchiLavorativiPage> {
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
                      side: BorderSide(
                        color: AppColors.primary.withValues(alpha: 0.34),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Text(
                      'Oltre la Laurea',
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
                    title: 'Prospettive e dati reali',
                    child: _CareerOutcomesContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Errori comuni da evitare',
                    child: _CommonMistakesContent(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              child: _OrientationDots(
                count: 2,
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

class _CommonMistakesContent extends StatelessWidget {
  const _CommonMistakesContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _MistakeBlock(
          color: Color(0xFFEA4335),
          title: 'Scegliere per moda',
          body:
              'Informatica, economia, marketing: ci sono corsi che "vanno" in un certo periodo storico. Ma se non ti appassionano, il rischio di abbandonare è altissimo. Il mercato del lavoro cambia: punta su ciò che ti motiva, non su ciò che è trendy.',
        ),
        SizedBox(height: 20),
        _MistakeBlock(
          color: Color(0xFFFF6D00),
          title: 'Seguire gli amici',
          body:
              'Andare nella stessa università degli amici può sembrare rassicurante. Ma se il corso non è giusto per te, saranno tre anni difficili. La scelta universitaria è personale: i tuoi amici avranno i loro percorsi, tu abbi il tuo.',
        ),
        SizedBox(height: 20),
        _MistakeBlock(
          color: Color(0xFF9C27B0),
          title: 'Sottovalutare matematica e logica',
          body:
              'Anche corsi apparentemente non tecnici richiedono statistica e logica. Arriva preparato: il primo anno spesso fa la selezione naturale proprio su queste basi.',
        ),
        SizedBox(height: 20),
        _MistakeBlock(
          color: Color(0xFF1A73E8),
          title: 'Non informarsi sugli esami',
          body:
              'Molti studenti si iscrivono senza aver mai visto un esame del corso che scelgono. Chiedi, leggi, cerca testimonianze: sapere cosa ti aspetta è già metà del lavoro.',
        ),
        SizedBox(height: 20),
        _MistakeBlock(
          color: Color(0xFF34A853),
          title: 'Rimandare la prima sessione',
          body:
              'Il primo anno è fondamentale. Chi rimanda gli esami della prima sessione tende ad accumulare ritardo che diventa sempre più difficile da recuperare. Inizia subito, anche se non sei sicuro di essere pronto.',
        ),
        SizedBox(height: 20),
        _MistakeBlock(
          color: Color(0xFFF5B700),
          title: 'Non informarsi su borse e agevolazioni',
          body:
              'Migliaia di studenti perdono ogni anno borse di studio e agevolazioni semplicemente perché non fanno domanda in tempo. Controlla bandi, borse di merito e posti in residenza.',
        ),
      ],
    );
  }
}

class _CareerOutcomesContent extends StatelessWidget {
  const _CareerOutcomesContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Consapevolezza del futuro e del mercato.',
          body:
              'Il mercato del lavoro evolve rapidamente e alcune professioni di domani potrebbero non esistere ancora oggi. La laurea è un ottimo punto di partenza, ma faranno la differenza adattabilità, soft skills e rete di contatti costruita durante gli studi.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Una visione aperta: l’orizzonte estero.',
          body:
              'Non limitare le prospettive ai confini nazionali. Erasmus, tirocini internazionali o lavoro da remoto per aziende straniere possono darti un vantaggio competitivo e rendere il tuo percorso più aperto al mercato europeo.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Sbocchi lavorativi per area.',
          body:
              'In questa sezione, selezionando la tua università e il tuo corso, potrai vedere i dati reali di occupazione a 1, 3 e 5 anni dalla laurea. I dati provengono da AlmaLaurea e dal European Data Portal.',
        ),
        SizedBox(height: 42),
        Row(
          children: [
            Expanded(
              child: _CarouselStatHighlight(
                value: '77%',
                label: 'laureati occupati a 1 anno, media nazionale',
                color: Color(0xFF34A853),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: _CarouselStatHighlight(
                value: '91%',
                label: 'laureati occupati a 5 anni',
                color: Color(0xFF1A73E8),
              ),
            ),
          ],
        ),
        SizedBox(height: 34),
        _DataIncomingBox(),
      ],
    );
  }
}

class _MistakeBlock extends StatelessWidget {
  const _MistakeBlock({
    required this.color,
    required this.title,
    required this.body,
  });

  final Color color;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: color.withValues(alpha: 0.22)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: color,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  body,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    height: 1.28,
                    color: AppColors.textPrimary.withValues(alpha: 0.72),
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

class _DataIncomingBox extends StatelessWidget {
  const _DataIncomingBox();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.primary.withValues(alpha: 0.24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            LucideIcons.database,
            size: 34,
            color: AppColors.primary,
          ),
          const SizedBox(height: 16),
          Text(
            'Dati in arrivo — fonte European Data Portal',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Seleziona università e corso di laurea per visualizzare i dati reali di occupazione, stipendio medio e settori di sbocco. I dati saranno aggiornati tramite le API del European Data Portal e di AlmaLaurea.',
            style: theme.textTheme.bodyLarge?.copyWith(
              height: 1.28,
              color: AppColors.textPrimary.withValues(alpha: 0.72),
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
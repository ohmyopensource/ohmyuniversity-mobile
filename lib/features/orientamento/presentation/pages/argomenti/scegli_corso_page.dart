import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons/lucide_icons.dart';

import '../../../../../config/routes/app_routes.dart';
import '../../../../../config/theme/app_colors.dart';

const _pastelBackground = Color(0xFFF6F5DE);

class ScegliCorsoPage extends StatefulWidget {
  const ScegliCorsoPage({super.key});

  @override
  State<ScegliCorsoPage> createState() => _ScegliCorsoPageState();
}

class _ScegliCorsoPageState extends State<ScegliCorsoPage> {
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
                      'Scopri il tuo percorso',
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
                    title: 'Parti da ciò che ti somiglia',
                    child: _ProfileContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Media, atenei e dati utili',
                    child: _UniversityChoiceContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Autovalutazione guidata',
                    child: _SelfAssessmentContent(),
                  ),
                  _OrientationScrollablePage(
                    title: 'Crea il tuo quiz',
                    child: _QuizCreationContent(),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 14, 24, 28),
              child: _OrientationDots(
                count: 4,
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

class _ProfileContent extends StatelessWidget {
  const _ProfileContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Parti dalle tue passioni.',
          body:
              'Il primo passo è capire cosa ti appassiona davvero. Non scegliere un corso per moda o per seguire gli amici: saranno tre o cinque anni della tua vita, e la motivazione fa tutta la differenza tra finire o abbandonare.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Materie e aree di interesse.',
          body:
              'Rifletti su quali materie ti hanno sempre attratto: scienze, lettere, economia, ingegneria, arte? Ogni corso universitario affonda le radici in una macro-area. Capire la tua ti aiuta a restringere il campo.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Area geografica.',
          body:
              'Vuoi studiare vicino a casa o sei disposto a trasferirti? La scelta dell’area geografica influisce sui costi di vita, sulle opportunità di stage e sul network che costruirai. Le grandi città universitarie offrono più opportunità, ma anche costi più alti.',
        ),
      ],
    );
  }
}

class _UniversityChoiceContent extends StatelessWidget {
  const _UniversityChoiceContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Calcola la tua media.',
          body:
              'Alcuni corsi — in particolare medicina, architettura e alcune facoltà scientifiche — prevedono un test d’ingresso. Conoscere la tua media scolastica ti dà un’idea del tuo punto di partenza rispetto ai requisiti richiesti.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Scegli l’università.',
          body:
              'Una volta definita la macro-area e la zona geografica, confronta le università disponibili: ranking, strutture, qualità del corpo docente, opportunità Erasmus e tasso di occupazione dei laureati sono tutti fattori da considerare.',
        ),
        SizedBox(height: 42),
        Row(
          children: [
            Expanded(
              child: _CarouselStatHighlight(
                value: '90+',
                label: 'corsi di laurea triennale in Italia',
                color: Color(0xFF1A73E8),
              ),
            ),
            SizedBox(width: 18),
            Expanded(
              child: _CarouselStatHighlight(
                value: '97',
                label: 'atenei pubblici e privati accreditati',
                color: Color(0xFF34A853),
              ),
            ),
          ],
        ),
        SizedBox(height: 32),
        _CarouselTextBlock(
          title: 'Dati aggiornati — fonte MUR.',
          body:
              'I dati sui corsi di laurea disponibili in Italia vengono aggiornati annualmente dal Ministero dell’Università e della Ricerca. In questa sezione mostreremo in futuro l’elenco aggiornato filtrato per area e regione.',
        ),
      ],
    );
  }
}

class _SelfAssessmentContent extends StatelessWidget {
  const _SelfAssessmentContent();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _CarouselTextBlock(
          title: 'Scegli l’università.',
          body:
              'Prima di fare un quiz, è utile già avere in mente due o tre atenei che ti attraggono. Il quiz ti aiuterà a capire se la tua scelta è coerente con il tuo profilo.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Scegli il corso universitario.',
          body:
              'Ogni corso ha prerequisiti diversi. Sapere verso quale corso ti stai orientando ti permette di fare una autovalutazione più precisa e mirata.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Macro-area del corso.',
          body:
              'Le macro-aree (ING/INF, TUR, MED, LET, ECO...) raggruppano corsi con caratteristiche simili. Conoscere la tua macro-area ti aiuta a capire il tipo di ragionamento e le competenze che ti saranno richieste.',
        ),
        SizedBox(height: 24),
        _CarouselTextBlock(
          title: 'Test d’ingresso.',
          body:
              'Molti corsi prevedono un test d’ingresso — alcuni selettivi, altri orientativi. In questa sezione troverai l’elenco dei test per ogni università selezionata e materiale per prepararti.',
        ),
      ],
    );
  }
}

class _QuizCreationContent extends StatelessWidget {
  const _QuizCreationContent();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const _CarouselTextBlock(
          title: 'Quiz in arrivo.',
          body:
              'Qui potrai costruire un quiz di orientamento partendo dai tuoi interessi, dalle materie che preferisci, dalla città in cui vuoi studiare e dal tipo di percorso che immagini per il tuo futuro.',
        ),
        const SizedBox(height: 28),
        Container(
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
                LucideIcons.clipboardList,
                size: 34,
                color: AppColors.primary,
              ),
              const SizedBox(height: 16),
              Text(
                'Prepara il tuo profilo',
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Nel prossimo step trasformeremo questa pagina in un vero quiz interattivo.',
                style: theme.textTheme.bodyLarge?.copyWith(
                  height: 1.28,
                  color: AppColors.textPrimary.withValues(alpha: 0.72),
                ),
              ),
            ],
          ),
        ),
      ],
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
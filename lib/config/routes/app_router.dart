import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/academic_career/presentation/pages/academic_career_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/aziende/presentation/pages/aziende_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/didattica/presentation/pages/administrative_page.dart';
import '../../features/didattica/presentation/pages/didattica_page.dart';
import '../../features/didattica/presentation/pages/study_plan_page.dart';
import '../../features/didattica/presentation/pages/tuition_fees_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifiche/presentation/pages/notifiche_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/come_funziona_universita_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/errori_comuni_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/quiz_autovalutazione_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/sbocchi_lavorativi_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/scegli_corso_page.dart';
import '../../features/orientamento/presentation/pages/argomenti/vita_universitaria_page.dart';
import '../../features/orientamento/presentation/pages/orientamento_page.dart';
import '../../features/preferiti/presentation/pages/preferiti_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../routes/app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.splash,
    debugLogDiagnostics: true,
    routes: [
      // Pre-auth ================================
      GoRoute(
        path: AppRoutes.splash,
        name: AppRoutes.splashName,
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: AppRoutes.onboarding,
        name: AppRoutes.onboardingName,
        builder: (context, state) => const OnboardingPage(),
      ),
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      // Orientation ================================
      GoRoute(
        path: AppRoutes.orientamento,
        name: AppRoutes.orientamentoName,
        builder: (context, state) => const OrientamentoPage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoScegliCorso,
        name: AppRoutes.orientamentoScegliCorsoName,
        builder: (context, state) => const ScegliCorsoPage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoQuiz,
        name: AppRoutes.orientamentoQuizName,
        builder: (context, state) => const QuizAutovalutazionePage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoComeFunziona,
        name: AppRoutes.orientamentoComeFunzionaName,
        builder: (context, state) => const ComeFunzionaUniversitaPage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoVitaUniversitaria,
        name: AppRoutes.orientamentoVitaUniversitariaName,
        builder: (context, state) => const VitaUniversitariaPage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoSbocchi,
        name: AppRoutes.orientamentoSbocchiName,
        builder: (context, state) => const SbocchiLavorativiPage(),
      ),
      GoRoute(
        path: AppRoutes.orientamentoErroriComuni,
        name: AppRoutes.orientamentoErroriComuniName,
        builder: (context, state) => const ErroriComuniPage(),
      ),

      // Pushed routes ================================
      GoRoute(
        path: AppRoutes.preferiti,
        name: AppRoutes.preferitiName,
        builder: (context, state) => const PreferitiPage(),
      ),
      GoRoute(
        path: AppRoutes.notifiche,
        name: AppRoutes.notificheName,
        builder: (context, state) => const NotifichePage(),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: AppRoutes.servicesName,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: AppRoutes.academicCareer,
        name: AppRoutes.academicCareerName,
        builder: (context, state) => const AcademicCareerPage(),
      ),
      GoRoute(
        path: AppRoutes.didatticaStudyPlan,
        name: AppRoutes.didatticaStudyPlanName,
        builder: (context, state) => const StudyPlanPage(),
      ),
      GoRoute(
        path: AppRoutes.didatticaTuitionFees,
        name: AppRoutes.didatticaTuitionFeesName,
        builder: (context, state) => const TuitionFeesPage(),
      ),
      GoRoute(
        path: AppRoutes.didatticaAdministrative,
        name: AppRoutes.didatticaAdministrativeName,
        builder: (context, state) => const AdministrativePage(),
      ),
      // App shell ================================
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return AppShell(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                name: AppRoutes.homeName,
                builder: (context, state) => const HomePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.didattica,
                name: AppRoutes.didatticaName,
                builder: (context, state) => const DidatticaPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.explore,
                name: AppRoutes.exploreName,
                builder: (context, state) => const ExplorePage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.chat,
                name: AppRoutes.chatName,
                builder: (context, state) => const ChatPage(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.aziende,
                name: AppRoutes.aziendeName,
                builder: (context, state) => const AziendePage(),
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) =>
        Scaffold(body: Center(child: Text('Page not found: ${state.error}'))),
  );
});

// Shell widget ================================
class AppShell extends StatefulWidget {
  const AppShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  static const _destinations = [
    NavigationDestination(
      icon: Icon(LucideIcons.home),
      selectedIcon: Icon(LucideIcons.home),
      label: 'Home',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.graduationCap),
      selectedIcon: Icon(LucideIcons.graduationCap),
      label: 'Didattica',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.globe2),
      selectedIcon: Icon(LucideIcons.globe2),
      label: 'Futuro',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.messageSquare),
      selectedIcon: Icon(LucideIcons.messageSquare),
      label: 'Chat',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.briefcase),
      selectedIcon: Icon(LucideIcons.briefcase),
      label: 'Partner',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppTopBar(scaffoldKey: _scaffoldKey),
      endDrawer: const AppDrawer(),
      body: widget.navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.navigationShell.currentIndex,
        onDestinationSelected: (index) {
          widget.navigationShell.goBranch(
            index,
            initialLocation: index == widget.navigationShell.currentIndex,
          );
        },
        destinations: _destinations,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../features/academic_career/presentation/pages/academic_career_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/companies/presentation/pages/companies_page.dart';
import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/chat/presentation/pages/chat_page.dart';
import '../../features/academics/presentation/pages/academics_page.dart';
import '../../features/academics/presentation/pages/recommended_exam_appeals_page.dart';
import '../../features/academics/presentation/pages/study_plan_page.dart';
import '../../features/academics/presentation/pages/tuition_fees_page.dart';
import '../../features/email/presentation/pages/email_inbox_page.dart';
import '../../features/explore/presentation/pages/explore_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../../features/notifications/presentation/pages/notifications_page.dart';
import '../../features/onboarding/presentation/pages/onboarding_page.dart';
import '../../features/timetable/presentation/pages/timetable_page.dart';
import '../../features/orientation/presentation/pages/topics/how_university_works_page.dart';
import '../../features/orientation/presentation/pages/topics/self_assessment_quiz_page.dart';
import '../../features/orientation/presentation/pages/topics/choose_course_page.dart';
import '../../features/orientation/presentation/pages/orientation_page.dart';
import '../../features/favorites/presentation/pages/favorites_page.dart';
import '../../features/profile/presentation/pages/profile_page.dart';
import '../../features/services/presentation/pages/services_page.dart';
import '../../features/splash/presentation/pages/splash_page.dart';
import '../../shared/widgets/app_drawer.dart';
import '../../shared/widgets/app_top_bar.dart';
import '../routes/app_routes.dart';
import '../theme/app_colors.dart';

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
        builder: (context, state) => const OrientationPage(),
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

      // Pushed routes ================================
      GoRoute(
        path: AppRoutes.profile,
        name: AppRoutes.profileName,
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: AppRoutes.preferiti,
        name: AppRoutes.preferitiName,
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: AppRoutes.notifiche,
        name: AppRoutes.notificheName,
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: AppRoutes.calendario,
        name: AppRoutes.calendarioName,
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: AppRoutes.orarioLezioni,
        name: AppRoutes.orarioLezioniName,
        builder: (context, state) => const TimetablePage(),
      ),
      GoRoute(
        path: AppRoutes.services,
        name: AppRoutes.servicesName,
        builder: (context, state) => const ServicesPage(),
      ),
      GoRoute(
        path: AppRoutes.emailInbox,
        name: AppRoutes.emailInboxName,
        builder: (context, state) => const EmailInboxPage(),
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
        path: AppRoutes.didatticaRecommendedAppeals,
        name: AppRoutes.didatticaRecommendedAppealsName,
        builder: (context, state) => const RecommendedExamAppealsPage(),
      ),
      GoRoute(
        path: AppRoutes.didatticaTuitionFees,
        name: AppRoutes.didatticaTuitionFeesName,
        builder: (context, state) => const TuitionFeesPage(),
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
                builder: (context, state) => const AcademicsPage(),
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
                builder: (context, state) => const CompaniesPage(),
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
      icon: Icon(
        LucideIcons.layoutDashboard,
        color: AppColors.colorPrimaryDark,
      ),
      selectedIcon: Icon(
        LucideIcons.layoutDashboard,
        color: AppColors.colorPrimaryDark,
      ),
      label: 'Dashboard',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.chartLine, color: AppColors.colorSecondaryDark),
      selectedIcon: Icon(
        LucideIcons.chartLine,
        color: AppColors.colorSecondaryDark,
      ),
      label: 'Carriera',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.globe2, color: AppColors.colorWarningDark),
      selectedIcon: Icon(LucideIcons.globe2, color: AppColors.colorWarningDark),
      label: 'Futuro',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.messagesSquare, color: AppColors.colorInfoDark),
      selectedIcon: Icon(
        LucideIcons.messagesSquare,
        color: AppColors.colorInfoDark,
      ),
      label: 'Messaggi',
    ),
    NavigationDestination(
      icon: Icon(LucideIcons.handshake, color: AppColors.colorSuccessDark),
      selectedIcon: Icon(
        LucideIcons.handshake,
        color: AppColors.colorSuccessDark,
      ),
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
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: _bottomBarColors[widget.navigationShell.currentIndex]
              .withValues(alpha: 0.14),
        ),
        child: NavigationBar(
          selectedIndex: widget.navigationShell.currentIndex,
          onDestinationSelected: (index) {
            widget.navigationShell.goBranch(
              index,
              initialLocation: index == widget.navigationShell.currentIndex,
            );
          },
          destinations: _destinations,
        ),
      ),
    );
  }
}

const _bottomBarColors = [
  AppColors.colorPrimaryDark,
  AppColors.colorSecondaryDark,
  AppColors.colorWarningDark,
  AppColors.colorInfoDark,
  AppColors.colorSuccessDark,
];

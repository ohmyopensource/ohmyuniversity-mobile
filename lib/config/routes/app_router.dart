import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/home/presentation/pages/home_page.dart';
import '../routes/app_routes.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: true, // da disabilitare in produzione
    routes: [
      // ── Auth ──────────────────────────────────────────
      GoRoute(
        path: AppRoutes.login,
        name: AppRoutes.loginName,
        builder: (context, state) => const LoginPage(),
      ),

      // ── App shell (con bottom navigation) ─────────────
      ShellRoute(
        builder: (context, state, child) {
          return AppShell(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.home,
            name: AppRoutes.homeName,
            builder: (context, state) => const HomePage(),
          ),
        ],
      ),
    ],

    // Redirect globale — da implementare quando avremo l'auth state
    // redirect: (context, state) {
    //   final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
    //   if (!isAuthenticated && state.matchedLocation != AppRoutes.login) {
    //     return AppRoutes.login;
    //   }
    //   return null;
    // },

    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Pagina non trovata: ${state.error}'),
      ),
    ),
  );
});

// Shell widget con BottomNavigationBar — da espandere con le feature
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      // TODO: aggiungere BottomNavigationBar quando avremo più feature
    );
  }
}
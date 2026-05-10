import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../config/routes/app_routes.dart';
import '../../../auth/providers/auth_provider.dart';
import '../../../onboarding/providers/onboarding_provider.dart';


class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeIn;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeIn = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    _navigate();
  }

  Future<void> _navigate() async {
    // Minimum splash display time
    await Future.delayed(const Duration(milliseconds: 2000));
    if (!mounted) return;

    final hasSeenOnboarding = ref.read(onboardingCompletedProvider);
    final isAuthenticated = ref.read(isAuthenticatedProvider);

    if (!hasSeenOnboarding) {
      context.goNamed(AppRoutes.onboardingName);
    } else if (isAuthenticated) {
      context.goNamed(AppRoutes.homeName);
    } else {
      context.goNamed(AppRoutes.loginName);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: FadeTransition(
        opacity: _fadeIn,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),

              // Logo placeholder
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primaryContainer,
                ),
                child: Icon(
                  Icons.school,
                  size: 56,
                  color: colorScheme.onPrimaryContainer,
                ),
              ),

              const Spacer(),

              // App name
              Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Text(
                  'OhMyUniversity!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:ohmyuniversity/config/routes/app_routes.dart';
import 'package:ohmyuniversity/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:flutter/material.dart';

void main() {
  testWidgets('onboarding page renders slides and skip action', (tester) async {
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(path: '/', builder: (context, state) => const OnboardingPage()),
        GoRoute(
          path: '/login',
          name: AppRoutes.loginName,
          builder: (context, state) => const Scaffold(body: Text('Login')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(child: MaterialApp.router(routerConfig: router)),
    );
    await tester.pumpAndSettle();

    expect(find.text('Skip'), findsOneWidget);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Login'), findsOneWidget);
  });
}

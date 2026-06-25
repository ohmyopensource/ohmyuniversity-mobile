import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/config/routes/app_routes.dart';
import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/presentation/providers/student_badge_providers.dart';
import 'package:ohmyuniversity/shared/widgets/app_top_bar.dart';

void main() {
  testWidgets('app top bar renders account and action icons', (tester) async {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final router = GoRouter(
      initialLocation: '/',
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            return Scaffold(
              key: scaffoldKey,
              appBar: AppTopBar(scaffoldKey: scaffoldKey),
              endDrawer: const Drawer(child: Text('Menu aperto')),
              body: const SizedBox.shrink(),
            );
          },
        ),
        GoRoute(
          path: '/profile',
          name: AppRoutes.profileName,
          builder: (context, state) => const Scaffold(body: Text('Profilo')),
        ),
        GoRoute(
          path: '/preferiti',
          name: AppRoutes.preferitiName,
          builder: (context, state) => const Scaffold(body: Text('Preferiti')),
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          studentBadgeProvider.overrideWith((ref) async => _badge),
          studentProfilePhotoProvider.overrideWith((ref) async => null),
        ],
        child: MaterialApp.router(routerConfig: router),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(LucideIcons.search), findsOneWidget);
    expect(find.byIcon(LucideIcons.heart), findsOneWidget);
    expect(find.byIcon(LucideIcons.menu), findsOneWidget);

    await tester.tap(find.byIcon(LucideIcons.menu));
    await tester.pumpAndSettle();

    expect(find.text('Menu aperto'), findsOneWidget);
  });
}

const _badge = StudentBadgeEntity(
  badgeId: 1,
  studentNumber: '123456',
  firstName: 'Alessio',
  lastName: 'Del Muto',
  taxCode: 'DLM',
  courseCode: 'INF',
  courseName: 'Informatica',
  facultyCode: 'DIB',
  facultyName: 'Bioscienze e territorio',
  enrollmentYear: 2025,
  rfid: 'RFID',
  universityName: 'Universita degli Studi del Molise',
  statusCode: 'A',
  validFrom: null,
  validUntil: null,
  frontImagePresent: true,
  photoUrl: '',
  rearImagePresent: false,
);

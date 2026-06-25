import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/home/presentation/widgets/dashboard/home_academic_info_card.dart';
import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/presentation/providers/student_badge_providers.dart';

void main() {
  testWidgets('home academic info card renders badge values and handles taps', (
    tester,
  ) async {
    var tapped = false;

    await tester.pumpWidget(
      ProviderScope(
        overrides: [studentBadgeProvider.overrideWith((ref) async => _badge)],
        child: MaterialApp(
          home: Scaffold(
            body: HomeAcademicInfoCard(onTap: () => tapped = true),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Universita degli Studi del Molise'), findsOneWidget);
    expect(find.text('Informatica'), findsOneWidget);
    expect(find.text('Bioscienze e territorio'), findsOneWidget);
    expect(find.text('A.A. 2025/2026'), findsOneWidget);

    await tester.tap(find.byType(HomeAcademicInfoCard));

    expect(tapped, isTrue);
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

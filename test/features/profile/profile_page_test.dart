import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:ohmyuniversity/features/profile/domain/entities/student_badge_entity.dart';
import 'package:ohmyuniversity/features/profile/presentation/pages/profile_page.dart';
import 'package:ohmyuniversity/features/profile/presentation/providers/student_badge_providers.dart';

void main() {
  testWidgets('shows real badge data on a narrow screen', (tester) async {
    tester.view.physicalSize = const Size(320, 760);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const badge = StudentBadgeEntity(
      badgeId: 42,
      studentNumber: '123456',
      firstName: 'Alessio',
      lastName: 'Del Muto',
      taxCode: 'DLM...',
      courseCode: 'INF',
      courseName: 'Informatica',
      facultyCode: 'DIB',
      facultyName: 'Bioscienze e territorio',
      enrollmentYear: 2025,
      rfid: 'RFID-001',
      universityName: 'Università degli Studi del Molise',
      statusCode: 'A',
      validFrom: null,
      validUntil: null,
      frontImagePresent: true,
      rearImagePresent: false,
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [studentBadgeProvider.overrideWith((ref) async => badge)],
        child: const MaterialApp(home: ProfilePage()),
      ),
    );
    await tester.pump();

    expect(find.text('Alessio Del Muto'), findsOneWidget);
    expect(find.text('123456'), findsOneWidget);
    expect(find.text('Informatica'), findsNWidgets(2));
    expect(find.text('RFID-001'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

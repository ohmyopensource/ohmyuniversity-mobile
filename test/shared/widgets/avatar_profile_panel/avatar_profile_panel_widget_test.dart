import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/avatar_profile_panel/avatar_profile_panel_widget.dart';

void main() {
  testWidgets('avatar profile panel opens account actions and callbacks', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 1000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    AccountEntry? switchedAccount;
    var openedProfile = false;
    var openedSettings = false;
    var loggedOut = false;
    var addedAccount = false;
    var closed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: AvatarProfilePanelWidget(
              accounts: _accounts,
              showAddAccount: true,
              animation: PanelAnimation.fade,
              panelWidth: 420,
              onProfileClick: () => openedProfile = true,
              onAccountSwitch: (account) => switchedAccount = account,
              onSettingsClick: () => openedSettings = true,
              onLogoutClick: () => loggedOut = true,
              onAddAccount: () => addedAccount = true,
              onPanelClose: () => closed = true,
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byType(AvatarProfilePanelWidget));
    await tester.pumpAndSettle();

    expect(find.text('Ada Lovelace'), findsOneWidget);
    expect(find.text('Grace Hopper'), findsOneWidget);
    expect(find.text('Aggiungi account'), findsOneWidget);
    expect(find.text('Impostazioni profilo'), findsOneWidget);
    expect(find.text('Esci'), findsOneWidget);

    await tester.tap(find.text('Grace Hopper'));
    await tester.pumpAndSettle();
    expect(switchedAccount?.id, 'secondary');
    expect(closed, isTrue);

    await tester.tap(find.byType(AvatarProfilePanelWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Ada Lovelace'));
    await tester.pumpAndSettle();
    expect(openedProfile, isTrue);

    await tester.tap(find.byType(AvatarProfilePanelWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Impostazioni profilo'));
    await tester.pumpAndSettle();
    expect(openedSettings, isTrue);

    await tester.tap(find.byType(AvatarProfilePanelWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Aggiungi account'));
    await tester.pumpAndSettle();
    expect(addedAccount, isTrue);

    await tester.tap(find.byType(AvatarProfilePanelWidget));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Esci'));
    await tester.pumpAndSettle();
    expect(loggedOut, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('avatar profile panel hides itself when accounts are empty', (
    tester,
  ) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: AvatarProfilePanelWidget(accounts: []),
        ),
      ),
    );

    expect(find.byType(SizedBox), findsWidgets);
    expect(tester.takeException(), isNull);
  });
}

const _accounts = [
  AccountEntry(
    id: 'current',
    name: 'Ada Lovelace',
    courseLabel: 'Informatica',
    email: 'ada@example.com',
    universityLabel: 'Universita del Molise',
    courseAcronym: 'L',
    status: AccountStatus.active,
    isCurrent: true,
  ),
  AccountEntry(
    id: 'secondary',
    name: 'Grace Hopper',
    courseLabel: 'Data Science',
    email: 'grace@example.com',
    universityLabel: 'Universita del Molise',
    courseAcronym: 'LM',
    status: AccountStatus.graduated,
  ),
];

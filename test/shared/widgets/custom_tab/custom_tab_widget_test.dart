import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:ohmyuniversity/shared/widgets/custom_tab/custom_tab_widget.dart';

void main() {
  testWidgets('custom tabs render styles and ignore disabled items', (
    tester,
  ) async {
    final selected = <String>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SingleChildScrollView(
            child: Column(
              children: [
                CustomTabWidget(
                  tabs: _tabs,
                  activeTab: 'home',
                  tabStyle: TabStyle.pill,
                  fullWidth: true,
                  onTabChange: selected.add,
                ),
                CustomTabWidget(
                  tabs: _tabs,
                  activeTab: 'profile',
                  tabStyle: TabStyle.card,
                  variant: TabVariant.success,
                  darkTheme: true,
                  onTabChange: selected.add,
                ),
                CustomTabWidget(
                  tabs: _tabs,
                  activeTab: 'home',
                  tabStyle: TabStyle.line,
                  variant: TabVariant.warning,
                  size: TabSize.lg,
                  onTabChange: selected.add,
                ),
                CustomTabWidget(
                  tabs: _tabs,
                  activeTab: 'profile',
                  tabStyle: TabStyle.underline,
                  variant: TabVariant.info,
                  size: TabSize.sm,
                  onTabChange: selected.add,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Home'), findsNWidgets(4));
    expect(find.text('Profilo'), findsNWidgets(4));
    expect(find.text('2'), findsNWidgets(4));

    await tester.tap(find.text('Profilo').first);
    await tester.tap(find.text('Bloccato').first);
    await tester.pump();

    expect(selected, ['profile']);
    expect(tester.takeException(), isNull);
  });
}

const _tabs = [
  TabItem(id: 'home', label: 'Home', icon: LucideIcons.house),
  TabItem(id: 'profile', label: 'Profilo', badge: 2),
  TabItem(id: 'locked', label: 'Bloccato', disabled: true),
];

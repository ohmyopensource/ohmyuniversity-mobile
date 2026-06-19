import 'package:flutter/material.dart';

import '../../../../config/theme/app_colors.dart';
import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';
import '../views/appeals_overview_view.dart';
import '../views/career_overview_view.dart';
import '../views/questionnaires_view.dart';

enum DidatticaSection { overview, appeals, questionnaires }

class DidatticaPage extends StatefulWidget {
  const DidatticaPage({super.key});

  @override
  State<DidatticaPage> createState() => _DidatticaPageState();
}

class _DidatticaPageState extends State<DidatticaPage> {
  DidatticaSection _activeSection = DidatticaSection.overview;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 2),
              child: CustomTabWidget(
                key: const Key('didattica-section-tabs'),
                tabs: const [
                  TabItem(id: 'overview', label: 'Panoramica'),
                  TabItem(id: 'appeals', label: 'Appelli'),
                  TabItem(id: 'questionnaires', label: 'Questionari'),
                ],
                activeTab: _activeSection.name,
                tabStyle: TabStyle.pill,
                variant: TabVariant.primary,
                size: TabSize.sm,
                fullWidth: true,
                onTabChange: (id) {
                  setState(() {
                    _activeSection = DidatticaSection.values.byName(id);
                  });
                },
              ),
            ),
            Expanded(
              child: IndexedStack(
                key: const Key('didattica-section-stack'),
                index: _activeSection.index,
                children: const [
                  CareerOverviewView(),
                  AppealsOverviewView(),
                  QuestionnairesView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

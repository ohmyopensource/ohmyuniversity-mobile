import 'package:flutter/material.dart';

import '../../../../shared/widgets/custom_tab/custom_tab_widget.dart';

class TimetableSemesterSwitch extends StatelessWidget {
  const TimetableSemesterSwitch({
    super.key,
    required this.selectedSemester,
    required this.onChanged,
  });

  final int selectedSemester;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return CustomTabWidget(
      tabs: const [
        TabItem(id: '1', label: 'Primo semestre'),
        TabItem(id: '2', label: 'Secondo semestre'),
      ],
      activeTab: selectedSemester.toString(),
      tabStyle: TabStyle.pill,
      variant: TabVariant.primary,
      size: TabSize.sm,
      fullWidth: true,
      onTabChange: (id) => onChanged(int.parse(id)),
    );
  }
}

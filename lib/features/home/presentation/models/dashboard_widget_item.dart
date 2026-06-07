import 'dashboard_widget_option.dart';

class DashboardWidgetItem {
  const DashboardWidgetItem({
    required this.id,
    required this.option,
    required this.column,
    required this.row,
    this.columnSpan = 2,
    this.rowSpan = 1,
  });

  final String id;
  final DashboardWidgetOption option;
  final int column;
  final int row;
  final int columnSpan;
  final int rowSpan;

  DashboardWidgetItem copyWith({
    int? column,
    int? row,
    int? columnSpan,
    int? rowSpan,
  }) {
    return DashboardWidgetItem(
      id: id,
      option: option,
      column: column ?? this.column,
      row: row ?? this.row,
      columnSpan: columnSpan ?? this.columnSpan,
      rowSpan: rowSpan ?? this.rowSpan,
    );
  }
}

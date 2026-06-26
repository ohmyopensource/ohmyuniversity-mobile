import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/features/home/presentation/models/dashboard_widget_item.dart';
import 'package:ohmyuniversity/features/home/presentation/models/dashboard_widget_option.dart';

void main() {
  test(
    'dashboard widget item copyWith preserves identity and updates layout',
    () {
      const item = DashboardWidgetItem(
        id: 'item-1',
        option: DashboardWidgetOptions.calendarAgenda,
        column: 0,
        row: 1,
      );

      final moved = item.copyWith(column: 2, row: 3, columnSpan: 4, rowSpan: 5);

      expect(moved.id, item.id);
      expect(moved.option, same(item.option));
      expect(moved.column, 2);
      expect(moved.row, 3);
      expect(moved.columnSpan, 4);
      expect(moved.rowSpan, 5);
    },
  );
}

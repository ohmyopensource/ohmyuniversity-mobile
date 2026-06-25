import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/custom_pagination/custom_pagination_widget.dart';

void main() {
  testWidgets('renders numeric controls and emits page changes', (
    tester,
  ) async {
    final selectedPages = <int>[];
    final selectedSizes = <int>[];

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            child: CustomPaginationWidget(
              totalItems: 243,
              pageSize: 25,
              currentPage: 5,
              showJumpToPage: true,
              onPageChange: selectedPages.add,
              onPageSizeChange: selectedSizes.add,
            ),
          ),
        ),
      ),
    );

    expect(find.text('5'), findsOneWidget);
    expect(find.text('Rows'), findsOneWidget);
    expect(find.text('Go to'), findsOneWidget);

    await tester.tap(find.byTooltip('Next page'));
    await tester.pump();
    expect(selectedPages, contains(6));

    await tester.enterText(find.byType(TextField), '9');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pump();
    expect(selectedPages, contains(9));

    await tester.tap(find.text('25'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('50').last);
    await tester.pumpAndSettle();
    expect(selectedSizes, contains(50));
    expect(selectedPages, contains(1));
    expect(tester.takeException(), isNull);
  });

  testWidgets('renders compact and disabled pagination variants', (
    tester,
  ) async {
    var changed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Column(
            children: [
              CustomPaginationWidget(
                totalItems: 40,
                pageSize: 10,
                currentPage: 2,
                style: PaginationStyle.dots,
                size: PaginationSize.sm,
                onPageChange: (_) => changed = true,
              ),
              CustomPaginationWidget(
                totalItems: 0,
                pageSize: 10,
                currentPage: 1,
                disabled: true,
                showPageSizeSelector: false,
                showFirstLast: false,
                emphasis: PaginationEmphasis.minimal,
                variant: PaginationVariant.warning,
                onPageChange: (_) => changed = true,
              ),
            ],
          ),
        ),
      ),
    );

    await tester.tap(find.byTooltip('Next page'));
    await tester.pump();

    expect(changed, isFalse);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ohmyuniversity/shared/widgets/custom_filter/custom_filter_widget.dart';

void main() {
  testWidgets('custom filter emits search and reset states', (tester) async {
    FilterState? changedState;
    FilterState? resetState;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 420,
            child: CustomFilterWidget(
              searchPlaceholder: 'Cerca esami',
              searchLabel: 'Filtra',
              resetLabel: 'Pulisci',
              initialState: const FilterState(
                search: 'analisi',
                selects: {'year': 2},
                chips: {
                  'status': <Object>['open'],
                },
              ),
              selects: const [
                FilterSelectConfig(
                  key: 'year',
                  label: 'Anno',
                  placeholder: 'Tutti',
                  options: [
                    FilterSelectOption(label: 'Primo', value: 1),
                    FilterSelectOption(label: 'Secondo', value: 2),
                  ],
                ),
              ],
              chips: const [
                FilterChipConfig(
                  key: 'status',
                  label: 'Stato',
                  multiple: true,
                  options: [
                    FilterSelectOption(label: 'Aperti', value: 'open'),
                    FilterSelectOption(label: 'Chiusi', value: 'closed'),
                  ],
                ),
              ],
              onFilterChange: (state) => changedState = state,
              onFilterReset: (state) => resetState = state,
            ),
          ),
        ),
      ),
    );

    expect(find.text('ANNO'), findsOneWidget);
    expect(find.text('STATO'), findsOneWidget);
    expect(find.text('Aperti'), findsOneWidget);
    expect(find.text('Pulisci'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'fisica');
    await tester.tap(find.text('Chiusi'));
    await tester.tap(find.text('Filtra'));
    await tester.pump();

    expect(changedState?.search, 'fisica');
    expect(changedState?.selects['year'], 2);
    expect(changedState?.chips['status'], containsAll(['open', 'closed']));

    await tester.tap(find.text('Pulisci'));
    await tester.pump();

    expect(resetState?.search, isEmpty);
    expect(resetState?.selects['year'], isNull);
    expect(resetState?.chips['status'], isEmpty);
    expect(changedState?.chips['status'], isEmpty);
    expect(tester.takeException(), isNull);
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/catalog_component_page.dart';
import 'package:flutter_flux_motion_example/catalog/catalog_entry.dart';
import 'package:flutter_flux_motion_example/catalog/catalog_theme.dart';
import 'package:flutter_flux_motion_example/catalog/sequence_catalog.dart';
import 'package:flutter_flux_motion_example/catalog/stagger_catalog.dart';

const _mobileWidths = <double>[320, 360, 390];
const _mobileHeight = 844.0;

const _catalogExpectations = <_CatalogExpectation>[
  _CatalogExpectation(
    entry: staggerCatalog,
    implementationType: 'FluxStagger',
    interactiveExample: 'Reverse checklist',
    exampleTitles: <String>[
      'Feed arrival',
      'Reverse checklist',
      'Quick actions',
    ],
    parameterNames: <String>[
      'interval',
      'itemDuration',
      'beginOffset',
      'order',
      'layoutBuilder',
    ],
    scenarioTitles: <String>[
      'Feed refresh',
      'Settings group',
      'Context actions',
      'Form validation',
    ],
  ),
  _CatalogExpectation(
    entry: sequenceCatalog,
    implementationType: 'FluxSequence',
    interactiveExample: 'Success confirmation',
    interactionKey: ValueKey<String>('sequence-confirmation-preview'),
    exampleTitles: <String>[
      'Screen entrance choreography',
      'Success confirmation',
      'Error to recovery',
      'Controller transport',
    ],
    parameterNames: <String>[
      'MotionSequenceStep.effect',
      'MotionSequenceStep.delay',
      'steps',
      'SequenceSpec.totalDuration',
      'engineFactory',
    ],
    scenarioTitles: <String>[
      'Screen entrance',
      'Success feedback',
      'Error and recovery',
      'Async status',
    ],
  ),
];

void main() {
  for (final expectation in _catalogExpectations) {
    for (final width in _mobileWidths) {
      testWidgets(
        '${expectation.entry.name} catalog is responsive at ${width.toInt()}px',
        (tester) async {
          final exceptions = <Object>[];

          await _pumpCatalog(
            tester,
            entry: expectation.entry,
            width: width,
          );

          _expectCompleteDocumentation(expectation);
          _collectFlutterExceptions(tester, exceptions);
          _expectNoFlutterExceptions(
            exceptions,
            '${expectation.entry.name} initial render at ${width.toInt()}px',
          );

          await _replayExamples(tester, expectation.entry);
          _collectFlutterExceptions(tester, exceptions);
          _expectNoFlutterExceptions(
            exceptions,
            '${expectation.entry.name} replay at ${width.toInt()}px',
          );

          await _activateTapExample(tester, expectation);
          _collectFlutterExceptions(tester, exceptions);
          _expectNoFlutterExceptions(
            exceptions,
            '${expectation.entry.name} tap example at ${width.toInt()}px',
          );

          await _scrollThroughFullPage(
            tester,
            expectation.entry,
            exceptions,
          );
          _collectFlutterExceptions(tester, exceptions);
          _expectNoFlutterExceptions(
            exceptions,
            '${expectation.entry.name} full scroll at ${width.toInt()}px',
          );

          expect(find.byType(ErrorWidget), findsNothing);
          expect(
            find
                .text(
                  'FLUX MOTION / COMPONENT DOCUMENTATION / '
                  'MOBILE-FIRST MOTION',
                )
                .hitTestable(),
            findsOneWidget,
          );
        },
      );
    }
  }
}

Future<void> _pumpCatalog(
  WidgetTester tester, {
  required MotionCatalogEntry entry,
  required double width,
}) async {
  tester.view.devicePixelRatio = 1;
  tester.view.physicalSize = Size(width, _mobileHeight);
  addTearDown(tester.view.resetDevicePixelRatio);
  addTearDown(tester.view.resetPhysicalSize);

  await tester.pumpWidget(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildCatalogTheme(),
      home: Scaffold(
        body: CatalogComponentPage(entry: entry),
      ),
    ),
  );
  await tester.pump(const Duration(milliseconds: 120));
}

void _expectCompleteDocumentation(_CatalogExpectation expectation) {
  final entry = expectation.entry;

  expect(entry.examples, hasLength(greaterThanOrEqualTo(3)));
  expect(entry.parameters, hasLength(greaterThanOrEqualTo(5)));
  expect(entry.scenarios, hasLength(greaterThanOrEqualTo(4)));
  expect(entry.code, contains(expectation.implementationType));
  expect(entry.code, contains('controller'));

  expect(find.text(entry.name), findsOneWidget);
  expect(find.text('Usage examples'), findsOneWidget);
  expect(find.text('Parameters'), findsOneWidget);
  expect(find.text('Scenarios'), findsOneWidget);
  expect(find.text('Implementation'), findsOneWidget);

  for (final title in expectation.exampleTitles) {
    expect(find.text(title), findsOneWidget, reason: 'Missing example: $title');
  }
  for (final name in expectation.parameterNames) {
    expect(find.text(name), findsOneWidget, reason: 'Missing parameter: $name');
  }
  for (final title in expectation.scenarioTitles) {
    expect(find.text(title), findsOneWidget,
        reason: 'Missing scenario: $title');
  }

  expect(find.text(entry.code), findsOneWidget);
}

Future<void> _replayExamples(
  WidgetTester tester,
  MotionCatalogEntry entry,
) async {
  expect(
    find.byKey(ValueKey<String>('${entry.id}-examples-0')),
    findsOneWidget,
  );

  final replayButton = find.text('Replay examples');
  await tester.scrollUntilVisible(
    replayButton,
    180,
    scrollable: _outerScrollable(entry),
  );
  await tester.tap(replayButton);
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 80));

  expect(
    find.byKey(ValueKey<String>('${entry.id}-examples-1')),
    findsOneWidget,
  );
}

Future<void> _activateTapExample(
  WidgetTester tester,
  _CatalogExpectation expectation,
) async {
  final scrollable = _outerScrollable(expectation.entry);
  final title = find.text(expectation.interactiveExample);
  final examples = find.byKey(
    ValueKey<String>('${expectation.entry.id}-examples-1'),
  );
  final interactionRoot = expectation.interactionKey == null
      ? examples
      : find.byKey(expectation.interactionKey!);
  final onTapMotion = find.descendant(
    of: interactionRoot,
    matching: find.byWidgetPredicate(
      (widget) => widget is GestureDetector && widget.onTap != null,
      description: 'onTap orchestration preview',
    ),
  );

  expect(title, findsOneWidget);
  expect(onTapMotion, findsOneWidget);
  await tester.scrollUntilVisible(onTapMotion, 180, scrollable: scrollable);
  await tester.pump(const Duration(milliseconds: 40));

  expect(onTapMotion.hitTestable(), findsOneWidget);
  await tester.tap(onTapMotion.hitTestable());
  await tester.pump(const Duration(milliseconds: 120));
}

Future<void> _scrollThroughFullPage(
  WidgetTester tester,
  MotionCatalogEntry entry,
  List<Object> exceptions,
) async {
  final scrollable = _outerScrollable(entry);
  final state = tester.state<ScrollableState>(scrollable);

  state.position.jumpTo(0);
  await tester.pump();
  _collectFlutterExceptions(tester, exceptions);

  var gestures = 0;
  while (state.position.pixels < state.position.maxScrollExtent - 1) {
    await tester.drag(scrollable, const Offset(0, -280));
    await tester.pump(const Duration(milliseconds: 50));
    _collectFlutterExceptions(tester, exceptions);

    gestures++;
    expect(gestures, lessThan(100), reason: 'Page did not reach its footer.');
  }

  expect(gestures, greaterThan(1));
  expect(
    state.position.pixels,
    closeTo(state.position.maxScrollExtent, 1),
  );
}

Finder _outerScrollable(MotionCatalogEntry entry) {
  final page = find.byKey(
    PageStorageKey<String>('catalog-${entry.id}'),
  );
  expect(page, findsOneWidget);

  return find
      .descendant(
        of: page,
        matching: find.byType(Scrollable),
      )
      .first;
}

void _collectFlutterExceptions(
  WidgetTester tester,
  List<Object> exceptions,
) {
  while (true) {
    final exception = tester.takeException();
    if (exception == null) {
      break;
    }
    final stackTrace = exception is Error ? exception.stackTrace : null;
    exceptions.add(
      stackTrace == null
          ? exception
          : '$exception\nOriginal stack:\n$stackTrace',
    );
  }
}

void _expectNoFlutterExceptions(List<Object> exceptions, String stage) {
  expect(
    exceptions,
    isEmpty,
    reason: '$stage produced Flutter/rendering exceptions:\n'
        '${exceptions.join('\n\n')}',
  );
}

class _CatalogExpectation {
  const _CatalogExpectation({
    required this.entry,
    required this.implementationType,
    required this.interactiveExample,
    required this.exampleTitles,
    required this.parameterNames,
    required this.scenarioTitles,
    this.interactionKey,
  });

  final MotionCatalogEntry entry;
  final String implementationType;
  final String interactiveExample;
  final List<String> exampleTitles;
  final List<String> parameterNames;
  final List<String> scenarioTitles;
  final Key? interactionKey;
}

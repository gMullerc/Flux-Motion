import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/bottom_sheet_catalog.dart';
import 'package:flutter_flux_motion_example/catalog/catalog_entry.dart';
import 'package:flutter_flux_motion_example/catalog/dialog_catalog.dart';
import 'package:flutter_flux_motion_example/catalog/page_route_catalog.dart';
import 'package:flutter_flux_motion_example/main.dart';

const _mobileHeight = 844.0;

const _expectations = <_NavigationExpectation>[
  _NavigationExpectation(
    entry: pageRouteCatalog,
    openKey: ValueKey('page-route-open-slide'),
    closeKey: ValueKey('page-route-close'),
    presetKeys: [
      ValueKey('page-route-open-slide'),
      ValueKey('page-route-open-fade'),
      ValueKey('page-route-open-scale'),
      ValueKey('page-route-open-fade-through'),
      ValueKey('page-route-open-shared-axis'),
    ],
    parameters: [
      'builder',
      'spec',
      'settings',
      'maintainState',
      'fullscreenDialog',
      'allowSnapshotting',
      'duration / reverseDuration',
      'direction / axis / reverse',
      'distance / scaleFrom',
      'curve / reverseCurve',
    ],
  ),
  _NavigationExpectation(
    entry: dialogCatalog,
    openKey: ValueKey('dialog-open-fade-scale'),
    closeKey: ValueKey('dialog-close'),
    presetKeys: [
      ValueKey('dialog-open-fade-scale'),
      ValueKey('dialog-open-fade'),
      ValueKey('dialog-open-slide-up'),
    ],
    parameters: [
      'context',
      'builder',
      'spec',
      'barrierDismissible',
      'barrierLabel',
      'barrierColor',
      'useRootNavigator / useSafeArea',
      'routeSettings / anchorPoint',
      'duration / reverseDuration',
      'curve / reverseCurve',
      'scaleFrom / slideFrom / alignment',
    ],
  ),
  _NavigationExpectation(
    entry: bottomSheetCatalog,
    openKey: ValueKey('bottom-sheet-open-standard'),
    closeKey: ValueKey('bottom-sheet-close'),
    presetKeys: [
      ValueKey('bottom-sheet-open-standard'),
      ValueKey('bottom-sheet-open-quick'),
      ValueKey('bottom-sheet-open-gentle'),
    ],
    parameters: [
      'context',
      'builder',
      'spec',
      'isScrollControlled',
      'isDismissible / enableDrag',
      'showDragHandle / useSafeArea',
      'backgroundColor / shape / elevation',
      'barrierLabel / barrierColor',
      'clipBehavior / constraints',
      'useRootNavigator',
      'routeSettings / anchorPoint',
      'duration / reverseDuration',
    ],
  ),
];

void main() {
  test('navigation entries document every public contract layer', () {
    for (final expectation in _expectations) {
      final entry = expectation.entry;

      expect(entry.activation, isNotNull, reason: entry.name);
      expect(entry.compositionBuilder, isNull, reason: entry.name);
      expect(entry.documentationSections, hasLength(2), reason: entry.name);
      expect(
        entry.documentationSections.map((section) => section.title),
        containsAll(<String>[
          if (entry == pageRouteCatalog) 'Typed navigation results',
          if (entry == dialogCatalog) 'Confirmation and cancellation',
          if (entry == bottomSheetCatalog) 'Selections and dismissals',
          if (entry == pageRouteCatalog) 'Motion without losing navigation',
          if (entry == dialogCatalog) 'A modal that explains itself',
          if (entry == bottomSheetCatalog) 'More than a drag gesture',
        ]),
        reason: entry.name,
      );
      expect(
        entry.examples.every((example) => example.previewBuilder != null),
        isTrue,
        reason: '${entry.name} must use real navigation previews.',
      );
      expect(
        entry.parameters.map((parameter) => parameter.name),
        containsAll(expectation.parameters),
        reason: entry.name,
      );
      expect(entry.code, isNot(contains('requestFocus')), reason: entry.name);
    }
  });

  for (final width in <double>[320, 390]) {
    testWidgets(
      'navigation catalog opens and closes real routes at ${width.toInt()}px',
      (tester) async {
        final exceptions = <Object>[];

        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, _mobileHeight);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const FluxMotionPreviewApp());
        await tester.pump(const Duration(milliseconds: 400));
        _collectExceptions(tester, exceptions);

        for (final expectation in _expectations) {
          await _selectFromDrawer(tester, expectation.entry);
          _collectExceptions(tester, exceptions);
          _expectNoExceptions(
            exceptions,
            '${expectation.entry.name} drawer selection at ${width.toInt()}px',
          );

          expect(find.text(expectation.entry.name), findsWidgets);
          expect(find.text('Usage examples'), findsOneWidget);
          expect(
              find.text(expectation.entry.activation!.title), findsOneWidget);
          expect(find.text('Scenarios'), findsOneWidget);

          for (final key in expectation.presetKeys) {
            expect(find.byKey(key), findsOneWidget);
          }

          await _openAndClosePreview(tester, expectation);
          _collectExceptions(tester, exceptions);
          _expectNoExceptions(
            exceptions,
            '${expectation.entry.name} interaction at ${width.toInt()}px',
          );

          await _scrollThroughPage(tester, expectation.entry, exceptions);
          _collectExceptions(tester, exceptions);
          _expectNoExceptions(
            exceptions,
            '${expectation.entry.name} full page at ${width.toInt()}px',
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
        }
      },
    );
  }
}

Future<void> _selectFromDrawer(
  WidgetTester tester,
  MotionCatalogEntry entry,
) async {
  final scaffold = find.byWidgetPredicate(
    (widget) => widget is Scaffold && widget.drawer != null,
    description: 'catalog scaffold',
  );
  tester.state<ScaffoldState>(scaffold).openDrawer();
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 300));

  final drawerScrollable = find.descendant(
    of: find.byType(Drawer),
    matching: find.byType(Scrollable),
  );
  final item = find.byKey(ValueKey('catalog-${entry.id}'));

  final drawerState = tester.state<ScrollableState>(drawerScrollable);
  drawerState.position.jumpTo(drawerState.position.maxScrollExtent);
  await tester.pump();
  final tappable = find.descendant(of: item, matching: find.byType(InkWell));
  expect(tappable.hitTestable(), findsOneWidget);
  await tester.tap(tappable.hitTestable());
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 400));
}

Future<void> _openAndClosePreview(
  WidgetTester tester,
  _NavigationExpectation expectation,
) async {
  final pageScrollable = _pageScrollable(expectation.entry);
  final open = find.byKey(expectation.openKey);

  await tester.scrollUntilVisible(
    open,
    180,
    scrollable: pageScrollable,
  );
  await tester.pump(const Duration(milliseconds: 40));
  expect(open.hitTestable(), findsOneWidget);

  await tester.tap(open.hitTestable());
  await tester.pumpAndSettle();

  final close = find.byKey(expectation.closeKey);
  expect(close.hitTestable(), findsOneWidget);
  await tester.tap(close.hitTestable());
  await tester.pumpAndSettle();

  expect(find.byKey(expectation.closeKey), findsNothing);
  expect(find.byKey(expectation.openKey), findsOneWidget);
}

Future<void> _scrollThroughPage(
  WidgetTester tester,
  MotionCatalogEntry entry,
  List<Object> exceptions,
) async {
  final scrollable = _pageScrollable(entry);
  final state = tester.state<ScrollableState>(scrollable);
  var gestures = 0;

  while (state.position.pixels < state.position.maxScrollExtent - 1) {
    await tester.drag(scrollable, const Offset(0, -300));
    await tester.pump(const Duration(milliseconds: 40));
    _collectExceptions(tester, exceptions);

    gestures++;
    expect(gestures, lessThan(120), reason: '${entry.name} did not end.');
  }

  expect(gestures, greaterThan(0));
}

Finder _pageScrollable(MotionCatalogEntry entry) {
  final page = find.byKey(PageStorageKey<String>('catalog-${entry.id}'));
  expect(page, findsOneWidget);
  return find.descendant(of: page, matching: find.byType(Scrollable)).first;
}

void _collectExceptions(WidgetTester tester, List<Object> exceptions) {
  while (true) {
    final exception = tester.takeException();
    if (exception == null) {
      return;
    }
    exceptions.add(exception);
  }
}

void _expectNoExceptions(List<Object> exceptions, String stage) {
  expect(
    exceptions,
    isEmpty,
    reason: '$stage produced Flutter/rendering exceptions:\n'
        '${exceptions.join('\n\n')}',
  );
}

class _NavigationExpectation {
  const _NavigationExpectation({
    required this.entry,
    required this.openKey,
    required this.closeKey,
    required this.presetKeys,
    required this.parameters,
  });

  final MotionCatalogEntry entry;
  final Key openKey;
  final Key closeKey;
  final List<Key> presetKeys;
  final List<String> parameters;
}

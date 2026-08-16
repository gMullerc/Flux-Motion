import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/catalog_registry.dart';
import 'package:flutter_flux_motion_example/main.dart';

void main() {
  for (final width in <double>[320, 390, 1200]) {
    testWidgets(
      'landing is complete and overflow-free at ${width.toInt()}px',
      (tester) async {
        final exceptions = <Object>[];

        tester.view.devicePixelRatio = 1;
        tester.view.physicalSize = Size(width, 900);
        addTearDown(tester.view.resetDevicePixelRatio);
        addTearDown(tester.view.resetPhysicalSize);

        await tester.pumpWidget(const FluxMotionPreviewApp());
        await tester.pump(const Duration(milliseconds: 900));
        _collectExceptions(tester, exceptions);

        expect(
            find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
        expect(find.text('Make interfaces\nfeel inevitable.'), findsOneWidget);
        expect(find.text('Motion with a job to do.'), findsOneWidget);
        expect(find.text('15 motions. Tap to replay.'), findsOneWidget);
        expect(find.text('Describe the intent.\nFlux handles the timeline.'),
            findsOneWidget);
        expect(find.byType(ErrorWidget), findsNothing);

        for (final entry in motionCatalogs) {
          expect(
            find.byKey(ValueKey('landing-motion-${entry.id}')),
            findsOneWidget,
            reason: '${entry.name} must run inside the landing showroom.',
          );
        }

        final scrollable = _landingScrollable();
        final state = tester.state<ScrollableState>(scrollable);
        var steps = 0;
        while (state.position.pixels < state.position.maxScrollExtent - 1) {
          await tester.drag(scrollable, const Offset(0, -360));
          await tester.pump(const Duration(milliseconds: 40));
          _collectExceptions(tester, exceptions);
          steps++;
          expect(steps, lessThan(80));
        }

        expect(steps, greaterThan(1));
        expect(find.text('BUILD THE MOMENT,\nNOT THE BOILERPLATE.'),
            findsOneWidget);
        expect(exceptions, isEmpty,
            reason: 'Landing produced rendering exceptions at ${width}px:\n'
                '${exceptions.join('\n\n')}');
      },
    );
  }

  testWidgets('cards replay in place and documentation stays in the drawer',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 900);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 700));

    final glowPreview = find.byKey(const ValueKey('landing-motion-glow'));
    await tester.scrollUntilVisible(
      glowPreview,
      300,
      scrollable: _landingScrollable(),
    );
    expect(find.byKey(const ValueKey('glow-showcase-0')), findsOneWidget);
    await tester.tap(glowPreview);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
    expect(find.byKey(const ValueKey('glow-showcase-1')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-page-glow')), findsNothing);

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final drawerScrollable = find.descendant(
      of: find.byType(Drawer),
      matching: find.byType(Scrollable),
    );
    final glowDocs = find.byKey(const ValueKey('catalog-glow'));
    await tester.scrollUntilVisible(
      glowDocs,
      120,
      scrollable: drawerScrollable,
    );
    await tester.tap(glowDocs);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const ValueKey('catalog-page-glow')), findsOneWidget);
    expect(find.text('MOTION COMPONENT / LIVE'), findsOneWidget);

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    await tester.tap(find.byKey(const ValueKey('catalog-overview')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
    expect(find.text('Make interfaces\nfeel inevitable.'), findsOneWidget);
  });
}

Finder _landingScrollable() {
  final landing = find.byKey(const PageStorageKey<String>('catalog-landing'));
  expect(landing, findsOneWidget);
  return find.descendant(of: landing, matching: find.byType(Scrollable)).first;
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

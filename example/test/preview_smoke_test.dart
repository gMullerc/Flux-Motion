import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/catalog_registry.dart';
import 'package:flutter_flux_motion_example/main.dart';

void main() {
  test('every public motion has a complete catalog definition', () {
    expect(motionCatalogs, hasLength(15));
    expect(
      motionCatalogs.map((entry) => entry.id).toSet(),
      hasLength(motionCatalogs.length),
    );

    for (final entry in motionCatalogs) {
      expect(entry.examples, isNotEmpty, reason: entry.name);
      expect(entry.parameters, isNotEmpty, reason: entry.name);
      expect(entry.scenarios, isNotEmpty, reason: entry.name);
      expect(entry.code, isNotEmpty, reason: entry.name);
    }
  });

  testWidgets('landing showcases motions while docs stay in the drawer',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
    expect(find.text('Make interfaces\nfeel inevitable.'), findsOneWidget);
    expect(find.text('15'), findsOneWidget);
    expect(find.text('Motion with a job to do.'), findsOneWidget);
    expect(find.text('15 motions. Tap to replay.'), findsOneWidget);
    expect(find.textContaining('PHASE'), findsNothing);

    await tester.tap(find.byKey(const ValueKey('landing-explore-button')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));

    expect(find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-page-fade')), findsNothing);
    expect(find.text('LIVE MOTION SHOWROOM'), findsOneWidget);
    expect(
      tester.state<ScrollableState>(_landingScrollable()).position.pixels,
      greaterThan(0),
    );

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('PUBLIC COMPONENTS'), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-overview')), findsOneWidget);
    final drawerScrollable = find.descendant(
      of: find.byType(Drawer),
      matching: find.byType(Scrollable),
    );
    for (final id in [
      'fade',
      'slide',
      'scale',
      'rotate',
      'blur',
      'glow',
      'shimmer',
      'shake',
      'pulse',
      'bounce',
      'sequence',
      'stagger',
      'page-route',
      'dialog',
      'bottom-sheet',
    ]) {
      final item = find.byKey(ValueKey('catalog-$id'));
      await tester.scrollUntilVisible(
        item,
        120,
        scrollable: drawerScrollable,
      );
      expect(item, findsOneWidget);
    }

    await tester.tap(find.byKey(const ValueKey('catalog-bounce')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(
        find.text('Travel and settle with spring-like directional feedback.'),
        findsOneWidget);
    expect(find.text('MOTION COMPONENT / LIVE'), findsOneWidget);
    expect(find.text('Usage examples'), findsOneWidget);
    expect(find.text('Parameters'), findsOneWidget);
    expect(find.text('Activation'), findsOneWidget);
    expect(find.text('Scenarios'), findsOneWidget);
    expect(find.text('Implementation'), findsOneWidget);
    expect(find.text('direction'), findsOneWidget);
    expect(find.text('distance'), findsOneWidget);
  });

  testWidgets('catalog fits a mobile viewport', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.byKey(const ValueKey('catalog-landing-page')), findsOneWidget);
    expect(find.text('Make interfaces\nfeel inevitable.'), findsOneWidget);
    expect(
        find.byKey(const ValueKey('landing-explore-button')), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(find.byTooltip('Toggle reduced motion'), findsOneWidget);
  });
}

Finder _landingScrollable() {
  final landing = find.byKey(const PageStorageKey<String>('catalog-landing'));
  expect(landing, findsOneWidget);
  return find.descendant(of: landing, matching: find.byType(Scrollable)).first;
}

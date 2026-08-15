import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_flux_motion_example/catalog/catalog_registry.dart';
import 'package:flutter_flux_motion_example/main.dart';

void main() {
  test('every public motion has a complete catalog definition', () {
    expect(motionCatalogs, hasLength(7));
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

  testWidgets('catalog renders consistent component documentation',
      (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(1200, 800);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Fade'), findsOneWidget);
    expect(find.text('MOTION COMPONENT / LIVE'), findsOneWidget);
    expect(find.text('Usage examples'), findsOneWidget);
    expect(find.text('Parameters'), findsOneWidget);
    expect(find.text('Activation'), findsOneWidget);
    expect(find.text('Scenarios'), findsOneWidget);
    expect(find.text('Implementation'), findsOneWidget);
    expect(find.textContaining('PHASE'), findsNothing);

    tester.state<ScaffoldState>(find.byType(Scaffold)).openDrawer();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('MOTION COMPONENTS'), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-fade')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-slide')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-scale')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-rotate')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-blur')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-glow')), findsOneWidget);
    expect(find.byKey(const ValueKey('catalog-shimmer')), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('catalog-rotate')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(
        find.text('Turn a widget around its center while it stays in place.'),
        findsOneWidget);
    expect(find.text('beginDegrees'), findsOneWidget);
    expect(find.text('degrees'), findsOneWidget);
  });

  testWidgets('catalog fits a mobile viewport', (tester) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 120));

    expect(find.text('Fade'), findsOneWidget);
    expect(find.text('Replay examples'), findsOneWidget);
    expect(find.byTooltip('Open navigation menu'), findsOneWidget);
    expect(find.byTooltip('Toggle reduced motion'), findsOneWidget);
  });
}

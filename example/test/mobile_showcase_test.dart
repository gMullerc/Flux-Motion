import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_flux_motion_example/main.dart';

void main() {
  testWidgets('mobile showcase follows the complete favorite and route journey',
      (tester) async {
    final exceptions = <Object>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 500));
    await tester.tap(find.byKey(const ValueKey('open-mobile-showcase')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 800));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('mobile-showcase-page')), findsOneWidget);
    expect(find.text('Your Saturday,\nalready in motion.'), findsOneWidget);
    expect(find.byKey(const ValueKey('showcase-card-0')), findsOneWidget);
    expect(find.byKey(const ValueKey('showcase-card-3')), findsOneWidget);
    expect(find.text('0 SAVED'), findsOneWidget);

    await tester.tap(find.byKey(const ValueKey('showcase-favorite-0')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 220));

    expect(find.text('1 SAVED'), findsOneWidget);
    expect(
      find.byKey(const ValueKey('showcase-favorite-icon-0-true')),
      findsOneWidget,
    );

    await _scrollToEnd(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 900));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('showcase-route-sheet')), findsOneWidget);
    final glowingCta = find.byKey(const ValueKey('showcase-glowing-cta'));
    expect(glowingCta, findsOneWidget);
    expect(
      find.ancestor(of: glowingCta, matching: find.byType(FluxGlow)),
      findsOneWidget,
    );

    await tester.tap(glowingCta);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    expect(find.text('Route saved.'), findsOneWidget);
    expect(
        find.text('A little motion, right when it matters.'), findsOneWidget);
    expect(exceptions, isEmpty, reason: exceptions.join('\n\n'));
  });

  testWidgets('mobile showcase remains overflow-free at 320px', (tester) async {
    final exceptions = <Object>[];
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(320, 720);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);

    await tester.pumpWidget(const FluxMotionPreviewApp());
    await tester.pump(const Duration(milliseconds: 400));
    await tester.tap(find.byKey(const ValueKey('open-mobile-showcase')));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    await _scrollToEnd(tester);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
    _collectExceptions(tester, exceptions);

    expect(find.byKey(const ValueKey('showcase-route-sheet')), findsOneWidget);
    expect(exceptions, isEmpty, reason: exceptions.join('\n\n'));
  });
}

Future<void> _scrollToEnd(WidgetTester tester) async {
  final scrollable = find.byKey(
    const PageStorageKey<String>('mobile-showcase-scroll'),
  );
  expect(scrollable, findsOneWidget);
  final state = tester.state<ScrollableState>(
    find.descendant(of: scrollable, matching: find.byType(Scrollable)).first,
  );

  var steps = 0;
  while (state.position.extentAfter > 1) {
    await tester.drag(scrollable, const Offset(0, -420));
    await tester.pump(const Duration(milliseconds: 60));
    steps++;
    expect(steps, lessThan(30));
  }
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

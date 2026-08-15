import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const staggerKey = ValueKey<String>('stagger-motion');
  const tolerance = .01;

  ValueKey<String> itemKey(int index) => ValueKey<String>('stagger-$index');

  List<Widget> items([int count = 3]) {
    return List<Widget>.generate(
      count,
      (index) => Listener(
        key: itemKey(index),
        behavior: HitTestBehavior.opaque,
        child: SizedBox(
          width: 120,
          height: 48,
          child: Text('Item $index'),
        ),
      ),
    );
  }

  StaggerSpec spec({StaggerOrder order = StaggerOrder.forward}) {
    return StaggerSpec(
      interval: const Duration(milliseconds: 200),
      itemDuration: const Duration(milliseconds: 400),
      curve: Curves.linear,
      beginOffset: const Offset(0, 32),
      fadeFrom: .2,
      order: order,
    );
  }

  Finder itemOpacity(int index) {
    return find.ancestor(
      of: find.byKey(itemKey(index)),
      matching: find.byType(Opacity),
    );
  }

  Finder itemTransform(int index) {
    return find.ancestor(
      of: find.byKey(itemKey(index)),
      matching: find.byType(Transform),
    );
  }

  Finder triggerSurface() {
    return find.descendant(
      of: find.byKey(staggerKey),
      matching: find.byType(GestureDetector),
    );
  }

  double opacity(WidgetTester tester, int index) {
    return tester.widget<Opacity>(itemOpacity(index).first).opacity;
  }

  Offset translation(WidgetTester tester, int index) {
    final matrix =
        tester.widget<Transform>(itemTransform(index).first).transform;
    return Offset(matrix.storage[12], matrix.storage[13]);
  }

  bool hasLocalLayer(
    WidgetTester tester,
    int index,
    bool Function(Widget widget) matches,
  ) {
    var found = false;
    tester.element(find.byKey(itemKey(index))).visitAncestorElements((element) {
      if (element.widget is FluxStagger) {
        return false;
      }
      if (matches(element.widget)) {
        found = true;
        return false;
      }
      return true;
    });
    return found;
  }

  Widget stagger({
    FluxMotionController? controller,
    StaggerOrder order = StaggerOrder.forward,
    bool animationsDisabled = false,
    int itemCount = 3,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(disableAnimations: animationsDisabled),
          child: Center(
            child: FluxStagger(
              key: staggerKey,
              controller: controller,
              trigger: MotionTrigger.onTap,
              spec: spec(order: order),
              children: items(itemCount),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('tap reveals keyed children in deterministic forward windows',
      (tester) async {
    await tester.pumpWidget(stagger());

    for (var index = 0; index < 3; index++) {
      expect(opacity(tester, index), closeTo(.2, tolerance));
      expect(translation(tester, index).dy, closeTo(32, tolerance));
    }

    await tester.pump(const Duration(milliseconds: 300));
    for (var index = 0; index < 3; index++) {
      expect(opacity(tester, index), closeTo(.2, tolerance));
    }

    await tester.tap(triggerSurface());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(opacity(tester, 0), closeTo(.4, tolerance));
    expect(translation(tester, 0).dy, closeTo(24, tolerance));
    expect(opacity(tester, 1), closeTo(.2, tolerance));
    expect(opacity(tester, 2), closeTo(.2, tolerance));

    await tester.pump(const Duration(milliseconds: 200));
    expect(opacity(tester, 0), closeTo(.8, tolerance));
    expect(opacity(tester, 1), closeTo(.4, tolerance));
    expect(opacity(tester, 2), closeTo(.2, tolerance));
  });

  testWidgets('reverse order advances the last keyed child first',
      (tester) async {
    await tester.pumpWidget(stagger(order: StaggerOrder.reverse));

    await tester.tap(triggerSurface());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(opacity(tester, 0), closeTo(.2, tolerance));
    expect(opacity(tester, 1), closeTo(.2, tolerance));
    expect(opacity(tester, 2), closeTo(.4, tolerance));
  });

  testWidgets('controller freezes, replays, and resets rendered item frames',
      (tester) async {
    final controller = FluxMotionController();
    await tester.pumpWidget(stagger(controller: controller));

    controller.play();
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    final stoppedFirst = opacity(tester, 0);
    final stoppedSecond = opacity(tester, 1);

    controller.stop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(opacity(tester, 0), closeTo(stoppedFirst, tolerance));
    expect(opacity(tester, 1), closeTo(stoppedSecond, tolerance));

    controller.replay();
    await tester.pump();
    expect(opacity(tester, 0), closeTo(.2, tolerance));
    expect(opacity(tester, 1), closeTo(.2, tolerance));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester, 0), closeTo(.4, tolerance));

    controller.reset();
    await tester.pump();
    for (var index = 0; index < 3; index++) {
      expect(opacity(tester, index), closeTo(.2, tolerance));
      expect(translation(tester, index).dy, closeTo(32, tolerance));
    }
  });

  testWidgets('disabled animations preserve every child without motion layers',
      (tester) async {
    await tester.pumpWidget(stagger(animationsDisabled: true));

    await tester.tap(triggerSurface());
    await tester.pump(const Duration(milliseconds: 500));

    for (var index = 0; index < 3; index++) {
      expect(find.byKey(itemKey(index)), findsOneWidget);
      expect(
        hasLocalLayer(tester, index, (widget) => widget is Opacity),
        isFalse,
      );
      expect(
        hasLocalLayer(tester, index, (widget) => widget is Transform),
        isFalse,
      );
    }
  });

  testWidgets(
      'changing children then removing a running stagger leaks no ticker',
      (tester) async {
    await tester.pumpWidget(stagger());
    await tester.tap(triggerSurface());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));

    await tester.pumpWidget(stagger(itemCount: 2));
    await tester.pump(const Duration(milliseconds: 100));
    expect(find.byKey(itemKey(0)), findsOneWidget);
    expect(find.byKey(itemKey(1)), findsOneWidget);
    expect(find.byKey(itemKey(2)), findsNothing);

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });
}

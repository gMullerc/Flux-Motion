import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const childKey = ValueKey<String>('sequence-child');
  const tolerance = .01;

  Finder renderedOpacity() {
    return find.byWidgetPredicate(
      (widget) => widget is Opacity && widget.child?.key == childKey,
      description: 'the Opacity painted by the sequence',
    );
  }

  Finder renderedTranslation() {
    return find
        .ancestor(
          of: find.byKey(childKey),
          matching: find.byType(Transform),
        )
        .first;
  }

  double opacity(WidgetTester tester) {
    return tester.widget<Opacity>(renderedOpacity()).opacity;
  }

  Offset translation(WidgetTester tester) {
    final matrix = tester.widget<Transform>(renderedTranslation()).transform;
    return Offset(matrix.storage[12], matrix.storage[13]);
  }

  bool hasLocalLayer(
    WidgetTester tester,
    bool Function(Widget widget) matches,
  ) {
    var found = false;
    tester.element(find.byKey(childKey)).visitAncestorElements((element) {
      if (element.widget is FluxSequence) {
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

  List<MotionSequenceStep> linearSteps({
    Duration secondStepDelay = Duration.zero,
  }) {
    return <MotionSequenceStep>[
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(
            begin: .2,
            end: 1,
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          ),
        ),
      ),
      MotionSequenceStep(
        effect: SlideEffect(
          const SlideSpec(
            begin: Offset(40, 0),
            end: Offset.zero,
            duration: Duration(milliseconds: 400),
            curve: Curves.linear,
          ),
        ),
        delay: secondStepDelay,
      ),
    ];
  }

  Widget sequence({
    FluxMotionController? controller,
    bool animationsDisabled = false,
  }) {
    return MaterialApp(
      home: Scaffold(
        body: MediaQuery(
          data: MediaQueryData(disableAnimations: animationsDisabled),
          child: Center(
            child: FluxSequence(
              controller: controller,
              trigger: MotionTrigger.onTap,
              steps: linearSteps(),
              child: const Listener(
                key: childKey,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(width: 120, height: 56),
              ),
            ),
          ),
        ),
      ),
    );
  }

  testWidgets('tap advances each real effect only inside its timeline window',
      (tester) async {
    await tester.pumpWidget(sequence());

    expect(opacity(tester), closeTo(.2, tolerance));
    expect(translation(tester).dx, closeTo(40, tolerance));

    await tester.pump(const Duration(milliseconds: 300));
    expect(opacity(tester), closeTo(.2, tolerance));
    expect(translation(tester).dx, closeTo(40, tolerance));

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    expect(opacity(tester), closeTo(.6, tolerance));
    expect(
      translation(tester).dx,
      closeTo(40, tolerance),
      reason: 'the second step must wait for its timeline delay',
    );

    await tester.pump(const Duration(milliseconds: 300));
    expect(opacity(tester), closeTo(1, tolerance));
    expect(translation(tester).dx, closeTo(30, tolerance));

    await tester.pump(const Duration(milliseconds: 300));
    expect(opacity(tester), closeTo(1, tolerance));
    expect(translation(tester), Offset.zero);
  });

  testWidgets('step delay creates a real gap after the preceding effect',
      (tester) async {
    const gap = Duration(milliseconds: 100);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FluxSequence(
              trigger: MotionTrigger.onTap,
              steps: linearSteps(secondStepDelay: gap),
              child: const Listener(
                key: childKey,
                behavior: HitTestBehavior.opaque,
                child: SizedBox(width: 120, height: 56),
              ),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(opacity(tester), closeTo(1, tolerance));
    expect(translation(tester).dx, closeTo(40, tolerance));

    await tester.pump(gap - const Duration(milliseconds: 1));
    expect(
      translation(tester).dx,
      closeTo(40, tolerance),
      reason: 'the next effect must remain at rest throughout its gap',
    );

    await tester.pump(const Duration(milliseconds: 1));
    expect(translation(tester).dx, closeTo(40, tolerance));
    await tester.pump(const Duration(milliseconds: 100));
    expect(translation(tester).dx, closeTo(30, tolerance));
  });

  testWidgets('controller stops the timeline and replay starts from frame zero',
      (tester) async {
    final controller = FluxMotionController();
    await tester.pumpWidget(sequence(controller: controller));

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));
    final stoppedOpacity = opacity(tester);

    controller.stop();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(opacity(tester), closeTo(stoppedOpacity, tolerance));
    expect(translation(tester).dx, closeTo(40, tolerance));

    controller.replay();
    await tester.pump();
    expect(opacity(tester), closeTo(.2, tolerance));
    expect(translation(tester).dx, closeTo(40, tolerance));
    await tester.pump(const Duration(milliseconds: 100));
    expect(opacity(tester), closeTo(.4, tolerance));
  });

  testWidgets('disabled animations expose the child without render layers',
      (tester) async {
    await tester.pumpWidget(sequence(animationsDisabled: true));

    await tester.tap(find.byKey(childKey));
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.byKey(childKey), findsOneWidget);
    expect(hasLocalLayer(tester, (widget) => widget is Opacity), isFalse);
    expect(hasLocalLayer(tester, (widget) => widget is Transform), isFalse);
  });

  testWidgets('removing a running sequence disposes its ticker',
      (tester) async {
    await tester.pumpWidget(sequence());
    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 150));

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(const Duration(seconds: 2));

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });
}

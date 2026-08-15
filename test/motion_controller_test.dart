import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const childKey = ValueKey<String>('controlled-pulse-child');
  const tolerance = .001;

  Finder pulseTransform() {
    return find.byWidgetPredicate(
      (widget) => widget is Transform && widget.child?.key == childKey,
      description: 'the Transform painted by FluxPulse around its child',
    );
  }

  double renderedScale(WidgetTester tester) {
    return tester.widget<Transform>(pulseTransform()).transform.storage[0];
  }

  testWidgets(
    'controller drives, freezes, replays, resets, and detaches a real motion',
    (tester) async {
      final controller = FluxMotionController();
      const spec = PulseSpec(
        beginScale: .9,
        peakScale: 1.2,
        duration: Duration(milliseconds: 600),
        curve: Curves.linear,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Center(
              child: FluxPulse(
                controller: controller,
                trigger: MotionTrigger.onTap,
                spec: spec,
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

      expect(controller.isAttached, isTrue);
      expect(renderedScale(tester), closeTo(spec.beginScale, tolerance));

      controller.play();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      final runningScale = renderedScale(tester);
      expect(runningScale, greaterThan(spec.beginScale));
      expect(runningScale, lessThan(spec.peakScale));

      controller.stop();
      await tester.pump();
      final stoppedScale = renderedScale(tester);
      await tester.pump(const Duration(milliseconds: 900));
      expect(
        renderedScale(tester),
        closeTo(stoppedScale, tolerance),
        reason: 'stop must freeze the frame while wall-clock time advances',
      );

      controller.replay();
      await tester.pump();
      expect(renderedScale(tester), closeTo(spec.beginScale, tolerance));
      await tester.pump(const Duration(milliseconds: 300));
      expect(renderedScale(tester), closeTo(spec.peakScale, tolerance));

      controller.reset();
      await tester.pump();
      expect(renderedScale(tester), closeTo(spec.beginScale, tolerance));

      await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
      await tester.pump(const Duration(seconds: 1));

      expect(controller.isAttached, isFalse);
      expect(
        () {
          controller.play();
          controller.stop();
          controller.reset();
          controller.replay();
        },
        returnsNormally,
        reason: 'a detached controller must be safe for late product events',
      );
      expect(tester.takeException(), isNull);
      expect(tester.binding.transientCallbackCount, 0);
    },
  );
}

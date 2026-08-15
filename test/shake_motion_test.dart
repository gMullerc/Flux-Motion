import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/shake/flux_shake.dart';
import 'package:flutter_flux_motion/motions/shake/shake_effect.dart';
import 'package:flutter_flux_motion/motions/shake/shake_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const childKey = ValueKey('shake-child');
  const tolerance = .001;

  Widget tappableChild() {
    return const Listener(
      key: childKey,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(width: 96, height: 48),
    );
  }

  Finder motionTransform() {
    return find.byWidgetPredicate(
      (widget) => widget is Transform && widget.child?.key == childKey,
      description: 'the ShakeRender transform around the keyed child',
    );
  }

  double horizontalTranslation(WidgetTester tester) {
    return tester.widget<Transform>(motionTransform()).transform.storage[12];
  }

  Future<double> sampleLargestDisplacement(
    WidgetTester tester,
    Duration duration,
  ) async {
    final step = Duration(microseconds: duration.inMicroseconds ~/ 23);
    var largest = 0.0;
    for (var index = 0; index < 19; index += 1) {
      await tester.pump(step);
      final displacement = horizontalTranslation(tester).abs();
      if (displacement > largest) {
        largest = displacement;
      }
    }
    return largest;
  }

  testWidgets('onTap shakes the child, settles, and can be activated again',
      (tester) async {
    final effect = ShakeEffect(
      const ShakeSpec(
        axis: ShakeAxis.horizontal,
        duration: Duration(milliseconds: 690),
        curve: Curves.linear,
      ),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FluxShake(
              trigger: MotionTrigger.onTap,
              effects: <ShakeEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    expect(horizontalTranslation(tester), closeTo(0, tolerance));
    await tester.pump(const Duration(milliseconds: 250));
    expect(horizontalTranslation(tester), closeTo(0, tolerance),
        reason: 'time must not start an onTap motion');

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    final firstRun = await sampleLargestDisplacement(tester, effect.duration);
    expect(firstRun, greaterThan(.1),
        reason: 'the real transform must leave its resting position');

    await tester.pump(effect.duration);
    expect(horizontalTranslation(tester), closeTo(0, tolerance));

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    final secondRun = await sampleLargestDisplacement(tester, effect.duration);
    expect(secondRun, greaterThan(.1),
        reason: 'a completed shake must be restartable by a second tap');
  });

  testWidgets('the default preset produces useful feedback on mount',
      (tester) async {
    final motion = FluxShake(
      child: const SizedBox(key: childKey, width: 96, height: 48),
    );
    final effect = motion.effects.single as ShakeEffect;

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: motion))),
    );

    final displacement =
        await sampleLargestDisplacement(tester, effect.duration);
    expect(displacement, greaterThan(.1));

    await tester.pump(effect.duration);
    expect(horizontalTranslation(tester), closeTo(0, tolerance));
  });

  testWidgets('disableAnimations preserves the child without shaking it',
      (tester) async {
    final effect = ShakeEffect(
      const ShakeSpec(
        axis: ShakeAxis.horizontal,
        duration: Duration(milliseconds: 400),
      ),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: FluxShake(
              trigger: MotionTrigger.onTap,
              effects: <ShakeEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(childKey));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byKey(childKey), findsOneWidget);
    expect(motionTransform(), findsNothing);
  });
}

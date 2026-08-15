import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/bounce/bounce_effect.dart';
import 'package:flutter_flux_motion/motions/bounce/bounce_preset.dart';
import 'package:flutter_flux_motion/motions/bounce/bounce_spec.dart';
import 'package:flutter_flux_motion/motions/bounce/flux_bounce.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const childKey = ValueKey('bounce-child');
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
      description: 'the BounceRender transform around the keyed child',
    );
  }

  Offset translation(WidgetTester tester) {
    final storage =
        tester.widget<Transform>(motionTransform()).transform.storage;
    return Offset(storage[12], storage[13]);
  }

  Future<List<Offset>> sampleTranslations(
    WidgetTester tester,
    Duration duration,
  ) async {
    final step = Duration(microseconds: duration.inMicroseconds ~/ 23);
    final samples = <Offset>[];
    for (var index = 0; index < 19; index += 1) {
      await tester.pump(step);
      samples.add(translation(tester));
    }
    return samples;
  }

  testWidgets('onTap bounces upward only, settles, and can run again',
      (tester) async {
    final effect = BounceEffect(
      const BounceSpec(
        direction: BounceDirection.up,
        duration: Duration(milliseconds: 690),
        curve: Curves.linear,
      ),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FluxBounce(
              trigger: MotionTrigger.onTap,
              effects: <BounceEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    expect(translation(tester), Offset.zero);
    await tester.pump(const Duration(milliseconds: 250));
    expect(translation(tester), Offset.zero,
        reason: 'time must not start an onTap bounce');

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    final firstRun = await sampleTranslations(tester, effect.duration);
    expect(firstRun.every((offset) => offset.dx.abs() <= tolerance), isTrue);
    expect(firstRun.every((offset) => offset.dy <= tolerance), isTrue,
        reason: 'an upward bounce must never travel below its resting point');
    expect(firstRun.map((offset) => offset.dy).reduce((a, b) => a < b ? a : b),
        lessThan(-.1));

    await tester.pump(effect.duration);
    expect(translation(tester).distance, closeTo(0, tolerance));

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    final secondRun = await sampleTranslations(tester, effect.duration);
    expect(secondRun.any((offset) => offset.dy < -.1), isTrue,
        reason: 'a completed bounce must restart on the second tap');
  });

  testWidgets(
      'notification preset repeats past one cycle and disposes its ticker',
      (tester) async {
    final motion = FluxBounce(
      spec: BouncePreset.notification(),
      child: const SizedBox(key: childKey, width: 96, height: 48),
    );
    final effect = motion.effects.single as BounceEffect;
    final quarterCycle = Duration(
      microseconds: effect.duration.inMicroseconds ~/ 4,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: motion)),
      ),
    );

    await tester.pump(effect.duration + quarterCycle);

    expect(effect.progress, allOf(greaterThan(0), lessThan(1)));
    expect(translation(tester).distance, greaterThan(.1),
        reason: 'notification bounce must still move after one full cycle');

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(effect.duration * 2);

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('the default preset bounces on mount and returns to rest',
      (tester) async {
    final motion = FluxBounce(
      child: const SizedBox(key: childKey, width: 96, height: 48),
    );
    final effect = motion.effects.single as BounceEffect;

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: motion))),
    );

    final samples = await sampleTranslations(tester, effect.duration);
    expect(samples.any((offset) => offset.distance > .1), isTrue);

    await tester.pump(effect.duration);
    expect(translation(tester).distance, closeTo(0, tolerance));
  });

  testWidgets('disableAnimations keeps the complete bounce widget at rest',
      (tester) async {
    final effect = BounceEffect(
      const BounceSpec(duration: Duration(milliseconds: 400)),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: FluxBounce(
              trigger: MotionTrigger.onTap,
              effects: <BounceEffect>[effect],
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

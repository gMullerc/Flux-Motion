import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/pulse/flux_pulse.dart';
import 'package:flutter_flux_motion/motions/pulse/pulse_effect.dart';
import 'package:flutter_flux_motion/motions/pulse/pulse_preset.dart';
import 'package:flutter_flux_motion/motions/pulse/pulse_render.dart';
import 'package:flutter_flux_motion/motions/pulse/pulse_spec.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const childKey = ValueKey('pulse-child');
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
      description: 'the PulseRender transform around the keyed child',
    );
  }

  double scale(WidgetTester tester) {
    return tester.widget<Transform>(motionTransform()).transform.storage[0];
  }

  testWidgets('onTap reaches peak scale, rests, and restarts on a second tap',
      (tester) async {
    const spec = PulseSpec(
      beginScale: .9,
      peakScale: 1.2,
      duration: Duration(milliseconds: 600),
      curve: Curves.linear,
    );
    final effect = PulseEffect(spec, activation: MotionTrigger.onTap);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: Center(
            child: FluxPulse(
              trigger: MotionTrigger.onTap,
              effects: <PulseEffect>[effect],
              child: tappableChild(),
            ),
          ),
        ),
      ),
    );

    expect(scale(tester), closeTo(spec.beginScale, tolerance));
    await tester.pump(const Duration(milliseconds: 300));
    expect(scale(tester), closeTo(spec.beginScale, tolerance),
        reason: 'time must not start an onTap pulse');

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(scale(tester), closeTo(spec.peakScale, tolerance));

    await tester.pump(const Duration(milliseconds: 300));
    expect(scale(tester), closeTo(spec.beginScale, tolerance));

    await tester.tap(find.byKey(childKey));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));
    expect(scale(tester), closeTo(spec.peakScale, tolerance),
        reason: 'a second tap must replay the complete pulse');
  });

  testWidgets('status preset repeats past one cycle and disposes its ticker',
      (tester) async {
    final motion = FluxPulse(
      spec: PulsePreset.status(),
      child: const SizedBox(key: childKey, width: 96, height: 48),
    );
    final effect = motion.effects.single as PulseEffect;
    final halfCycle = Duration(
      microseconds: effect.duration.inMicroseconds ~/ 2,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: Center(child: motion)),
      ),
    );

    await tester.pump(effect.duration + halfCycle);

    expect(effect.progress, closeTo(.5, .01));
    expect(scale(tester), closeTo(effect.spec.peakScale, tolerance),
        reason: 'the status pulse must still animate after one full cycle');

    await tester.pumpWidget(const MaterialApp(home: SizedBox.shrink()));
    await tester.pump(effect.duration * 2);

    expect(tester.takeException(), isNull);
    expect(tester.binding.transientCallbackCount, 0);
  });

  testWidgets('the default preset calls attention on mount and returns to rest',
      (tester) async {
    final motion = FluxPulse(
      child: const SizedBox(key: childKey, width: 96, height: 48),
    );
    final effect = motion.effects.single as PulseEffect;
    final initialScale = (effect.toRender() as PulseRender).scale;

    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: Center(child: motion))),
    );

    await tester.pump(
      Duration(microseconds: effect.duration.inMicroseconds ~/ 2),
    );
    expect(scale(tester), greaterThan(initialScale));

    await tester.pump(effect.duration);
    expect(scale(tester), closeTo(initialScale, tolerance));
  });

  testWidgets('disableAnimations leaves the complete pulse widget unchanged',
      (tester) async {
    final effect = PulseEffect(
      const PulseSpec(duration: Duration(milliseconds: 400)),
      activation: MotionTrigger.onTap,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: FluxPulse(
              trigger: MotionTrigger.onTap,
              effects: <PulseEffect>[effect],
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

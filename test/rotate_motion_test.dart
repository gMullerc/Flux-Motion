import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/rotate/flux_rotate.dart';
import 'package:flutter_flux_motion/motions/rotate/rotate_effect.dart';
import 'package:flutter_flux_motion/motions/rotate/rotate_render.dart';
import 'package:flutter_flux_motion/motions/rotate/rotate_spec.dart';

void main() {
  group('RotateSpec', () {
    test('uses the mobile defaults', () {
      const spec = RotateSpec();

      expect(spec.beginDegrees, 0);
      expect(spec.degrees, 360);
      expect(spec.duration, const Duration(milliseconds: 650));
      expect(spec.curve, Curves.easeOutCubic);
      expect(spec.repeat, isFalse);
      expect(spec.reverse, isTrue);
    });
  });

  group('RotateEffect', () {
    test('exposes the current angle in degrees on its render', () {
      final effect = RotateEffect(
        const RotateSpec(
          beginDegrees: 30,
          degrees: -90,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as RotateRender;
      expect(effect.currentDegrees, closeTo(-15, 0.0001));
      expect(render.degrees, closeTo(-15, 0.0001));
    });

    test('uses the total delta when duration is zero', () {
      final effect = RotateEffect(
        const RotateSpec(
          beginDegrees: 45,
          degrees: -180,
          duration: Duration.zero,
        ),
      );

      effect.tick(Duration.zero);

      expect(effect.currentDegrees, -135);
    });
  });

  group('FluxRotate', () {
    testWidgets('applies a centered rotation transform', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxRotate(
            spec: const RotateSpec(
              degrees: 90,
              duration: Duration(milliseconds: 100),
            ),
            child: const Text('rotated'),
          ),
        ),
      );

      final transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.alignment, Alignment.center);
      expect(transform.transform[1], closeTo(0, 0.0001));
      expect(find.text('rotated'), findsOneWidget);
    });

    testWidgets('plays a negative rotation from a tap', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxRotate(
            trigger: MotionTrigger.onTap,
            spec: const RotateSpec(
              degrees: -90,
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('tap to rotate'),
          ),
        ),
      );

      await tester.tap(find.text('tap to rotate'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final transform = tester.widget<Transform>(find.byType(Transform));
      expect(transform.transform[1], closeTo(-1, 0.0001));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/core/triggers/motion_trigger.dart';
import 'package:flutter_flux_motion/motions/scale/flux_scale.dart';
import 'package:flutter_flux_motion/motions/scale/scale_effect.dart';
import 'package:flutter_flux_motion/motions/scale/scale_render.dart';
import 'package:flutter_flux_motion/motions/scale/scale_spec.dart';

void main() {
  group('ScaleSpec', () {
    test('uses the mobile defaults', () {
      const spec = ScaleSpec();

      expect(spec.begin, 0.92);
      expect(spec.end, 1);
      expect(spec.duration, const Duration(milliseconds: 500));
      expect(spec.curve, Curves.easeOutBack);
      expect(spec.repeat, isFalse);
      expect(spec.reverse, isTrue);
    });
  });

  group('ScaleEffect', () {
    test('maps elapsed time to the configured scale', () {
      final effect = ScaleEffect(
        const ScaleSpec(
          begin: 0.5,
          end: 1.5,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as ScaleRender;
      expect(effect.scale, closeTo(1, 0.0001));
      expect(render.scale, closeTo(1, 0.0001));
    });

    test('uses the end scale when duration is zero', () {
      final effect = ScaleEffect(
        const ScaleSpec(
          begin: 0.4,
          end: 1.2,
          duration: Duration.zero,
        ),
      );

      effect.tick(Duration.zero);

      expect(effect.scale, 1.2);
    });
  });

  group('FluxScale', () {
    testWidgets('applies a transform without changing the child type',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxScale(
            spec: const ScaleSpec(
              duration: Duration(milliseconds: 100),
            ),
            child: const Text('scaled'),
          ),
        ),
      );

      expect(find.byType(Transform), findsOneWidget);
      expect(find.text('scaled'), findsOneWidget);
    });

    testWidgets('starts with a tap trigger', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxScale(
            trigger: MotionTrigger.onTap,
            spec: const ScaleSpec(
              begin: 0.8,
              end: 1,
              duration: Duration(milliseconds: 100),
              curve: Curves.linear,
            ),
            child: const Text('tap to scale'),
          ),
        ),
      );

      await tester.tap(find.text('tap to scale'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final afterTap = tester.widget<Transform>(find.byType(Transform));
      expect(afterTap.transform.getMaxScaleOnAxis(), closeTo(1, 0.0001));
    });
  });
}

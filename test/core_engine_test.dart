import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

void main() {
  group('FluxWrapper', () {
    testWidgets('folds pipeline in order', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxWrapper(
            pipeline: [
              _WrapRender('outer'),
              _WrapRender('inner'),
            ],
            child: const Text('child'),
          ),
        ),
      );

      expect(find.text('inner:outer:child'), findsOneWidget);
    });

    testWidgets('returns child when pipeline is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FluxWrapper(
            pipeline: [],
            child: Text('child'),
          ),
        ),
      );

      expect(find.text('child'), findsOneWidget);
    });
  });

  group('DefaultMotionEngine', () {
    test('buildPipeline uses passthrough when animations disabled', () {
      final engine = DefaultMotionEngine()
        ..configure(animationsDisabled: true)
        ..bind([_TestEffect()], _FakeTickerProvider());

      final pipeline = engine.buildPipeline();

      expect(pipeline, hasLength(1));
      expect(pipeline.first, isA<PassthroughMotionRender>());
      engine.dispose();
    });

    test('start does not forward controller when animations disabled', () {
      final effect = _TestEffect();
      final engine = DefaultMotionEngine()
        ..configure(animationsDisabled: true)
        ..bind([effect], _FakeTickerProvider());

      engine.start(MotionTrigger.onMount);

      expect(effect.playCount, 0);
      engine.dispose();
    });

    test('dispose clears effects without throwing', () {
      final engine = DefaultMotionEngine()
        ..configure(animationsDisabled: false)
        ..bind([_TestEffect()], _FakeTickerProvider());

      expect(() => engine.dispose(), returnsNormally);
    });
  });

  group('FluxMotion', () {
    testWidgets('respects disableAnimations', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(disableAnimations: true),
            child: FluxMotion(
              effects: [_TestEffect()],
              child: const Text('child'),
            ),
          ),
        ),
      );

      await tester.pump();

      expect(find.text('child'), findsOneWidget);
    });
  });

  group('Glow', () {
    test('maps elapsed time to a curved render intensity', () {
      final effect = GlowEffect(
        const GlowSpec(
          color: Colors.cyan,
          intensity: 0.8,
          duration: Duration(milliseconds: 1000),
          curve: Curves.linear,
        ),
      );

      effect.tick(const Duration(milliseconds: 500));

      final render = effect.toRender() as GlowRender;
      expect(render.intensity, closeTo(0.4, 0.0001));
      expect(render.color, Colors.cyan);
    });

    testWidgets('FluxGlow applies a decorated render layer', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxGlow(
            spec: const GlowSpec(
              color: Colors.amber,
              duration: Duration(milliseconds: 100),
            ),
            child: const Text('glowing'),
          ),
        ),
      );

      await tester.pump(const Duration(milliseconds: 100));

      final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.boxShadow, hasLength(1));
      expect(decoration.boxShadow!.single.color.alpha, greaterThan(0));
    });

    testWidgets('FluxGlow starts when its tap trigger is activated',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: FluxGlow(
            trigger: MotionTrigger.onTap,
            spec: const GlowSpec(
              color: Colors.amber,
              duration: Duration(milliseconds: 100),
            ),
            child: const Text('tap me'),
          ),
        ),
      );

      await tester.tap(find.text('tap me'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final decorated = tester.widget<DecoratedBox>(find.byType(DecoratedBox));
      final decoration = decorated.decoration as BoxDecoration;
      expect(decoration.boxShadow!.single.color.alpha, greaterThan(0));
    });
  });
}

class _WrapRender extends MotionRender {
  _WrapRender(this.label);

  final String label;

  @override
  Widget build(Widget child) {
    return Text('$label:${(child as Text).data}');
  }
}

class _TestEffect extends ExplicitMotionEffect {
  int playCount = 0;

  @override
  Duration get duration => const Duration(milliseconds: 300);

  @override
  Curve get curve => Curves.linear;

  @override
  void play({required MotionTrigger trigger}) {
    playCount++;
    super.play(trigger: trigger);
  }

  @override
  MotionRender toRender() => const PassthroughMotionRender();
}

class _FakeTickerProvider implements TickerProvider {
  @override
  Ticker createTicker(TickerCallback onTick) => Ticker(onTick);
}

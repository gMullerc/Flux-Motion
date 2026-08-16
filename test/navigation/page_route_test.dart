import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FluxPageRoute navigation journeys', () {
    testWidgets(
      'pushes with every slide direction, returns a typed result, and pops home',
      (tester) async {
        for (final direction in FluxPageDirection.values) {
          String? routeResult;
          final spec = FluxPageRouteSpec.slide(direction: direction);

          await tester.pumpWidget(
            _NavigationHarness(
              onOpen: (context) async {
                routeResult = await Navigator.of(context).push<String>(
                  FluxPageRoute<String>(
                    spec: spec,
                    builder: (_) => _DestinationPage(
                      title: 'Destination ${direction.name}',
                      result: direction.name,
                    ),
                  ),
                );
              },
              result: () => routeResult,
            ),
          );

          expect(find.text('Home'), findsOneWidget);
          expect(find.textContaining('Destination'), findsNothing);

          await tester.tap(find.byKey(_NavigationHarness.openButtonKey));
          await tester.pump();
          await tester.pump(_midpoint(spec.duration));

          final destination = find.text('Destination ${direction.name}');
          expect(destination, findsOneWidget);
          final slides = tester.widgetList<SlideTransition>(
            find.ancestor(
              of: destination,
              matching: find.byType(SlideTransition),
            ),
          );
          expect(
            slides.any((slide) => slide.position.value != Offset.zero),
            isTrue,
            reason: '${direction.name} must move during the route transition',
          );

          await tester.pumpAndSettle();
          expect(destination, findsOneWidget);

          await tester.tap(find.byKey(_DestinationPage.closeButtonKey));
          await tester.pump();
          await tester.pump(_midpoint(spec.reverseDuration));
          expect(find.text('Home'), findsOneWidget);

          await tester.pumpAndSettle();
          expect(destination, findsNothing);
          expect(routeResult, direction.name);
          expect(find.text('Result: ${direction.name}'), findsOneWidget);
          expect(tester.takeException(), isNull);
        }
      },
    );

    testWidgets('fade exposes an intermediate opacity before completing',
        (tester) async {
      const spec = FluxPageRouteSpec.fade();

      await tester.pumpWidget(
        _NavigationHarness(
          onOpen: (context) {
            Navigator.of(context).push<void>(
              FluxPageRoute<void>(
                spec: spec,
                builder: (_) => const _DestinationPage(title: 'Fade page'),
              ),
            );
          },
        ),
      );

      await tester.tap(find.byKey(_NavigationHarness.openButtonKey));
      await tester.pump();
      await tester.pump(_midpoint(spec.duration));

      final fades = tester.widgetList<FadeTransition>(
        find.ancestor(
          of: find.text('Fade page'),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(
        fades.any((fade) => fade.opacity.value > 0 && fade.opacity.value < 1),
        isTrue,
      );

      await tester.pumpAndSettle();
      expect(find.text('Fade page'), findsOneWidget);
    });

    testWidgets('scale exposes an intermediate transform before completing',
        (tester) async {
      const spec = FluxPageRouteSpec.scale();

      await tester.pumpWidget(
        _NavigationHarness(
          onOpen: (context) {
            Navigator.of(context).push<void>(
              FluxPageRoute<void>(
                spec: spec,
                builder: (_) => const _DestinationPage(title: 'Scale page'),
              ),
            );
          },
        ),
      );

      await tester.tap(find.byKey(_NavigationHarness.openButtonKey));
      await tester.pump();
      await tester.pump(_midpoint(spec.duration));

      final scales = tester.widgetList<ScaleTransition>(
        find.ancestor(
          of: find.text('Scale page'),
          matching: find.byType(ScaleTransition),
        ),
      );
      expect(
        scales.any(
          (scale) => scale.scale.value > 0 && scale.scale.value != 1,
        ),
        isTrue,
      );

      await tester.pumpAndSettle();
      expect(find.text('Scale page'), findsOneWidget);
    });

    testWidgets('navigates from fadeThrough route to sharedAxis route',
        (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) => Scaffold(
              body: Center(
                child: FilledButton(
                  key: const ValueKey<String>('open-fade-through'),
                  onPressed: () {
                    Navigator.of(context).push<void>(
                      FluxPageRoute<void>(
                        spec: const FluxPageRouteSpec.fadeThrough(),
                        builder: (_) => const _ChainedRoutePage(),
                      ),
                    );
                  },
                  child: const Text('Open fade through'),
                ),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.byKey(const ValueKey<String>('open-fade-through')));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text('Fade through route'), findsOneWidget);
      expect(tester.takeException(), isNull);
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_ChainedRoutePage.openSharedAxisKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 80));
      expect(find.text('Shared axis route'), findsOneWidget);
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_DestinationPage.closeButtonKey));
      await tester.pumpAndSettle();
      expect(find.text('Fade through route'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'disableAnimations shows the destination without intermediate route layers',
      (tester) async {
        await tester.pumpWidget(
          _NavigationHarness(
            disableAnimations: true,
            onOpen: (context) {
              Navigator.of(context).push<void>(
                FluxPageRoute<void>(
                  spec:
                      const FluxPageRouteSpec.sharedAxis(axis: Axis.horizontal),
                  builder: (_) => const _DestinationPage(
                    title: 'Reduced motion page',
                  ),
                ),
              );
            },
          ),
        );

        await tester.tap(find.byKey(_NavigationHarness.openButtonKey));
        await tester.pump();
        await tester.pump();

        final destination = find.text('Reduced motion page');
        expect(destination, findsOneWidget);
        expect(
          find.ancestor(
              of: destination, matching: find.byType(SlideTransition)),
          findsNothing,
        );
        expect(
          find.ancestor(
              of: destination, matching: find.byType(ScaleTransition)),
          findsNothing,
        );
        expect(
          find.ancestor(of: destination, matching: find.byType(FadeTransition)),
          findsNothing,
        );

        await tester.pumpAndSettle();
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);
      },
    );
  });
}

Duration _midpoint(Duration duration) {
  return Duration(microseconds: duration.inMicroseconds ~/ 2);
}

class _NavigationHarness extends StatefulWidget {
  const _NavigationHarness({
    required this.onOpen,
    this.result,
    this.disableAnimations = false,
  });

  static const openButtonKey = ValueKey<String>('open-route');

  final FutureOrVoidCallback onOpen;
  final String? Function()? result;
  final bool disableAnimations;

  @override
  State<_NavigationHarness> createState() => _NavigationHarnessState();
}

typedef FutureOrVoidCallback = FutureOr<void> Function(BuildContext context);

class _NavigationHarnessState extends State<_NavigationHarness> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: widget.disableAnimations,
        ),
        child: child!,
      ),
      home: Scaffold(
        body: Center(
          child: Builder(
            builder: (context) => Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Home'),
                FilledButton(
                  key: _NavigationHarness.openButtonKey,
                  onPressed: () async {
                    await widget.onOpen(context);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: const Text('Open route'),
                ),
                Text('Result: ${widget.result?.call() ?? '-'}'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DestinationPage extends StatelessWidget {
  const _DestinationPage({required this.title, this.result});

  static const closeButtonKey = ValueKey<String>('close-route');

  final String title;
  final String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(title),
            FilledButton(
              key: closeButtonKey,
              onPressed: () => Navigator.of(context).pop(result),
              child: const Text('Close route'),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChainedRoutePage extends StatelessWidget {
  const _ChainedRoutePage();

  static const openSharedAxisKey = ValueKey<String>('open-shared-axis');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Fade through route'),
            FilledButton(
              key: openSharedAxisKey,
              onPressed: () {
                Navigator.of(context).push<void>(
                  FluxPageRoute<void>(
                    spec: const FluxPageRouteSpec.sharedAxis(
                      axis: Axis.vertical,
                      reverse: true,
                    ),
                    builder: (_) => const _DestinationPage(
                      title: 'Shared axis route',
                    ),
                  ),
                );
              },
              child: const Text('Open shared axis'),
            ),
          ],
        ),
      ),
    );
  }
}

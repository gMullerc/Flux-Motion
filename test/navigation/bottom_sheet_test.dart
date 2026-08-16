import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showFluxBottomSheet journeys', () {
    testWidgets('opens from a tap and returns a result from an internal action',
        (tester) async {
      String? result;

      await tester.pumpWidget(
        _BottomSheetHarness(
          onOpen: (context) async {
            result = await showFluxBottomSheet<String>(
              context: context,
              spec: const FluxBottomSheetSpec.standard(),
              builder: (_) => const _ResultSheet(),
            );
          },
          result: () => result,
        ),
      );

      expect(find.byType(BottomSheet), findsNothing);
      await tester.tap(find.byKey(_BottomSheetHarness.openButtonKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      expect(find.byType(BottomSheet), findsOneWidget);
      expect(find.text('Sheet content'), findsOneWidget);
      expect(tester.binding.transientCallbackCount, greaterThan(0));

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_ResultSheet.confirmButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      expect(result, 'saved');
      expect(find.text('Result: saved'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('barrier tap dismisses an isDismissible quick sheet',
        (tester) async {
      String? result = 'pending';

      await tester.pumpWidget(
        _BottomSheetHarness(
          onOpen: (context) async {
            result = await showFluxBottomSheet<String>(
              context: context,
              isDismissible: true,
              spec: const FluxBottomSheetSpec.quick(),
              builder: (_) => const _ResultSheet(),
            );
          },
          result: () => result,
        ),
      );

      await tester.tap(find.byKey(_BottomSheetHarness.openButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('downward gesture dismisses an enableDrag gentle sheet',
        (tester) async {
      await tester.pumpWidget(
        _BottomSheetHarness(
          onOpen: (context) async {
            await showFluxBottomSheet<void>(
              context: context,
              enableDrag: true,
              spec: const FluxBottomSheetSpec.gentle(),
              builder: (_) => const _ResultSheet(),
            );
          },
        ),
      );

      await tester.tap(find.byKey(_BottomSheetHarness.openButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsOneWidget);

      await tester.drag(find.byType(BottomSheet), const Offset(0, 500));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      expect(tester.takeException(), isNull);
    });

    testWidgets('disableAnimations completes without a pending ticker',
        (tester) async {
      await tester.pumpWidget(
        _BottomSheetHarness(
          disableAnimations: true,
          onOpen: (context) async {
            await showFluxBottomSheet<void>(
              context: context,
              spec: const FluxBottomSheetSpec.standard(),
              builder: (_) => const _ResultSheet(),
            );
          },
        ),
      );

      await tester.tap(find.byKey(_BottomSheetHarness.openButtonKey));
      await tester.pump();

      expect(find.byType(BottomSheet), findsOneWidget);
      await tester.pumpAndSettle();
      expect(tester.binding.transientCallbackCount, 0);
      expect(tester.takeException(), isNull);

      await tester.tap(find.byKey(_ResultSheet.confirmButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(BottomSheet), findsNothing);
      expect(tester.binding.transientCallbackCount, 0);
    });
  });
}

class _BottomSheetHarness extends StatefulWidget {
  const _BottomSheetHarness({
    required this.onOpen,
    this.result,
    this.disableAnimations = false,
  });

  static const openButtonKey = ValueKey<String>('open-bottom-sheet');

  final Future<void> Function(BuildContext context) onOpen;
  final String? Function()? result;
  final bool disableAnimations;

  @override
  State<_BottomSheetHarness> createState() => _BottomSheetHarnessState();
}

class _BottomSheetHarnessState extends State<_BottomSheetHarness> {
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
                FilledButton(
                  key: _BottomSheetHarness.openButtonKey,
                  onPressed: () async {
                    await widget.onOpen(context);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: const Text('Open bottom sheet'),
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

class _ResultSheet extends StatelessWidget {
  const _ResultSheet();

  static const confirmButtonKey = ValueKey<String>('confirm-bottom-sheet');

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SizedBox(
        height: 220,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Sheet content'),
              FilledButton(
                key: confirmButtonKey,
                onPressed: () => Navigator.of(context).pop('saved'),
                child: const Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('showFluxDialog journeys', () {
    testWidgets('opens from a tap, animates, and returns an action result',
        (tester) async {
      String? result;

      await tester.pumpWidget(
        _DialogHarness(
          onOpen: (context) async {
            result = await showFluxDialog<String>(
              context: context,
              spec: const FluxDialogSpec.fadeScale(),
              builder: (_) => const _ResultDialog(),
            );
          },
          result: () => result,
        ),
      );

      expect(find.byType(AlertDialog), findsNothing);
      await tester.tap(find.byKey(_DialogHarness.openButtonKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      final opacities = tester.widgetList<Opacity>(
        find.ancestor(of: dialog, matching: find.byType(Opacity)),
      );
      expect(
        opacities.any((opacity) => opacity.opacity > 0 && opacity.opacity < 1),
        isTrue,
      );
      final transforms = tester.widgetList<Transform>(
        find.ancestor(of: dialog, matching: find.byType(Transform)),
      );
      expect(
        transforms.any(
          (transform) =>
              transform.transform.storage[0] != 1 ||
              transform.transform.storage[5] != 1,
        ),
        isTrue,
      );

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_ResultDialog.confirmButtonKey));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(result, 'confirmed');
      expect(find.text('Result: confirmed'), findsOneWidget);
      expect(tester.takeException(), isNull);
    });

    testWidgets('dismisses from the modal barrier when enabled',
        (tester) async {
      String? result = 'pending';

      await tester.pumpWidget(
        _DialogHarness(
          onOpen: (context) async {
            result = await showFluxDialog<String>(
              context: context,
              barrierDismissible: true,
              spec: const FluxDialogSpec.fade(),
              builder: (_) => const _ResultDialog(),
            );
          },
          result: () => result,
        ),
      );

      await tester.tap(find.byKey(_DialogHarness.openButtonKey));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tapAt(const Offset(8, 8));
      await tester.pumpAndSettle();

      expect(find.byType(AlertDialog), findsNothing);
      expect(result, isNull);
      expect(tester.takeException(), isNull);
    });

    testWidgets('slideUp preset is visible during a real dialog presentation',
        (tester) async {
      await tester.pumpWidget(
        _DialogHarness(
          onOpen: (context) async {
            await showFluxDialog<void>(
              context: context,
              spec: const FluxDialogSpec.slideUp(),
              builder: (_) => const _ResultDialog(),
            );
          },
        ),
      );

      await tester.tap(find.byKey(_DialogHarness.openButtonKey));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 60));

      final dialog = find.byType(AlertDialog);
      expect(dialog, findsOneWidget);
      final translations = tester.widgetList<FractionalTranslation>(
        find.ancestor(
          of: dialog,
          matching: find.byType(FractionalTranslation),
        ),
      );
      expect(
        translations.any(
          (translation) => translation.translation != Offset.zero,
        ),
        isTrue,
      );
      expect(tester.takeException(), isNull);

      await tester.pumpAndSettle();
      await tester.tap(find.byKey(_ResultDialog.confirmButtonKey));
      await tester.pumpAndSettle();
    });

    testWidgets(
      'disableAnimations presents without intermediate layers or a pending ticker',
      (tester) async {
        await tester.pumpWidget(
          _DialogHarness(
            disableAnimations: true,
            onOpen: (context) async {
              await showFluxDialog<void>(
                context: context,
                spec: const FluxDialogSpec.fadeScale(),
                builder: (_) => const _ResultDialog(),
              );
            },
          ),
        );

        await tester.tap(find.byKey(_DialogHarness.openButtonKey));
        await tester.pump();
        await tester.pump();

        final dialog = find.byType(AlertDialog);
        expect(dialog, findsOneWidget);
        expect(
          find.ancestor(of: dialog, matching: find.byType(Opacity)),
          findsNothing,
        );
        expect(
          find.ancestor(of: dialog, matching: find.byType(Transform)),
          findsNothing,
        );
        expect(
          find.ancestor(
            of: dialog,
            matching: find.byType(FractionalTranslation),
          ),
          findsNothing,
        );

        await tester.pumpAndSettle();
        expect(tester.binding.transientCallbackCount, 0);
        expect(tester.takeException(), isNull);

        await tester.tap(find.byKey(_ResultDialog.confirmButtonKey));
        await tester.pumpAndSettle();
        expect(find.byType(AlertDialog), findsNothing);
        expect(tester.binding.transientCallbackCount, 0);
      },
    );
  });
}

class _DialogHarness extends StatefulWidget {
  const _DialogHarness({
    required this.onOpen,
    this.result,
    this.disableAnimations = false,
  });

  static const openButtonKey = ValueKey<String>('open-dialog');

  final Future<void> Function(BuildContext context) onOpen;
  final String? Function()? result;
  final bool disableAnimations;

  @override
  State<_DialogHarness> createState() => _DialogHarnessState();
}

class _DialogHarnessState extends State<_DialogHarness> {
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
                  key: _DialogHarness.openButtonKey,
                  onPressed: () async {
                    await widget.onOpen(context);
                    if (mounted) {
                      setState(() {});
                    }
                  },
                  child: const Text('Open dialog'),
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

class _ResultDialog extends StatelessWidget {
  const _ResultDialog();

  static const confirmButtonKey = ValueKey<String>('confirm-dialog');

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Confirm action'),
      content: const Text('This is a real modal journey.'),
      actions: [
        TextButton(
          key: confirmButtonKey,
          onPressed: () => Navigator.of(context).pop('confirmed'),
          child: const Text('Confirm'),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _identityPreview(MotionTrigger _, Widget child) => child;

Widget _standardPreview(Widget _) => const _BottomSheetPreview(
      buttonKey: ValueKey('bottom-sheet-open-standard'),
      label: 'Open actions',
      title: 'Project actions',
      badge: 'STANDARD / 300MS',
      spec: FluxBottomSheetSpec.standard(),
    );

Widget _quickPreview(Widget _) => const _BottomSheetPreview(
      buttonKey: ValueKey('bottom-sheet-open-quick'),
      label: 'Quick choice',
      title: 'Sort results',
      badge: 'QUICK / 200MS',
      spec: FluxBottomSheetSpec.quick(),
    );

Widget _gentlePreview(Widget _) => const _BottomSheetPreview(
      buttonKey: ValueKey('bottom-sheet-open-gentle'),
      label: 'Read summary',
      title: 'Weekly summary',
      badge: 'GENTLE / 420MS',
      spec: FluxBottomSheetSpec.gentle(),
    );

Widget _bottomSheetActivation(Color color) {
  return _SheetContractGrid(
    color: color,
    items: const [
      (
        Icons.touch_app_rounded,
        '1 / SHOW',
        'Call showFluxBottomSheet from an action tied to the current mobile context.'
      ),
      (
        Icons.swipe_down_rounded,
        '2 / INTERACT',
        'Users may select an action, drag to dismiss, tap the barrier, or use system back.'
      ),
      (
        Icons.keyboard_return_rounded,
        '3 / RESOLVE',
        'Pop with T for a selection; all dismiss paths complete with null.'
      ),
    ],
  );
}

const bottomSheetCatalog = MotionCatalogEntry(
  id: 'bottom-sheet',
  name: 'showFluxBottomSheet',
  category: 'Navigation / Bottom sheets',
  summary: 'Reveal contextual mobile content with task-appropriate timing.',
  description:
      'showFluxBottomSheet keeps Material bottom-sheet behavior and adds standard, quick, and gentle motion presets. Choose pace by content weight while retaining drag, barrier, safe-area, scrolling, route metadata, and typed result controls.',
  apiLabel: 'showFluxBottomSheet / FluxBottomSheetSpec',
  color: CatalogColors.cyan,
  icon: Icons.vertical_align_top_rounded,
  builder: _identityPreview,
  examples: [
    CatalogExample(
      title: 'Standard action sheet',
      description:
          'The default rhythm suits common contextual menus and compact mobile actions.',
      instruction: 'Tap to open; choose an item or dismiss',
      icon: Icons.more_horiz_rounded,
      badge: 'standard',
      previewBuilder: _standardPreview,
    ),
    CatalogExample(
      title: 'Quick utility',
      description:
          'A shorter transition keeps lightweight choices immediate and reversible.',
      instruction: 'Tap to open the fast preset',
      icon: Icons.bolt_rounded,
      badge: 'quick',
      previewBuilder: _quickPreview,
    ),
    CatalogExample(
      title: 'Gentle content sheet',
      description:
          'A softer pace gives dense summaries or explanatory content time to settle.',
      instruction: 'Tap to inspect the content-rich preset',
      icon: Icons.article_outlined,
      badge: 'gentle',
      previewBuilder: _gentlePreview,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'context',
      type: 'BuildContext',
      defaultValue: 'required',
      description:
          'Locates the Navigator, theme, media preferences, and inherited Material behavior.',
    ),
    CatalogParameter(
      name: 'builder',
      type: 'WidgetBuilder',
      defaultValue: 'required',
      description:
          'Builds sheet content with the route context used to return a value.',
    ),
    CatalogParameter(
      name: 'spec',
      type: 'FluxBottomSheetSpec',
      defaultValue: 'standard()',
      description:
          'Selects standard, quick, or gentle timing with matching entrance and exit curves.',
    ),
    CatalogParameter(
      name: 'isScrollControlled',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Allows taller, scroll-aware sheets when content needs more vertical space.',
    ),
    CatalogParameter(
      name: 'isDismissible / enableDrag',
      type: 'bool / bool',
      defaultValue: 'true / true',
      description:
          'Controls barrier dismissal and the mobile drag-to-close gesture independently.',
    ),
    CatalogParameter(
      name: 'showDragHandle / useSafeArea',
      type: 'bool? / bool',
      defaultValue: 'null / false',
      description:
          'Configures the visible affordance and protection from top, side, and bottom intrusions.',
    ),
    CatalogParameter(
      name: 'backgroundColor / shape / elevation',
      type: 'Color? / ShapeBorder? / double?',
      defaultValue: 'theme',
      description:
          'Delegates visual surface styling to Material defaults unless explicitly overridden.',
    ),
    CatalogParameter(
      name: 'barrierLabel / barrierColor',
      type: 'String? / Color?',
      defaultValue: 'localized / theme',
      description:
          'Names the modal barrier for semantics and controls how strongly it separates background content.',
    ),
    CatalogParameter(
      name: 'clipBehavior / constraints',
      type: 'Clip? / BoxConstraints?',
      defaultValue: 'null / null',
      description:
          'Controls surface clipping and explicit sheet width or height limits when Material defaults are insufficient.',
    ),
    CatalogParameter(
      name: 'useRootNavigator',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Chooses whether the sheet belongs to the nearest or root navigator.',
    ),
    CatalogParameter(
      name: 'routeSettings / anchorPoint',
      type: 'RouteSettings? / Offset?',
      defaultValue: 'null / null',
      description:
          'Adds observer metadata and placement guidance for foldable or multi-display devices.',
    ),
    CatalogParameter(
      name: 'duration / reverseDuration',
      type: 'Duration',
      defaultValue: 'preset',
      description:
          'Uses the selected pace for showing and dismissing the Material route.',
    ),
  ],
  activation: CatalogCustomSection(
    eyebrow: 'SHEET CONTRACT',
    title: 'Show, interact, resolve',
    subtitle:
        'Bottom sheets activate through a modal route with mobile dismissal paths.',
    builder: _bottomSheetActivation,
  ),
  scenarios: [
    CatalogScenario(
      title: 'Context actions',
      description:
          'Present actions related to the current item without leaving the screen.',
      example: 'standard()',
      icon: Icons.more_vert_rounded,
    ),
    CatalogScenario(
      title: 'Sort and filter',
      description:
          'Use quick for frequent utility choices where speed matters more than ceremony.',
      example: 'quick()',
      icon: Icons.tune_rounded,
    ),
    CatalogScenario(
      title: 'Content preview',
      description:
          'Use gentle for a readable summary with more visual and textual density.',
      example: 'gentle()',
      icon: Icons.preview_outlined,
    ),
    CatalogScenario(
      title: 'Scrollable form',
      description:
          'Enable scroll control and safe area for keyboard-aware, content-rich sheets.',
      example: 'isScrollControlled: true',
      icon: Icons.dynamic_form_rounded,
    ),
  ],
  documentationSections: [
    CatalogDocumentationSection(
      eyebrow: 'RETURN VALUE',
      title: 'Selections and dismissals',
      subtitle:
          'The Future<T?> resolves every explicit choice and every dismissal path.',
      items: [
        CatalogDocumentationItem(
          title: 'Return the selection',
          description:
              'Pop with a typed value when an action is chosen; the caller receives it after the sheet exits.',
          label: 'Navigator.pop(context, value)',
          icon: Icons.check_circle_outline_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Treat null as dismiss',
          description:
              'Drag, barrier tap, system back, and a value-less pop all complete with null.',
          label: 'Future<T?>',
          icon: Icons.swipe_down_alt_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Await before acting',
          description:
              'Perform navigation or state changes after awaiting the helper so they do not compete with dismissal.',
          label: 'final choice = await show',
          icon: Icons.hourglass_bottom_rounded,
        ),
      ],
    ),
    CatalogDocumentationSection(
      eyebrow: 'ACCESSIBILITY',
      title: 'More than a drag gesture',
      subtitle:
          'Every sheet remains operable without perceiving animation or performing a swipe.',
      items: [
        CatalogDocumentationItem(
          title: 'Expose a close action',
          description:
              'Do not make drag the only dismissal path. Include a visible close or cancel control for longer sheets.',
          label: 'button + system back',
          icon: Icons.close_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Label the barrier',
          description:
              'Provide barrierLabel when product language needs a more specific dismiss announcement.',
          label: 'barrierLabel',
          icon: Icons.record_voice_over_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Respect reduced motion',
          description:
              'When MediaQuery disables animations, the helper uses Material no-animation style while behavior remains intact.',
          label: 'AnimationStyle.noAnimation',
          icon: Icons.motion_photos_off_rounded,
        ),
      ],
    ),
  ],
  code: '''final action = await showFluxBottomSheet<String>(
  context: context,
  spec: const FluxBottomSheetSpec.standard(),
  showDragHandle: true,
  useSafeArea: true,
  builder: (sheetContext) => SafeArea(
    child: ListTile(
      title: const Text('Archive'),
      onTap: () => Navigator.pop(sheetContext, 'archive'),
    ),
  ),
);

if (action == 'archive') {
  // Handle the selection after dismissal completes.
}''',
);

class _BottomSheetPreview extends StatefulWidget {
  const _BottomSheetPreview({
    required this.buttonKey,
    required this.label,
    required this.title,
    required this.badge,
    required this.spec,
  });

  final Key buttonKey;
  final String label;
  final String title;
  final String badge;
  final FluxBottomSheetSpec spec;

  @override
  State<_BottomSheetPreview> createState() => _BottomSheetPreviewState();
}

class _BottomSheetPreviewState extends State<_BottomSheetPreview> {
  String _result = 'Waiting';

  Future<void> _open() async {
    final result = await showFluxBottomSheet<String>(
      context: context,
      spec: widget.spec,
      showDragHandle: true,
      useSafeArea: true,
      backgroundColor: CatalogColors.panelRaised,
      builder: (sheetContext) => _CatalogBottomSheet(title: widget.title),
    );

    if (mounted) {
      setState(() => _result = result ?? 'Dismissed');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FilledButton.icon(
            key: widget.buttonKey,
            onPressed: _open,
            icon: const Icon(Icons.vertical_align_top_rounded, size: 17),
            label: Text(widget.label),
            style: FilledButton.styleFrom(
              backgroundColor: CatalogColors.cyan,
              foregroundColor: Colors.black,
              visualDensity: VisualDensity.compact,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${widget.badge}  ·  $_result',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: CatalogColors.muted,
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogBottomSheet extends StatelessWidget {
  const _CatalogBottomSheet({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: CatalogColors.text,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'A real modal bottom sheet using the selected timing preset.',
            style: TextStyle(
              color: CatalogColors.muted,
              fontSize: 13,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 16),
          ListTile(
            key: const ValueKey('bottom-sheet-close'),
            contentPadding: const EdgeInsets.symmetric(horizontal: 4),
            leading: const Icon(
              Icons.check_circle_rounded,
              color: CatalogColors.cyan,
            ),
            title: const Text('Select primary action'),
            subtitle: const Text('Returns a typed value to the caller'),
            trailing: const Icon(Icons.chevron_right_rounded),
            onTap: () => Navigator.pop(context, 'Selected'),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              key: const ValueKey('bottom-sheet-cancel'),
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetContractGrid extends StatelessWidget {
  const _SheetContractGrid({required this.color, required this.items});

  final Color color;
  final List<(IconData, String, String)> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = width >= 900
            ? (width - 24) / 3
            : width >= 620
                ? (width - 12) / 2
                : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final item in items)
              SizedBox(
                width: tileWidth,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: CatalogColors.panel,
                    borderRadius: BorderRadius.circular(19),
                    border: Border.all(color: CatalogColors.line),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(item.$1, color: color, size: 21),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$2,
                              style: TextStyle(
                                color: color,
                                fontFamily: 'monospace',
                                fontSize: 10,
                                fontWeight: FontWeight.w900,
                                letterSpacing: .7,
                              ),
                            ),
                            const SizedBox(height: 7),
                            Text(
                              item.$3,
                              style: const TextStyle(
                                color: CatalogColors.muted,
                                fontSize: 12,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

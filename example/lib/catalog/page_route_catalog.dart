import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _identityPreview(MotionTrigger _, Widget child) => child;

Widget _slidePreview(Widget _) => const _PageRoutePreview(
      buttonKey: ValueKey('page-route-open-slide'),
      label: 'Open details',
      destination: 'Order details',
      badge: 'SLIDE / LEFT',
      spec: FluxPageRouteSpec.slide(),
    );

Widget _fadePreview(Widget _) => const _PageRoutePreview(
      buttonKey: ValueKey('page-route-open-fade'),
      label: 'Open context',
      destination: 'Context page',
      badge: 'FADE',
      spec: FluxPageRouteSpec.fade(),
    );

Widget _scalePreview(Widget _) => const _PageRoutePreview(
      buttonKey: ValueKey('page-route-open-scale'),
      label: 'Open focus',
      destination: 'Focused task',
      badge: 'SCALE',
      spec: FluxPageRouteSpec.scale(),
    );

Widget _fadeThroughPreview(Widget _) => const _PageRoutePreview(
      buttonKey: ValueKey('page-route-open-fade-through'),
      label: 'Change section',
      destination: 'Related section',
      badge: 'FADE THROUGH',
      spec: FluxPageRouteSpec.fadeThrough(),
    );

Widget _sharedAxisPreview(Widget _) => const _PageRoutePreview(
      buttonKey: ValueKey('page-route-open-shared-axis'),
      label: 'Continue flow',
      destination: 'Checkout / Step 2',
      badge: 'SHARED AXIS / X',
      spec: FluxPageRouteSpec.sharedAxis(),
    );

Widget _pageRouteActivation(Color color) {
  return _NavigationContractGrid(
    color: color,
    items: const [
      (
        Icons.touch_app_rounded,
        '1 / PUSH',
        'Create FluxPageRoute in the tap callback and pass it to Navigator.push.'
      ),
      (
        Icons.arrow_back_rounded,
        '2 / POP',
        'System back, AppBar back, and Navigator.pop all run reverseDuration.'
      ),
      (
        Icons.subdirectory_arrow_left_rounded,
        '3 / AWAIT',
        'Await push<T> to receive the typed value returned by the destination.'
      ),
    ],
  );
}

const pageRouteCatalog = MotionCatalogEntry(
  id: 'page-route',
  name: 'FluxPageRoute',
  category: 'Navigation / Pages',
  summary: 'Move between mobile screens with coordinated push and pop motion.',
  description:
      'FluxPageRoute is a Navigator-compatible PageRoute with five intentional presets. The navigator owns the animation lifecycle, the destination can return a typed result, and reduced-motion preferences remove visual transforms without changing navigation behavior.',
  apiLabel: 'FluxPageRoute / FluxPageRouteSpec',
  color: CatalogColors.blue,
  icon: Icons.layers_rounded,
  builder: _identityPreview,
  examples: [
    CatalogExample(
      title: 'Slide drill-down',
      description:
          'A spatial left-to-right hierarchy for opening details from a list.',
      instruction: 'Tap to push, then return with a typed result',
      icon: Icons.arrow_forward_rounded,
      badge: 'slide',
      previewBuilder: _slidePreview,
    ),
    CatalogExample(
      title: 'Fade context change',
      description:
          'A quiet transition for destinations without a strong spatial relationship.',
      instruction: 'Tap to open; back uses the reverse timing',
      icon: Icons.opacity_rounded,
      badge: 'fade',
      previewBuilder: _fadePreview,
    ),
    CatalogExample(
      title: 'Scale focused task',
      description:
          'Introduces a focused screen from the current visual center.',
      instruction: 'Tap to open the focused destination',
      icon: Icons.center_focus_strong_rounded,
      badge: 'scale',
      previewBuilder: _scalePreview,
    ),
    CatalogExample(
      title: 'Fade through sections',
      description:
          'Separates related destinations by fading out before revealing the next.',
      instruction: 'Tap to replace the visual context',
      icon: Icons.compare_arrows_rounded,
      badge: 'fadeThrough',
      previewBuilder: _fadeThroughPreview,
    ),
    CatalogExample(
      title: 'Shared-axis flow',
      description:
          'Coordinates outgoing and incoming pages along one axis for sequential steps.',
      instruction: 'Tap to continue the ordered flow',
      icon: Icons.view_week_rounded,
      badge: 'sharedAxis',
      previewBuilder: _sharedAxisPreview,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'builder',
      type: 'WidgetBuilder',
      defaultValue: 'required',
      description:
          'Builds the destination page once the route enters the Navigator.',
    ),
    CatalogParameter(
      name: 'spec',
      type: 'FluxPageRouteSpec',
      defaultValue: 'slide()',
      description:
          'Selects slide, fade, scale, fadeThrough, or sharedAxis and owns transition timing.',
    ),
    CatalogParameter(
      name: 'settings',
      type: 'RouteSettings?',
      defaultValue: 'null',
      description:
          'Carries route names and arguments for analytics, observers, and restoration logic.',
    ),
    CatalogParameter(
      name: 'maintainState',
      type: 'bool',
      defaultValue: 'true',
      description:
          'Keeps the destination state alive while another route covers it.',
    ),
    CatalogParameter(
      name: 'fullscreenDialog',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Marks the route as a full-screen modal journey for platform semantics.',
    ),
    CatalogParameter(
      name: 'allowSnapshotting',
      type: 'bool',
      defaultValue: 'true',
      description:
          'Allows Flutter to animate route snapshots when the platform can optimize the transition.',
    ),
    CatalogParameter(
      name: 'duration / reverseDuration',
      type: 'Duration',
      defaultValue: 'preset',
      description:
          'Controls push and pop independently; presets keep reverse navigation slightly faster.',
    ),
    CatalogParameter(
      name: 'direction / axis / reverse',
      type: 'FluxPageDirection / Axis / bool',
      defaultValue: 'preset',
      description:
          'Defines spatial travel for slide and shared-axis configurations.',
    ),
    CatalogParameter(
      name: 'distance / scaleFrom',
      type: 'double / double',
      defaultValue: 'preset',
      description:
          'Sets fractional travel for spatial presets and the initial scale for scale and fade-through.',
    ),
    CatalogParameter(
      name: 'curve / reverseCurve',
      type: 'Curve',
      defaultValue: 'preset',
      description:
          'Shapes acceleration separately for entering and leaving the destination.',
    ),
  ],
  activation: CatalogCustomSection(
    eyebrow: 'NAVIGATION CONTRACT',
    title: 'Push, pop, and await',
    subtitle:
        'Page motion starts through Navigator APIs—not widget motion triggers.',
    builder: _pageRouteActivation,
  ),
  scenarios: [
    CatalogScenario(
      title: 'List to detail',
      description:
          'Use slide to preserve hierarchy when opening a selected mobile item.',
      example: 'slide()',
      icon: Icons.list_alt_rounded,
    ),
    CatalogScenario(
      title: 'Sequential checkout',
      description:
          'Use sharedAxis to connect ordered steps without implying a new hierarchy.',
      example: 'sharedAxis()',
      icon: Icons.shopping_bag_rounded,
    ),
    CatalogScenario(
      title: 'Focused workflow',
      description:
          'Use scale when a tool or task grows from the center of attention.',
      example: 'scale()',
      icon: Icons.task_alt_rounded,
    ),
    CatalogScenario(
      title: 'Peer destination',
      description:
          'Use fadeThrough when changing related sections at the same hierarchy level.',
      example: 'fadeThrough()',
      icon: Icons.space_dashboard_rounded,
    ),
  ],
  documentationSections: [
    CatalogDocumentationSection(
      eyebrow: 'RETURN VALUE',
      title: 'Typed navigation results',
      subtitle:
          'FluxPageRoute follows the standard Future<T?> contract from Navigator.',
      items: [
        CatalogDocumentationItem(
          title: 'Await the push',
          description:
              'Navigator.push<T> completes when the route is removed and exposes the value supplied to pop.',
          label: 'final value = await push<T>()',
          icon: Icons.hourglass_bottom_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Return a value',
          description:
              'Call Navigator.pop(context, value) from the destination. The reverse preset runs before completion.',
          label: 'pop(context, value)',
          icon: Icons.keyboard_return_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Handle cancellation',
          description:
              'System back or a pop without a value completes the Future with null; model that branch explicitly.',
          label: 'T? / null means cancelled',
          icon: Icons.cancel_outlined,
        ),
      ],
    ),
    CatalogDocumentationSection(
      eyebrow: 'ACCESSIBILITY',
      title: 'Motion without losing navigation',
      subtitle:
          'The route preserves controls, focus, and screen structure when animation is reduced.',
      items: [
        CatalogDocumentationItem(
          title: 'Reduced motion',
          description:
              'When MediaQuery.disableAnimations is true, the destination renders without opacity, scale, or translation changes.',
          label: 'behavior remains intact',
          icon: Icons.motion_photos_off_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Back semantics',
          description:
              'Keep a visible back action and allow system back so users never depend on motion to understand how to leave.',
          label: 'support platform back',
          icon: Icons.arrow_back_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Focus and naming',
          description:
              'Give the destination a clear title and use RouteSettings names when observers or assistive flows need context.',
          label: 'title + route settings',
          icon: Icons.accessibility_new_rounded,
        ),
      ],
    ),
  ],
  code: '''final result = await Navigator.of(context).push<String>(
  FluxPageRoute<String>(
    settings: const RouteSettings(name: '/order/details'),
    spec: const FluxPageRouteSpec.slide(
      direction: FluxPageDirection.left,
    ),
    builder: (context) => OrderDetailsPage(
      onDone: () => Navigator.pop(context, 'confirmed'),
    ),
  ),
);

if (result == 'confirmed') {
  // Continue after the reverse transition completes.
}''',
);

class _PageRoutePreview extends StatefulWidget {
  const _PageRoutePreview({
    required this.buttonKey,
    required this.label,
    required this.destination,
    required this.badge,
    required this.spec,
  });

  final Key buttonKey;
  final String label;
  final String destination;
  final String badge;
  final FluxPageRouteSpec spec;

  @override
  State<_PageRoutePreview> createState() => _PageRoutePreviewState();
}

class _PageRoutePreviewState extends State<_PageRoutePreview> {
  String _result = 'Waiting';

  Future<void> _open() async {
    final result = await Navigator.of(context).push<String>(
      FluxPageRoute<String>(
        spec: widget.spec,
        builder: (_) => _CatalogDestination(title: widget.destination),
      ),
    );

    if (mounted) {
      setState(() => _result = result ?? 'Cancelled');
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
            icon: const Icon(Icons.open_in_new_rounded, size: 17),
            label: Text(widget.label),
            style: FilledButton.styleFrom(
              backgroundColor: CatalogColors.blue,
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

class _CatalogDestination extends StatelessWidget {
  const _CatalogDestination({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CatalogColors.canvas,
      appBar: AppBar(
        backgroundColor: CatalogColors.canvas,
        title: Text(title),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 76,
                    height: 76,
                    decoration: BoxDecoration(
                      color: CatalogColors.blue.withAlpha(22),
                      borderRadius: BorderRadius.circular(22),
                      border: Border.all(
                        color: CatalogColors.blue.withAlpha(130),
                      ),
                    ),
                    child: const Icon(
                      Icons.layers_rounded,
                      color: CatalogColors.blue,
                      size: 34,
                    ),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: CatalogColors.text,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 9),
                  const Text(
                    'This is a real Navigator destination. Pop it to inspect the reverse transition and typed result.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: CatalogColors.muted,
                      fontSize: 13,
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 24),
                  FilledButton.icon(
                    key: const ValueKey('page-route-close'),
                    onPressed: () => Navigator.pop(context, 'Confirmed'),
                    icon: const Icon(Icons.keyboard_return_rounded, size: 18),
                    label: const Text('Return confirmed'),
                    style: FilledButton.styleFrom(
                      backgroundColor: CatalogColors.blue,
                      foregroundColor: Colors.black,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NavigationContractGrid extends StatelessWidget {
  const _NavigationContractGrid({required this.color, required this.items});

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

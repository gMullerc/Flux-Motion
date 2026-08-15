import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _identityPreview(MotionTrigger _, Widget child) => child;

Widget _fadeScalePreview(Widget _) => const _DialogPreview(
      buttonKey: ValueKey('dialog-open-fade-scale'),
      label: 'Confirm action',
      title: 'Archive project?',
      badge: 'FADE + SCALE',
      icon: Icons.archive_outlined,
      spec: FluxDialogSpec.fadeScale(),
    );

Widget _fadePreview(Widget _) => const _DialogPreview(
      buttonKey: ValueKey('dialog-open-fade'),
      label: 'Show notice',
      title: 'Connection restored',
      badge: 'FADE',
      icon: Icons.wifi_rounded,
      spec: FluxDialogSpec.fade(),
    );

Widget _slideUpPreview(Widget _) => const _DialogPreview(
      buttonKey: ValueKey('dialog-open-slide-up'),
      label: 'Choose option',
      title: 'Delivery method',
      badge: 'SLIDE UP',
      icon: Icons.local_shipping_outlined,
      spec: FluxDialogSpec.slideUp(),
    );

Widget _dialogActivation(Color color) {
  return _DialogContractGrid(
    color: color,
    items: const [
      (
        Icons.touch_app_rounded,
        '1 / SHOW',
        'Call showFluxDialog from a deliberate user action with a valid BuildContext.'
      ),
      (
        Icons.blur_on_rounded,
        '2 / MODAL',
        'The barrier separates the decision from the screen behind it and may dismiss when allowed.'
      ),
      (
        Icons.close_rounded,
        '3 / RESOLVE',
        'Pop with a value to confirm, or return null when the dialog is cancelled.'
      ),
    ],
  );
}

const dialogCatalog = MotionCatalogEntry(
  id: 'dialog',
  name: 'showFluxDialog',
  category: 'Navigation / Dialogs',
  summary: 'Present focused decisions with restrained, modal motion.',
  description:
      'showFluxDialog wraps a Material modal route with fadeScale, fade, and slideUp presets. It keeps barrier behavior, safe areas, root navigator selection, route settings, and typed return values explicit so motion never hides the dialog contract.',
  apiLabel: 'showFluxDialog / FluxDialogSpec',
  color: CatalogColors.violet,
  icon: Icons.web_asset_rounded,
  builder: _identityPreview,
  examples: [
    CatalogExample(
      title: 'Decision dialog',
      description:
          'Fade and scale gives a centered confirmation enough emphasis without feeling abrupt.',
      instruction: 'Tap to open, then confirm or cancel',
      icon: Icons.rule_rounded,
      badge: 'fadeScale',
      previewBuilder: _fadeScalePreview,
    ),
    CatalogExample(
      title: 'Status notice',
      description:
          'Fade introduces lightweight information without suggesting physical travel.',
      instruction: 'Tap to show a dismissible notice',
      icon: Icons.notifications_none_rounded,
      badge: 'fade',
      previewBuilder: _fadePreview,
    ),
    CatalogExample(
      title: 'Compact choice',
      description:
          'Slide up gives a small option set a directional relationship with the lower screen area.',
      instruction: 'Tap to open and return the selected value',
      icon: Icons.format_list_bulleted_rounded,
      badge: 'slideUp',
      previewBuilder: _slideUpPreview,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'context',
      type: 'BuildContext',
      defaultValue: 'required',
      description:
          'Locates the Navigator, Material localizations, media preferences, and theme.',
    ),
    CatalogParameter(
      name: 'builder',
      type: 'WidgetBuilder',
      defaultValue: 'required',
      description:
          'Builds the dialog content with the modal route context used to pop it.',
    ),
    CatalogParameter(
      name: 'spec',
      type: 'FluxDialogSpec',
      defaultValue: 'fadeScale()',
      description:
          'Selects fadeScale, fade, or slideUp and configures entrance and exit timing.',
    ),
    CatalogParameter(
      name: 'barrierDismissible',
      type: 'bool',
      defaultValue: 'true',
      description:
          'Allows a tap outside the dialog to cancel it and complete the Future with null.',
    ),
    CatalogParameter(
      name: 'barrierLabel',
      type: 'String?',
      defaultValue: 'localized',
      description:
          'Provides modal barrier semantics; a localized dismiss label is used when possible.',
    ),
    CatalogParameter(
      name: 'barrierColor',
      type: 'Color',
      defaultValue: '0x99000000',
      description:
          'Controls separation between the active decision and background content.',
    ),
    CatalogParameter(
      name: 'useRootNavigator / useSafeArea',
      type: 'bool / bool',
      defaultValue: 'true / true',
      description:
          'Chooses the navigator scope and keeps dialog content clear of system intrusions.',
    ),
    CatalogParameter(
      name: 'routeSettings / anchorPoint',
      type: 'RouteSettings? / Offset?',
      defaultValue: 'null / null',
      description:
          'Adds route metadata and an anchor for foldable or multi-display placement.',
    ),
    CatalogParameter(
      name: 'duration / reverseDuration',
      type: 'Duration',
      defaultValue: '220ms / 180ms',
      description:
          'Controls entrance and exit independently through the selected spec.',
    ),
    CatalogParameter(
      name: 'curve / reverseCurve',
      type: 'Curve / Curve',
      defaultValue: 'easeOutCubic / easeInCubic',
      description:
          'Shapes the forward and reverse progress independently for every preset.',
    ),
    CatalogParameter(
      name: 'scaleFrom / slideFrom / alignment',
      type: 'double / Offset / AlignmentGeometry',
      defaultValue: '.9 / Offset(0, .08) / center',
      description:
          'Configures the starting geometry used by fadeScale and slideUp; unused values remain inert for fade.',
    ),
  ],
  activation: CatalogCustomSection(
    eyebrow: 'MODAL CONTRACT',
    title: 'Show, decide, resolve',
    subtitle:
        'Dialogs activate through a modal route and resolve through Navigator.pop.',
    builder: _dialogActivation,
  ),
  scenarios: [
    CatalogScenario(
      title: 'Destructive confirmation',
      description:
          'Use fadeScale to focus a deliberate choice before irreversible work.',
      example: 'fadeScale()',
      icon: Icons.delete_outline_rounded,
    ),
    CatalogScenario(
      title: 'Permission rationale',
      description:
          'Explain why a capability is needed before launching a system permission.',
      example: 'fade()',
      icon: Icons.privacy_tip_outlined,
    ),
    CatalogScenario(
      title: 'Short option set',
      description:
          'Use slideUp for a compact selection that still belongs in a centered modal.',
      example: 'slideUp()',
      icon: Icons.checklist_rounded,
    ),
    CatalogScenario(
      title: 'Blocking error',
      description:
          'Present a concise recovery action when the current flow cannot continue.',
      example: 'barrierDismissible: false',
      icon: Icons.error_outline_rounded,
    ),
  ],
  documentationSections: [
    CatalogDocumentationSection(
      eyebrow: 'RETURN VALUE',
      title: 'Confirmation and cancellation',
      subtitle:
          'The returned Future makes every dialog outcome explicit to the caller.',
      items: [
        CatalogDocumentationItem(
          title: 'Confirm with T',
          description:
              'Pop with a typed value from the dialog action, then continue the calling workflow after the exit completes.',
          label: 'Navigator.pop(context, value)',
          icon: Icons.done_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Cancel with null',
          description:
              'Barrier taps, system back, and a value-less pop resolve to null; handle cancellation as a normal outcome.',
          label: 'Future<T?>',
          icon: Icons.close_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Use dialog context',
          description:
              'Pop with the context supplied to builder so the modal route—not an unrelated nested navigator—is closed.',
          label: 'builder: (dialogContext)',
          icon: Icons.account_tree_outlined,
        ),
      ],
    ),
    CatalogDocumentationSection(
      eyebrow: 'ACCESSIBILITY',
      title: 'A modal that explains itself',
      subtitle:
          'Text, semantics, and explicit actions remain the primary communication layer.',
      items: [
        CatalogDocumentationItem(
          title: 'Name the barrier',
          description:
              'Supply a concise barrierLabel for custom localization or non-dismissible dialogs.',
          label: 'barrierLabel',
          icon: Icons.record_voice_over_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Keep actions explicit',
          description:
              'Always expose visible confirm and cancel controls; never require a barrier tap or gesture to proceed.',
          label: 'visible actions',
          icon: Icons.smart_button_rounded,
        ),
        CatalogDocumentationItem(
          title: 'Respect reduced motion',
          description:
              'The helper renders the dialog without transforms when MediaQuery disables animations.',
          label: 'zero visual transition',
          icon: Icons.motion_photos_off_rounded,
        ),
      ],
    ),
  ],
  code: '''final accepted = await showFluxDialog<bool>(
  context: context,
  spec: const FluxDialogSpec.fadeScale(),
  barrierDismissible: false,
  barrierLabel: 'Archive confirmation',
  builder: (dialogContext) => AlertDialog(
    title: const Text('Archive project?'),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(dialogContext, false),
        child: const Text('Cancel'),
      ),
      FilledButton(
        onPressed: () => Navigator.pop(dialogContext, true),
        child: const Text('Archive'),
      ),
    ],
  ),
);

if (accepted == true) {
  // Archive after the dialog exit completes.
}''',
);

class _DialogPreview extends StatefulWidget {
  const _DialogPreview({
    required this.buttonKey,
    required this.label,
    required this.title,
    required this.badge,
    required this.icon,
    required this.spec,
  });

  final Key buttonKey;
  final String label;
  final String title;
  final String badge;
  final IconData icon;
  final FluxDialogSpec spec;

  @override
  State<_DialogPreview> createState() => _DialogPreviewState();
}

class _DialogPreviewState extends State<_DialogPreview> {
  String _result = 'Waiting';

  Future<void> _open() async {
    final result = await showFluxDialog<String>(
      context: context,
      spec: widget.spec,
      barrierLabel: 'Dismiss ${widget.title}',
      builder: (dialogContext) => _CatalogDialog(
        title: widget.title,
        icon: widget.icon,
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
            icon: Icon(widget.icon, size: 17),
            label: Text(widget.label),
            style: FilledButton.styleFrom(
              backgroundColor: CatalogColors.violet,
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

class _CatalogDialog extends StatelessWidget {
  const _CatalogDialog({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: CatalogColors.panelRaised,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 360),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: CatalogColors.violet, size: 34),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: CatalogColors.text,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 9),
              const Text(
                'This preview uses the real modal route and returns a typed result.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  TextButton(
                    key: const ValueKey('dialog-cancel'),
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Cancel'),
                  ),
                  FilledButton(
                    key: const ValueKey('dialog-close'),
                    onPressed: () => Navigator.pop(context, 'Confirmed'),
                    style: FilledButton.styleFrom(
                      backgroundColor: CatalogColors.violet,
                      foregroundColor: Colors.black,
                    ),
                    child: const Text('Confirm'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DialogContractGrid extends StatelessWidget {
  const _DialogContractGrid({required this.color, required this.items});

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

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _staggerGroup({
  required MotionTrigger trigger,
  required StaggerSpec spec,
  required IconData icon,
  required List<String> labels,
}) {
  return LayoutBuilder(
    builder: (context, constraints) => SizedBox(
      width: constraints.maxWidth.clamp(0, 186).toDouble(),
      child: FluxStagger(
        trigger: trigger,
        spec: spec,
        children: <Widget>[
          for (var index = 0; index < labels.length; index++)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: CatalogColors.panelRaised,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: CatalogColors.line),
                ),
                child: SizedBox(
                  height: 27,
                  child: Row(
                    children: [
                      const SizedBox(width: 9),
                      Icon(icon, color: CatalogColors.blue, size: 13),
                      const SizedBox(width: 7),
                      Expanded(
                        child: Text(
                          labels[index],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CatalogColors.text,
                            fontFamily: 'monospace',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: .25,
                          ),
                        ),
                      ),
                      Text(
                        '0${index + 1}',
                        style: const TextStyle(
                          color: CatalogColors.muted,
                          fontFamily: 'monospace',
                          fontSize: 8,
                        ),
                      ),
                      const SizedBox(width: 9),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
  );
}

Widget _staggerActionGroup(MotionTrigger trigger) {
  const actions = <(IconData, String)>[
    (Icons.reply_rounded, 'SHARE'),
    (Icons.bookmark_add_outlined, 'SAVE'),
    (Icons.archive_outlined, 'ARCHIVE'),
  ];

  return FluxStagger(
    trigger: trigger,
    spec: const StaggerSpec(
      interval: Duration(milliseconds: 70),
      itemDuration: Duration(milliseconds: 320),
      beginOffset: Offset(14, 0),
      fadeFrom: .2,
    ),
    layoutBuilder: (context, children) => Row(
      mainAxisSize: MainAxisSize.min,
      children: children,
    ),
    children: <Widget>[
      for (final action in actions)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 3),
          child: SizedBox(
            width: 54,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: CatalogColors.blue.withAlpha(22),
                    borderRadius: BorderRadius.circular(11),
                    border: Border.all(
                      color: CatalogColors.blue.withAlpha(110),
                    ),
                  ),
                  child: SizedBox(
                    width: 38,
                    height: 38,
                    child: Icon(action.$1, color: CatalogColors.blue, size: 17),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  action.$2,
                  maxLines: 1,
                  style: const TextStyle(
                    color: CatalogColors.muted,
                    fontFamily: 'monospace',
                    fontSize: 7,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
    ],
  );
}

Widget _staggerDefault(MotionTrigger trigger, Widget _) {
  return _staggerGroup(
    trigger: trigger,
    spec: const StaggerSpec(fadeFrom: .12),
    icon: Icons.layers_rounded,
    labels: const ['ACCOUNT', 'PREFERENCES', 'SECURITY'],
  );
}

Widget _staggerFeed(MotionTrigger trigger, Widget _) {
  return _staggerGroup(
    trigger: trigger,
    spec: const StaggerSpec(
      interval: Duration(milliseconds: 90),
      itemDuration: Duration(milliseconds: 400),
    ),
    icon: Icons.article_outlined,
    labels: const ['NEW MESSAGE', 'ORDER UPDATE', 'DAILY SUMMARY'],
  );
}

Widget _staggerReverse(MotionTrigger trigger, Widget _) {
  return _staggerGroup(
    trigger: trigger,
    spec: const StaggerSpec(
      interval: Duration(milliseconds: 100),
      beginOffset: Offset(-18, 0),
      order: StaggerOrder.reverse,
    ),
    icon: Icons.check_circle_outline_rounded,
    labels: const ['PASSWORD', 'PROFILE', 'EMAIL'],
  );
}

Widget _staggerActions(MotionTrigger trigger, Widget _) {
  return _staggerActionGroup(trigger);
}

Widget _staggerComposition(Widget _) {
  return FluxGlow(
    spec: const GlowSpec(
      radius: 18,
      color: CatalogColors.blue,
      intensity: .38,
      duration: Duration(milliseconds: 520),
    ),
    child: _staggerGroup(
      trigger: MotionTrigger.onMount,
      spec: const StaggerSpec(
        interval: Duration(milliseconds: 110),
        itemDuration: Duration(milliseconds: 460),
        curve: Curves.easeOutBack,
        beginOffset: Offset(0, 20),
      ),
      icon: Icons.route_rounded,
      labels: const ['TRIP READY', 'DRIVER FOUND', 'PICKUP NEXT'],
    ),
  );
}

const staggerCatalog = MotionCatalogEntry(
  id: 'stagger',
  name: 'Stagger',
  category: 'Group orchestration',
  summary: 'Reveal children on one shared timeline, one after another.',
  description:
      'Stagger gives every child its own fade-and-offset window while one controller drives the whole group. The first item starts immediately, each next item waits interval, and total duration is itemDuration + interval × (children.length − 1). Reverse order changes who starts first without changing the widget list.',
  apiLabel: 'FluxStagger / StaggerSpec / StaggerOrder / FluxMotionController',
  color: CatalogColors.blue,
  icon: Icons.view_agenda_rounded,
  builder: _staggerDefault,
  examples: [
    CatalogExample(
      title: 'Feed arrival',
      description:
          'Three feed rows share a 400 ms entrance; each row starts 90 ms after the previous one.',
      trigger: MotionTrigger.onMount,
      instruction: 'Forward · 90 ms interval · 580 ms total',
      builder: _staggerFeed,
      icon: Icons.dynamic_feed_rounded,
    ),
    CatalogExample(
      title: 'Reverse checklist',
      description:
          'The visual list stays in place, but EMAIL starts first because order is reverse.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap · reverse order · left offset',
      builder: _staggerReverse,
      icon: Icons.rule_rounded,
    ),
    CatalogExample(
      title: 'Quick actions',
      description:
          'A custom layoutBuilder arranges the animated children horizontally instead of using the default Column.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press · custom Row layout · 70 ms interval',
      builder: _staggerActions,
      icon: Icons.touch_app_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'interval',
      type: 'Duration',
      defaultValue: '80ms',
      description:
          'Start-time difference between consecutive children; it does not extend each item animation.',
    ),
    CatalogParameter(
      name: 'itemDuration',
      type: 'Duration',
      defaultValue: '420ms',
      description:
          'Local fade-and-translation duration for each child after its own window begins.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutCubic',
      description: 'Timing curve applied to each item local progress.',
    ),
    CatalogParameter(
      name: 'beginOffset',
      type: 'Offset',
      defaultValue: 'Offset(0, 16)',
      description: 'Translation before an item entrance begins.',
    ),
    CatalogParameter(
      name: 'fadeFrom',
      type: 'double',
      defaultValue: '0',
      description:
          'Initial opacity of every item, constrained from zero to one.',
    ),
    CatalogParameter(
      name: 'order',
      type: 'StaggerOrder',
      defaultValue: 'forward',
      description:
          'Chooses which child receives the earliest window; it never reorders the widget tree.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Restarts the complete group timeline after it settles.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'false',
      description: 'Alternates a repeating timeline between its endpoints.',
    ),
    CatalogParameter(
      name: 'children',
      type: 'List<Widget>',
      defaultValue: 'required',
      description:
          'Real widgets coordinated by the shared timeline; keys and input order are preserved.',
    ),
    CatalogParameter(
      name: 'trigger',
      type: 'MotionTrigger',
      defaultValue: 'onMount',
      description: 'Public engine event that begins the group reveal.',
    ),
    CatalogParameter(
      name: 'controller',
      type: 'FluxMotionController?',
      defaultValue: 'null',
      description:
          'Optional play, stop, reset, and replay control for the whole group.',
    ),
    CatalogParameter(
      name: 'controller.play()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Starts the complete stagger timeline.',
    ),
    CatalogParameter(
      name: 'controller.stop()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Freezes every item at its current local progress.',
    ),
    CatalogParameter(
      name: 'controller.reset()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Stops the group and restores every item initial frame.',
    ),
    CatalogParameter(
      name: 'controller.replay()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Restores frame zero and starts the group again.',
    ),
    CatalogParameter(
      name: 'controller.isAttached',
      type: 'bool',
      defaultValue: 'false',
      description: 'Reports whether a mounted Flux widget owns the controller.',
    ),
    CatalogParameter(
      name: 'layoutBuilder',
      type: 'FluxStaggerLayoutBuilder?',
      defaultValue: 'null',
      description:
          'Builds the final group from animated children; defaults to a minimum-height vertical Column and can return Row, Wrap, or a custom layout.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Feed refresh',
      description:
          'Introduce a small inserted batch while preserving keys and reading order.',
      example: 'News / activity / social',
      icon: Icons.refresh_rounded,
    ),
    CatalogScenario(
      title: 'Settings group',
      description:
          'Reveal related preferences as one hierarchy after navigation.',
      example: 'Account / privacy / alerts',
      icon: Icons.tune_rounded,
    ),
    CatalogScenario(
      title: 'Context actions',
      description:
          'Expand a compact mobile action set without every item moving at once.',
      example: 'Share / save / archive',
      icon: Icons.more_horiz_rounded,
    ),
    CatalogScenario(
      title: 'Form validation',
      description:
          'Present multiple requirements in a deliberate, scannable order.',
      example: 'Password / identity / setup',
      icon: Icons.fact_check_outlined,
    ),
  ],
  compositionLabel: 'Glow + Staggered group',
  compositionBuilder: _staggerComposition,
  code: r'''final controller = FluxMotionController();

FluxStagger(
  controller: controller,
  trigger: MotionTrigger.onTap,
  spec: const StaggerSpec(
    interval: Duration(milliseconds: 80),
    itemDuration: Duration(milliseconds: 420),
    curve: Curves.easeOutCubic,
    beginOffset: Offset(0, 16),
    fadeFrom: 0,
    order: StaggerOrder.forward,
  ),
  children: const [
    NotificationTile(key: ValueKey('message')),
    NotificationTile(key: ValueKey('order')),
    NotificationTile(key: ValueKey('summary')),
  ],
  layoutBuilder: (context, animatedChildren) => Column(
    mainAxisSize: MainAxisSize.min,
    children: animatedChildren,
  ),
);

// Start from frame zero after data is inserted.
controller.replay();''',
);

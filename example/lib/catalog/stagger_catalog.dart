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
  return SizedBox(
    width: 186,
    child: FluxStagger(
      trigger: trigger,
      spec: spec,
      children: <Widget>[
        for (var index = 0; index < labels.length; index++)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 3),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: CatalogColors.panelRaised,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: CatalogColors.line),
              ),
              child: SizedBox(
                height: 30,
                child: Row(
                  children: [
                    const SizedBox(width: 9),
                    Icon(icon, color: CatalogColors.blue, size: 14),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        labels[index],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: CatalogColors.text,
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          letterSpacing: .3,
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
  );
}

Widget _staggerDefault(MotionTrigger trigger, Widget _) {
  return _staggerGroup(
    trigger: trigger,
    spec: const StaggerSpec(),
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
  return _staggerGroup(
    trigger: trigger,
    spec: const StaggerSpec(
      interval: Duration(milliseconds: 70),
      itemDuration: Duration(milliseconds: 320),
      beginOffset: Offset(18, 0),
      fadeFrom: .25,
    ),
    icon: Icons.bolt_rounded,
    labels: const ['SHARE', 'SAVE', 'ARCHIVE'],
  );
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
  summary: 'Reveal mobile groups with a precise interval between items.',
  description:
      'Stagger coordinates a real list of widgets on one shared clock. Each item receives the same fade and translation vocabulary, but starts in deterministic forward or reverse order so hierarchy appears without duplicating controllers or keys.',
  apiLabel: 'FluxStagger / StaggerSpec / StaggerOrder / FluxMotionController',
  color: CatalogColors.blue,
  icon: Icons.view_agenda_rounded,
  builder: _staggerDefault,
  examples: [
    CatalogExample(
      title: 'Feed arrival',
      description:
          'Introduces three updates from top to bottom as one readable group.',
      trigger: MotionTrigger.onMount,
      instruction: 'Forward order on mount',
      builder: _staggerFeed,
      icon: Icons.dynamic_feed_rounded,
    ),
    CatalogExample(
      title: 'Reverse checklist',
      description:
          'Reveals the last validation result first after a completed tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap any row',
      builder: _staggerReverse,
      icon: Icons.rule_rounded,
    ),
    CatalogExample(
      title: 'Quick actions',
      description:
          'Brings contextual actions in from the side as touch begins.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press any row',
      builder: _staggerActions,
      icon: Icons.touch_app_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'interval',
      type: 'Duration',
      defaultValue: '80ms',
      description: 'Delay between the start of two consecutive children.',
    ),
    CatalogParameter(
      name: 'itemDuration',
      type: 'Duration',
      defaultValue: '420ms',
      description: 'Independent entrance duration assigned to every child.',
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
      description: 'Selects first-to-last or last-to-first reveal order.',
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
          'Stable group of widgets coordinated by the shared timeline.',
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
          'Optional group layout; the default is a minimum-height vertical Column.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Feed refresh',
      description:
          'Introduce a small batch of new cards while preserving reading order.',
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
    NotificationTile(),
    NotificationTile(),
    NotificationTile(),
  ],
);

controller.replay();''',
);

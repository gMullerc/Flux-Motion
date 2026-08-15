import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _scaleDefault(MotionTrigger trigger, Widget child) {
  return FluxScale(
    trigger: trigger,
    spec: const ScaleSpec(
      begin: .84,
      duration: Duration(milliseconds: 460),
    ),
    child: child,
  );
}

Widget _scalePop(MotionTrigger trigger, Widget child) {
  return FluxScale(
    trigger: trigger,
    spec: const ScaleSpec(
      begin: .68,
      end: 1,
      duration: Duration(milliseconds: 520),
      curve: Curves.easeOutBack,
    ),
    child: child,
  );
}

Widget _scalePress(MotionTrigger trigger, Widget child) {
  return FluxScale(
    trigger: trigger,
    spec: const ScaleSpec(
      begin: 1,
      end: .94,
      duration: Duration(milliseconds: 140),
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Widget _scalePulse(MotionTrigger trigger, Widget child) {
  return FluxScale(
    trigger: trigger,
    spec: const ScaleSpec(
      begin: .92,
      end: 1.04,
      duration: Duration(milliseconds: 680),
      curve: Curves.easeInOut,
      repeat: true,
      reverse: true,
    ),
    child: child,
  );
}

Widget _scaleComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(duration: Duration(milliseconds: 440)),
    child: FluxScale(
      spec: const ScaleSpec(
        begin: .76,
        duration: Duration(milliseconds: 500),
      ),
      child: child,
    ),
  );
}

const scaleCatalog = MotionCatalogEntry(
  id: 'scale',
  name: 'Scale',
  category: 'Emphasis',
  summary: 'Grow or shrink a widget around its center.',
  description:
      'Scale changes visual size without changing the child layout. Restrained ranges create tactile feedback, while wider ranges provide clear emphasis for confirmations, selected states, and important entrances.',
  apiLabel: 'FluxScale / ScaleSpec',
  color: CatalogColors.amber,
  icon: Icons.aspect_ratio_rounded,
  builder: _scaleDefault,
  examples: [
    CatalogExample(
      title: 'Confirmation pop',
      description: 'Creates an expressive entrance for a completed action.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _scalePop,
      icon: Icons.verified_rounded,
    ),
    CatalogExample(
      title: 'Press response',
      description: 'Shrinks a control immediately when the finger touches it.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press the preview',
      builder: _scalePress,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Attention pulse',
      description: 'Repeats a controlled scale cue around the resting size.',
      trigger: MotionTrigger.onMount,
      instruction: 'Repeats and reverses',
      builder: _scalePulse,
      icon: Icons.notifications_active_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'begin',
      type: 'double',
      defaultValue: '0.92',
      description: 'Scale multiplier at the beginning.',
    ),
    CatalogParameter(
      name: 'end',
      type: 'double',
      defaultValue: '1',
      description: 'Scale multiplier at the end.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '500ms',
      description: 'Duration of one forward pass.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutBack',
      description: 'Timing curve applied to the scale progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps the scale playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Returns toward the starting scale while repeating.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Touch feedback',
      description: 'Give buttons, chips, and icons a physical response.',
      example: 'Button / chip / icon',
      icon: Icons.ads_click_rounded,
    ),
    CatalogScenario(
      title: 'Selection',
      description: 'Acknowledge the item that has just become active.',
      example: 'Tab / filter / plan',
      icon: Icons.radio_button_checked_rounded,
    ),
    CatalogScenario(
      title: 'Success',
      description: 'Bring a positive result into the user’s focus.',
      example: 'Payment / save',
      icon: Icons.check_circle_rounded,
    ),
    CatalogScenario(
      title: 'Attention',
      description: 'Pulse a small badge or status that requires notice.',
      example: 'Badge / notification',
      icon: Icons.circle_notifications_rounded,
    ),
  ],
  compositionLabel: 'Fade + Scale',
  compositionBuilder: _scaleComposition,
  code: r'''FluxScale(
  trigger: MotionTrigger.onTapDown,
  spec: const ScaleSpec(
    begin: 1,
    end: 0.96,
    duration: Duration(milliseconds: 120),
    curve: Curves.easeOut,
  ),
  child: const PrimaryButton(),
)''',
);

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _glowDefault(MotionTrigger trigger, Widget child) {
  return FluxGlow(
    trigger: trigger,
    spec: const GlowSpec(
      color: CatalogColors.cyan,
      radius: 22,
      intensity: .72,
      duration: Duration(milliseconds: 620),
    ),
    child: child,
  );
}

Widget _glowSoft(MotionTrigger trigger, Widget child) {
  return FluxGlow(
    trigger: trigger,
    spec: const GlowSpec(
      color: CatalogColors.cyan,
      radius: 18,
      spreadRadius: 1,
      intensity: .5,
      duration: Duration(milliseconds: 520),
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    child: child,
  );
}

Widget _glowTap(MotionTrigger trigger, Widget child) {
  return FluxGlow(
    trigger: trigger,
    spec: const GlowSpec(
      color: CatalogColors.coral,
      radius: 28,
      spreadRadius: 2,
      intensity: .88,
      duration: Duration(milliseconds: 360),
      curve: Curves.easeOut,
      borderRadius: BorderRadius.all(Radius.circular(18)),
    ),
    child: child,
  );
}

Widget _glowPulse(MotionTrigger trigger, Widget child) {
  return FluxGlow(
    trigger: trigger,
    spec: const GlowSpec(
      color: CatalogColors.violet,
      radius: 26,
      spreadRadius: 2,
      intensity: .82,
      duration: Duration(milliseconds: 820),
      curve: Curves.easeInOut,
      repeat: true,
      reverse: true,
      shape: BoxShape.circle,
    ),
    child: child,
  );
}

Widget _glowComposition(Widget child) {
  return FluxScale(
    spec: const ScaleSpec(
      begin: .82,
      duration: Duration(milliseconds: 520),
    ),
    child: FluxGlow(
      spec: const GlowSpec(
        color: CatalogColors.cyan,
        radius: 25,
        intensity: .8,
        duration: Duration(milliseconds: 560),
        borderRadius: BorderRadius.all(Radius.circular(18)),
      ),
      child: child,
    ),
  );
}

const glowCatalog = MotionCatalogEntry(
  id: 'glow',
  name: 'Glow',
  category: 'Light',
  summary: 'Add an animated halo around the complete widget bounds.',
  description:
      'Glow renders an animated shadow outside the child, following either a rectangular border radius or a circular silhouette. It can highlight status, selection, active controls, and ambient feedback without modifying the child decoration.',
  apiLabel: 'FluxGlow / GlowSpec / GlowPreset',
  color: CatalogColors.cyan,
  icon: Icons.blur_on_rounded,
  builder: _glowDefault,
  examples: [
    CatalogExample(
      title: 'Soft halo',
      description: 'Adds a restrained rectangular glow around a full card.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _glowSoft,
      icon: Icons.crop_square_rounded,
    ),
    CatalogExample(
      title: 'Tap highlight',
      description: 'Activates a stronger accent glow after a completed tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _glowTap,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Circular pulse',
      description: 'Follows a circular widget and repeats a light pulse.',
      trigger: MotionTrigger.onMount,
      instruction: 'Repeats and reverses',
      builder: _glowPulse,
      icon: Icons.radio_button_checked_rounded,
      circular: true,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'radius',
      type: 'double',
      defaultValue: '16',
      description: 'Blur radius used by the glow shadow.',
    ),
    CatalogParameter(
      name: 'spreadRadius',
      type: 'double',
      defaultValue: '0',
      description: 'Additional expansion outside the child bounds.',
    ),
    CatalogParameter(
      name: 'color',
      type: 'Color',
      defaultValue: 'white',
      description: 'Base color of the halo.',
    ),
    CatalogParameter(
      name: 'intensity',
      type: 'double',
      defaultValue: '0.65',
      description: 'Maximum opacity multiplier from zero to one.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '700ms',
      description: 'Duration of one forward pass.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOut',
      description: 'Timing curve applied to glow progress.',
    ),
    CatalogParameter(
      name: 'repeat / reverse',
      type: 'bool',
      defaultValue: 'false / true',
      description: 'Controls looping and alternating playback.',
    ),
    CatalogParameter(
      name: 'offset',
      type: 'Offset',
      defaultValue: 'Offset.zero',
      description: 'Moves the halo relative to the child.',
    ),
    CatalogParameter(
      name: 'borderRadius',
      type: 'BorderRadiusGeometry?',
      defaultValue: 'null',
      description: 'Matches the corners of rectangular children.',
    ),
    CatalogParameter(
      name: 'shape',
      type: 'BoxShape',
      defaultValue: 'rectangle',
      description: 'Uses rectangle or circle to follow the silhouette.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Active state',
      description: 'Make the currently selected control unmistakable.',
      example: 'Tab / device / mode',
      icon: Icons.toggle_on_rounded,
    ),
    CatalogScenario(
      title: 'Status',
      description: 'Communicate success, warning, or active connection.',
      example: 'Online / success / alert',
      icon: Icons.sensors_rounded,
    ),
    CatalogScenario(
      title: 'Primary action',
      description: 'Draw attention to the next important user action.',
      example: 'CTA / payment / confirm',
      icon: Icons.bolt_rounded,
    ),
    CatalogScenario(
      title: 'Ambient feedback',
      description: 'Keep a low-noise signal alive around a surface.',
      example: 'Listening / recording',
      icon: Icons.graphic_eq_rounded,
    ),
  ],
  compositionLabel: 'Scale + Glow',
  compositionBuilder: _glowComposition,
  code: r'''FluxGlow(
  trigger: MotionTrigger.onTap,
  spec: const GlowSpec(
    color: Color(0xFF72E2D0),
    radius: 24,
    spreadRadius: 2,
    intensity: 0.8,
    borderRadius: BorderRadius.all(Radius.circular(18)),
  ),
  child: const ActionCard(),
)''',
);

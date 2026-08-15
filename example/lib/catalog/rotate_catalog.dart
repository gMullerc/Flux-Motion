import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _rotateDefault(MotionTrigger trigger, Widget child) {
  return FluxRotate(
    trigger: trigger,
    spec: const RotateSpec(
      degrees: 360,
      duration: Duration(milliseconds: 620),
    ),
    child: child,
  );
}

Widget _rotateState(MotionTrigger trigger, Widget child) {
  return FluxRotate(
    trigger: trigger,
    spec: const RotateSpec(
      beginDegrees: 0,
      degrees: 90,
      duration: Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _rotateNegative(MotionTrigger trigger, Widget child) {
  return FluxRotate(
    trigger: trigger,
    spec: const RotateSpec(
      beginDegrees: 8,
      degrees: -24,
      duration: Duration(milliseconds: 220),
      curve: Curves.easeInOut,
    ),
    child: child,
  );
}

Widget _rotateProcessing(MotionTrigger trigger, Widget child) {
  return FluxRotate(
    trigger: trigger,
    spec: const RotateSpec(
      degrees: 360,
      duration: Duration(milliseconds: 900),
      curve: Curves.linear,
      repeat: true,
      reverse: false,
    ),
    child: child,
  );
}

Widget _rotateComposition(Widget child) {
  return FluxScale(
    spec: const ScaleSpec(
      begin: .74,
      duration: Duration(milliseconds: 520),
    ),
    child: FluxRotate(
      spec: const RotateSpec(
        beginDegrees: -16,
        degrees: 376,
        duration: Duration(milliseconds: 620),
      ),
      child: child,
    ),
  );
}

const rotateCatalog = MotionCatalogEntry(
  id: 'rotate',
  name: 'Rotate',
  category: 'Angle',
  summary: 'Turn a widget around its center while it stays in place.',
  description:
      'Rotate uses degrees as the total angle delta for one pass. Small values communicate a nudge, 90 or 180 degrees explain state changes, and a complete turn works for refresh or processing feedback.',
  apiLabel: 'FluxRotate / RotateSpec',
  color: CatalogColors.violet,
  icon: Icons.rotate_right_rounded,
  builder: _rotateDefault,
  examples: [
    CatalogExample(
      title: 'State change',
      description: 'Turns a chevron 90 degrees after a completed tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _rotateState,
      icon: Icons.chevron_right_rounded,
    ),
    CatalogExample(
      title: 'Negative angle',
      description: 'Uses a negative delta for reverse-direction feedback.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _rotateNegative,
      icon: Icons.error_outline_rounded,
    ),
    CatalogExample(
      title: 'Processing',
      description: 'Loops a full turn while background work is active.',
      trigger: MotionTrigger.onMount,
      instruction: 'Continuous rotation',
      builder: _rotateProcessing,
      icon: Icons.sync_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'beginDegrees',
      type: 'double',
      defaultValue: '0',
      description: 'Starting angle in degrees.',
    ),
    CatalogParameter(
      name: 'degrees',
      type: 'double',
      defaultValue: '360',
      description: 'Total angle delta; negative values reverse direction.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '650ms',
      description: 'Duration of one forward pass.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutCubic',
      description: 'Timing curve applied to the angle progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps the rotation playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Alternates direction while repeating.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Success or error',
      description: 'Turn a result icon with a direction matching the state.',
      example: 'Check / close / status',
      icon: Icons.rule_rounded,
    ),
    CatalogScenario(
      title: 'Refresh',
      description: 'Give sync, reload, and retry actions a complete turn.',
      example: 'Sync / reload / retry',
      icon: Icons.refresh_rounded,
    ),
    CatalogScenario(
      title: 'Disclosure',
      description: 'Rotate a chevron to explain expanded or collapsed state.',
      example: 'Accordion / details',
      icon: Icons.unfold_more_rounded,
    ),
    CatalogScenario(
      title: 'Processing',
      description: 'Loop a symbol while an operation remains active.',
      example: 'Upload / connect / wait',
      icon: Icons.autorenew_rounded,
    ),
  ],
  compositionLabel: 'Scale + Rotate',
  compositionBuilder: _rotateComposition,
  code: r'''FluxRotate(
  trigger: MotionTrigger.onTap,
  spec: const RotateSpec(
    beginDegrees: 0,
    degrees: 90,
    duration: Duration(milliseconds: 260),
    curve: Curves.easeOutCubic,
  ),
  child: const Icon(Icons.chevron_right_rounded),
)''',
);

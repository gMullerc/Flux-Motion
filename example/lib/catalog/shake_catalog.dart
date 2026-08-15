import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _shakeDefault(MotionTrigger trigger, Widget child) {
  return FluxShake(
    trigger: trigger,
    spec: ShakePreset.attention(),
    child: child,
  );
}

Widget _shakeError(MotionTrigger trigger, Widget child) {
  return FluxShake(
    trigger: trigger,
    spec: ShakePreset.error(),
    child: child,
  );
}

Widget _shakeAttention(MotionTrigger trigger, Widget child) {
  return FluxShake(
    trigger: trigger,
    spec: ShakePreset.attention(),
    child: child,
  );
}

Widget _shakeVertical(MotionTrigger trigger, Widget child) {
  return FluxShake(
    trigger: trigger,
    spec: ShakePreset.vertical(),
    child: child,
  );
}

Widget _shakeComposition(Widget child) {
  return FluxShake(
    spec: ShakePreset.error(),
    child: FluxGlow(
      spec: GlowPreset.soft(
        color: CatalogColors.coral,
        intensity: .72,
      ),
      child: child,
    ),
  );
}

const shakeCatalog = MotionCatalogEntry(
  id: 'shake',
  name: 'Shake',
  category: 'Corrective feedback',
  summary: 'Oscillate a widget to signal rejection, error, or urgency.',
  description:
      'Shake moves the child around its resting position and returns it to the exact starting point. Use the horizontal axis for validation and attention, or the vertical axis when the interface needs a directional corrective cue.',
  apiLabel: 'FluxShake / ShakeSpec / ShakePreset / ShakeAxis',
  color: CatalogColors.coral,
  icon: Icons.vibration_rounded,
  builder: _shakeDefault,
  examples: [
    CatalogExample(
      title: 'Validation error',
      description:
          'Rejects an invalid field without moving the surrounding form.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _shakeError,
      icon: Icons.error_outline_rounded,
    ),
    CatalogExample(
      title: 'Attention request',
      description: 'Calls the user back to a control after a completed tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _shakeAttention,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Vertical correction',
      description:
          'Adds a short vertical response when an action cannot continue.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press the preview',
      builder: _shakeVertical,
      icon: Icons.swap_vert_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'axis',
      type: 'ShakeAxis',
      defaultValue: 'horizontal',
      description: 'Chooses horizontal or vertical displacement.',
    ),
    CatalogParameter(
      name: 'distance',
      type: 'double',
      defaultValue: '12',
      description: 'Maximum displacement in logical pixels from rest.',
    ),
    CatalogParameter(
      name: 'oscillations',
      type: 'int',
      defaultValue: '3',
      description: 'Number of alternating movements before settling.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '520ms',
      description: 'Total time from the first displacement to rest.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutCubic',
      description: 'Timing curve used to damp the oscillation.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps replaying complete shake sequences.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Form validation',
      description: 'Keep the invalid field visible while signaling rejection.',
      example: 'Login / checkout / profile',
      icon: Icons.rule_rounded,
    ),
    CatalogScenario(
      title: 'Blocked action',
      description: 'Explain through motion that a control cannot proceed yet.',
      example: 'Disabled CTA / permissions',
      icon: Icons.block_rounded,
    ),
    CatalogScenario(
      title: 'Wrong answer',
      description: 'Give immediate corrective feedback in a learning flow.',
      example: 'Quiz / onboarding',
      icon: Icons.close_rounded,
    ),
    CatalogScenario(
      title: 'Urgent attention',
      description: 'Briefly surface a badge or alert that needs review.',
      example: 'Alert / failed sync',
      icon: Icons.priority_high_rounded,
    ),
  ],
  compositionLabel: 'Shake + Glow',
  compositionBuilder: _shakeComposition,
  code: r'''FluxShake(
  trigger: MotionTrigger.onTap,
  spec: ShakePreset.error(),
  child: const InvalidPasswordField(),
)''',
);

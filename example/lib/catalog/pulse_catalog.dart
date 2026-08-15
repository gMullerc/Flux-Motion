import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _pulseDefault(MotionTrigger trigger, Widget child) {
  return FluxPulse(
    trigger: trigger,
    spec: PulsePreset.emphasis(),
    child: child,
  );
}

Widget _pulseEmphasis(MotionTrigger trigger, Widget child) {
  return FluxPulse(
    trigger: trigger,
    spec: PulsePreset.emphasis(),
    child: child,
  );
}

Widget _pulseTap(MotionTrigger trigger, Widget child) {
  return FluxPulse(
    trigger: trigger,
    spec: PulsePreset.tap(),
    child: child,
  );
}

Widget _pulseStatus(MotionTrigger trigger, Widget child) {
  return FluxPulse(
    trigger: trigger,
    spec: PulsePreset.status(),
    child: child,
  );
}

Widget _pulseComposition(Widget child) {
  return FluxPulse(
    spec: PulsePreset.status(),
    child: FluxGlow(
      spec: GlowPreset.pulse(
        color: CatalogColors.blue,
        intensity: .68,
        shape: BoxShape.circle,
      ),
      child: child,
    ),
  );
}

const pulseCatalog = MotionCatalogEntry(
  id: 'pulse',
  name: 'Pulse',
  category: 'Rhythmic emphasis',
  summary: 'Breathe scale in and out to keep a state or action noticeable.',
  description:
      'Pulse creates a controlled scale rhythm around the widget resting size. A single cycle adds emphasis without changing layout, while a repeating status pulse keeps a live state visible with restrained movement.',
  apiLabel: 'FluxPulse / PulseSpec / PulsePreset',
  color: CatalogColors.blue,
  icon: Icons.monitor_heart_rounded,
  builder: _pulseDefault,
  examples: [
    CatalogExample(
      title: 'Content emphasis',
      description: 'Introduces a result with one confident scale cycle.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _pulseEmphasis,
      icon: Icons.center_focus_strong_rounded,
    ),
    CatalogExample(
      title: 'Tap acknowledgement',
      description: 'Confirms a completed tap with a compact tactile response.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _pulseTap,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Live status',
      description:
          'Maintains a quiet repeating signal while content is visible.',
      trigger: MotionTrigger.onVisibility,
      instruction: 'Starts when the preview becomes visible',
      builder: _pulseStatus,
      icon: Icons.sensors_rounded,
      circular: true,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'beginScale',
      type: 'double',
      defaultValue: '1',
      description: 'Scale multiplier at the resting edge of the pulse.',
    ),
    CatalogParameter(
      name: 'peakScale',
      type: 'double',
      defaultValue: '1.08',
      description: 'Scale multiplier reached at peak emphasis.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '600ms',
      description: 'Duration of one complete pulse from rest to peak and back.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeInOut',
      description: 'Timing curve applied to the pulse progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps pulsing after the first cycle.',
    ),
    CatalogParameter(
      name: 'alignment',
      type: 'Alignment',
      defaultValue: 'Alignment.center',
      description: 'Point around which the child scales.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Primary action',
      description: 'Bring a time-sensitive mobile action back into focus.',
      example: 'Confirm / continue / buy',
      icon: Icons.ads_click_rounded,
    ),
    CatalogScenario(
      title: 'Unread status',
      description: 'Keep a small badge visible without a disruptive loop.',
      example: 'Inbox / activity / updates',
      icon: Icons.mark_email_unread_rounded,
    ),
    CatalogScenario(
      title: 'Live activity',
      description: 'Represent an active process with a steady visual rhythm.',
      example: 'Recording / listening / sync',
      icon: Icons.graphic_eq_rounded,
    ),
    CatalogScenario(
      title: 'Selection feedback',
      description: 'Acknowledge the item that has just become active.',
      example: 'Reaction / favorite / tab',
      icon: Icons.favorite_rounded,
    ),
  ],
  compositionLabel: 'Pulse + Glow',
  compositionBuilder: _pulseComposition,
  code: r'''FluxPulse(
  trigger: MotionTrigger.onTap,
  spec: PulsePreset.tap(),
  child: const FavoriteButton(),
)''',
);

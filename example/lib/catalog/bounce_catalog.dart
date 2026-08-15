import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _bounceDefault(MotionTrigger trigger, Widget child) {
  return FluxBounce(
    trigger: trigger,
    spec: BouncePreset.success(),
    child: child,
  );
}

Widget _bounceSuccess(MotionTrigger trigger, Widget child) {
  return FluxBounce(
    trigger: trigger,
    spec: BouncePreset.success(),
    child: child,
  );
}

Widget _bounceNotification(MotionTrigger trigger, Widget child) {
  return FluxBounce(
    trigger: trigger,
    spec: BouncePreset.notification(),
    child: child,
  );
}

Widget _bouncePlayful(MotionTrigger trigger, Widget child) {
  return FluxBounce(
    trigger: trigger,
    spec: BouncePreset.playful(),
    child: child,
  );
}

Widget _bounceComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(
      duration: Duration(milliseconds: 360),
      curve: Curves.easeOut,
    ),
    child: FluxBounce(
      spec: BouncePreset.success(),
      child: child,
    ),
  );
}

const bounceCatalog = MotionCatalogEntry(
  id: 'bounce',
  name: 'Bounce',
  category: 'Expressive feedback',
  summary: 'Travel and settle with spring-like directional feedback.',
  description:
      'Bounce offsets the child in a chosen direction through progressively smaller arcs, then returns it precisely to rest. It is designed for positive results, notifications, and playful mobile moments that deserve more expression than a simple scale.',
  apiLabel: 'FluxBounce / BounceSpec / BouncePreset / BounceDirection',
  color: CatalogColors.amber,
  icon: Icons.sports_basketball_rounded,
  builder: _bounceDefault,
  examples: [
    CatalogExample(
      title: 'Success arrival',
      description: 'Settles a positive result into place after it appears.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _bounceSuccess,
      icon: Icons.check_circle_rounded,
    ),
    CatalogExample(
      title: 'Notification cue',
      description: 'Moves a badge just enough to acknowledge new activity.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _bounceNotification,
      icon: Icons.notifications_active_rounded,
      circular: true,
    ),
    CatalogExample(
      title: 'Playful reaction',
      description: 'Adds a larger expressive response to a held control.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press the preview',
      builder: _bouncePlayful,
      icon: Icons.emoji_emotions_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'direction',
      type: 'BounceDirection',
      defaultValue: 'up',
      description: 'Direction used for the initial displacement.',
    ),
    CatalogParameter(
      name: 'distance',
      type: 'double',
      defaultValue: '20',
      description: 'Peak travel in logical pixels from the resting position.',
    ),
    CatalogParameter(
      name: 'bounces',
      type: 'int',
      defaultValue: '2',
      description: 'Number of progressively smaller settling movements.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '700ms',
      description: 'Total time from displacement to complete rest.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutCubic',
      description: 'Timing curve applied to directional progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps replaying complete bounce sequences.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Successful action',
      description: 'Celebrate completion while keeping the result anchored.',
      example: 'Payment / upload / save',
      icon: Icons.task_alt_rounded,
    ),
    CatalogScenario(
      title: 'New notification',
      description: 'Make a badge or navigation destination briefly noticeable.',
      example: 'Badge / inbox / activity',
      icon: Icons.notifications_rounded,
    ),
    CatalogScenario(
      title: 'Reaction feedback',
      description: 'Give likes, favorites, and emoji a playful response.',
      example: 'Like / clap / emoji',
      icon: Icons.celebration_rounded,
    ),
    CatalogScenario(
      title: 'Reward reveal',
      description: 'Add character when a mobile reward enters the screen.',
      example: 'Achievement / points / streak',
      icon: Icons.emoji_events_rounded,
    ),
  ],
  compositionLabel: 'Fade + Bounce',
  compositionBuilder: _bounceComposition,
  code: r'''FluxBounce(
  trigger: MotionTrigger.onMount,
  spec: BouncePreset.success(),
  child: const PaymentConfirmedIcon(),
)''',
);

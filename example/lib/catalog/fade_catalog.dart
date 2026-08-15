import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _fadeDefault(MotionTrigger trigger, Widget child) {
  return FluxFade(
    trigger: trigger,
    spec: const FadeSpec(
      duration: Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _fadeSoftEntrance(MotionTrigger trigger, Widget child) {
  return FluxFade(
    trigger: trigger,
    spec: const FadeSpec(
      begin: 0,
      end: 1,
      duration: Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _fadeTapReveal(MotionTrigger trigger, Widget child) {
  return FluxFade(
    trigger: trigger,
    spec: const FadeSpec(
      begin: .18,
      end: 1,
      duration: Duration(milliseconds: 260),
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Widget _fadePulse(MotionTrigger trigger, Widget child) {
  return FluxFade(
    trigger: trigger,
    spec: const FadeSpec(
      begin: .35,
      end: 1,
      duration: Duration(milliseconds: 760),
      curve: Curves.easeInOut,
      repeat: true,
      reverse: true,
    ),
    child: child,
  );
}

Widget _fadeComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(duration: Duration(milliseconds: 460)),
    child: FluxSlide(
      spec: const SlideSpec(
        begin: Offset(0, 20),
        duration: Duration(milliseconds: 460),
      ),
      child: child,
    ),
  );
}

const fadeCatalog = MotionCatalogEntry(
  id: 'fade',
  name: 'Fade',
  category: 'Opacity',
  summary: 'Reveal or hide a widget without changing its layout.',
  description:
      'Fade interpolates opacity between two values. It is the quietest motion in the library and a reliable default for content entry, state changes, overlays, and asynchronous results.',
  apiLabel: 'FluxFade / FadeSpec',
  color: CatalogColors.coral,
  icon: Icons.visibility_rounded,
  builder: _fadeDefault,
  examples: [
    CatalogExample(
      title: 'Soft entrance',
      description: 'Reveals content when it is mounted on the screen.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _fadeSoftEntrance,
      icon: Icons.login_rounded,
    ),
    CatalogExample(
      title: 'Tap reveal',
      description: 'Brings a secondary action from quiet to fully visible.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _fadeTapReveal,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Attention pulse',
      description: 'Repeats a restrained opacity pulse for a small status.',
      trigger: MotionTrigger.onMount,
      instruction: 'Repeats and reverses',
      builder: _fadePulse,
      icon: Icons.notifications_active_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'begin',
      type: 'double',
      defaultValue: '0',
      description: 'Opacity at the beginning of the animation.',
    ),
    CatalogParameter(
      name: 'end',
      type: 'double',
      defaultValue: '1',
      description: 'Opacity at the end of the animation.',
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
      defaultValue: 'easeOut',
      description: 'Timing curve applied to the opacity progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps the fade playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Alternates direction when repeat is enabled.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Screen entry',
      description: 'Introduce a route or a section without moving the layout.',
      example: 'Dashboard / details',
      icon: Icons.mobile_friendly_rounded,
    ),
    CatalogScenario(
      title: 'Async states',
      description: 'Transition between loading, empty, error, and content.',
      example: 'Loading > content',
      icon: Icons.sync_rounded,
    ),
    CatalogScenario(
      title: 'Overlays',
      description: 'Reveal dialogs, sheets, tooltips, and temporary messages.',
      example: 'Modal / toast / sheet',
      icon: Icons.layers_rounded,
    ),
    CatalogScenario(
      title: 'Quiet feedback',
      description: 'Acknowledge a small state change without distraction.',
      example: 'Saved / synced',
      icon: Icons.check_circle_outline_rounded,
    ),
  ],
  compositionLabel: 'Fade + Slide',
  compositionBuilder: _fadeComposition,
  code: r'''FluxFade(
  trigger: MotionTrigger.onMount,
  spec: const FadeSpec(
    begin: 0,
    end: 1,
    duration: Duration(milliseconds: 420),
    curve: Curves.easeOutCubic,
  ),
  child: const ProfileCard(),
)''',
);

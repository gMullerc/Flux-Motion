import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _slideDefault(MotionTrigger trigger, Widget child) {
  return FluxSlide(
    trigger: trigger,
    spec: const SlideSpec(
      begin: Offset(0, 24),
      duration: Duration(milliseconds: 480),
    ),
    child: child,
  );
}

Widget _slideFromBottom(MotionTrigger trigger, Widget child) {
  return FluxSlide(
    trigger: trigger,
    spec: const SlideSpec(
      begin: Offset(0, 32),
      duration: Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _slideFromSide(MotionTrigger trigger, Widget child) {
  return FluxSlide(
    trigger: trigger,
    spec: const SlideSpec(
      begin: Offset(-36, 0),
      duration: Duration(milliseconds: 380),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _slideNudge(MotionTrigger trigger, Widget child) {
  return FluxSlide(
    trigger: trigger,
    spec: const SlideSpec(
      begin: Offset(-8, 0),
      end: Offset(8, 0),
      duration: Duration(milliseconds: 220),
      curve: Curves.easeInOut,
      repeat: true,
      reverse: true,
    ),
    child: child,
  );
}

Widget _slideComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(duration: Duration(milliseconds: 480)),
    child: FluxSlide(
      spec: const SlideSpec(
        begin: Offset(0, 28),
        duration: Duration(milliseconds: 480),
      ),
      child: child,
    ),
  );
}

const slideCatalog = MotionCatalogEntry(
  id: 'slide',
  name: 'Slide',
  category: 'Position',
  summary: 'Move a widget between two logical pixel offsets.',
  description:
      'Slide translates the child without changing its place in the layout. Direction communicates where content came from and helps connect lists, navigation steps, banners, and contextual actions.',
  apiLabel: 'FluxSlide / SlideSpec',
  color: CatalogColors.cyan,
  icon: Icons.open_with_rounded,
  builder: _slideDefault,
  examples: [
    CatalogExample(
      title: 'Bottom entrance',
      description: 'Moves content upward as it enters the screen.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _slideFromBottom,
      icon: Icons.vertical_align_top_rounded,
    ),
    CatalogExample(
      title: 'Side action',
      description: 'Introduces a contextual action from the leading edge.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _slideFromSide,
      icon: Icons.arrow_forward_rounded,
    ),
    CatalogExample(
      title: 'Directional nudge',
      description: 'Repeats a small horizontal cue for required attention.',
      trigger: MotionTrigger.onMount,
      instruction: 'Repeats and reverses',
      builder: _slideNudge,
      icon: Icons.swap_horiz_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'begin',
      type: 'Offset',
      defaultValue: 'Offset(0, 24)',
      description: 'Translation at the beginning, in logical pixels.',
    ),
    CatalogParameter(
      name: 'end',
      type: 'Offset',
      defaultValue: 'Offset.zero',
      description: 'Translation at the end of the animation.',
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
      defaultValue: 'easeOutCubic',
      description: 'Timing curve applied to the translation.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps the slide playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Returns toward the starting offset while repeating.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'List entrance',
      description: 'Stage rows as they become visible in a feed or search.',
      example: 'Inbox / results / feed',
      icon: Icons.view_list_rounded,
    ),
    CatalogScenario(
      title: 'Bottom action',
      description: 'Introduce an action bar or contextual mobile control.',
      example: 'FAB / action bar',
      icon: Icons.vertical_align_bottom_rounded,
    ),
    CatalogScenario(
      title: 'Navigation',
      description: 'Connect sequential steps with a directional transition.',
      example: 'Onboarding / checkout',
      icon: Icons.route_rounded,
    ),
    CatalogScenario(
      title: 'Message banner',
      description: 'Bring a temporary message into the reading flow.',
      example: 'Offline / permission',
      icon: Icons.campaign_rounded,
    ),
  ],
  compositionLabel: 'Fade + Slide',
  compositionBuilder: _slideComposition,
  code: r'''FluxSlide(
  trigger: MotionTrigger.onVisibility,
  spec: const SlideSpec(
    begin: Offset(0, 28),
    end: Offset.zero,
    duration: Duration(milliseconds: 480),
    curve: Curves.easeOutCubic,
  ),
  child: const ResultTile(),
)''',
);

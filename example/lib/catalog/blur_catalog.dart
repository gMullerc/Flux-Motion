import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _blurDefault(MotionTrigger trigger, Widget child) {
  return FluxBlur(
    trigger: trigger,
    spec: const BlurSpec(
      sigmaXBegin: 12,
      sigmaYBegin: 12,
      duration: Duration(milliseconds: 520),
    ),
    child: child,
  );
}

Widget _blurReveal(MotionTrigger trigger, Widget child) {
  return FluxBlur(
    trigger: trigger,
    spec: const BlurSpec(
      sigmaXBegin: 16,
      sigmaYBegin: 16,
      sigmaXEnd: 0,
      sigmaYEnd: 0,
      duration: Duration(milliseconds: 560),
      curve: Curves.easeOutCubic,
    ),
    child: child,
  );
}

Widget _blurPrivacy(MotionTrigger trigger, Widget child) {
  return FluxBlur(
    trigger: trigger,
    spec: const BlurSpec(
      sigmaXBegin: 0,
      sigmaYBegin: 0,
      sigmaXEnd: 10,
      sigmaYEnd: 10,
      duration: Duration(milliseconds: 320),
      curve: Curves.easeOut,
    ),
    child: child,
  );
}

Widget _blurFocusPulse(MotionTrigger trigger, Widget child) {
  return FluxBlur(
    trigger: trigger,
    spec: const BlurSpec(
      sigmaXBegin: 5,
      sigmaYBegin: 5,
      sigmaXEnd: 0,
      sigmaYEnd: 0,
      duration: Duration(milliseconds: 760),
      curve: Curves.easeInOut,
      repeat: true,
      reverse: true,
    ),
    child: child,
  );
}

Widget _blurComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(duration: Duration(milliseconds: 520)),
    child: FluxBlur(
      spec: const BlurSpec(
        sigmaXBegin: 14,
        sigmaYBegin: 14,
        duration: Duration(milliseconds: 560),
      ),
      child: child,
    ),
  );
}

const blurCatalog = MotionCatalogEntry(
  id: 'blur',
  name: 'Blur',
  category: 'Focus',
  summary: 'Move a widget between soft and sharp focus.',
  description:
      'Blur interpolates horizontal and vertical sigma independently. It is useful for privacy-sensitive information, media reveals, asynchronous content, and moments where focus should move between visual layers.',
  apiLabel: 'FluxBlur / BlurSpec',
  color: CatalogColors.blue,
  icon: Icons.blur_on_rounded,
  builder: _blurDefault,
  examples: [
    CatalogExample(
      title: 'Focus reveal',
      description: 'Moves media or content from soft focus to full detail.',
      trigger: MotionTrigger.onMount,
      instruction: 'Replays when the page is restarted',
      builder: _blurReveal,
      icon: Icons.center_focus_strong_rounded,
    ),
    CatalogExample(
      title: 'Privacy cover',
      description: 'Obscures sensitive content after a deliberate tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _blurPrivacy,
      icon: Icons.lock_outline_rounded,
    ),
    CatalogExample(
      title: 'Focus pulse',
      description: 'Repeats a subtle soft-to-sharp focus cue.',
      trigger: MotionTrigger.onMount,
      instruction: 'Repeats and reverses',
      builder: _blurFocusPulse,
      icon: Icons.filter_center_focus_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'sigmaXBegin',
      type: 'double',
      defaultValue: '12',
      description: 'Horizontal blur sigma at the beginning.',
    ),
    CatalogParameter(
      name: 'sigmaYBegin',
      type: 'double',
      defaultValue: '12',
      description: 'Vertical blur sigma at the beginning.',
    ),
    CatalogParameter(
      name: 'sigmaXEnd',
      type: 'double',
      defaultValue: '0',
      description: 'Horizontal blur sigma at the end.',
    ),
    CatalogParameter(
      name: 'sigmaYEnd',
      type: 'double',
      defaultValue: '0',
      description: 'Vertical blur sigma at the end.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '550ms',
      description: 'Duration of one forward pass.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'easeOutCubic',
      description: 'Timing curve applied to both sigma values.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Keeps the blur playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'true',
      description: 'Alternates focus direction while repeating.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Privacy',
      description: 'Keep sensitive information unreadable until requested.',
      example: 'Balance / personal data',
      icon: Icons.shield_outlined,
    ),
    CatalogScenario(
      title: 'Media',
      description: 'Resolve a soft preview into the final image or video.',
      example: 'Photo / video / map',
      icon: Icons.image_outlined,
    ),
    CatalogScenario(
      title: 'Async content',
      description: 'Move a placeholder into a focused loaded result.',
      example: 'Skeleton > result',
      icon: Icons.downloading_rounded,
    ),
    CatalogScenario(
      title: 'Depth',
      description: 'Shift visual focus toward a dialog or bottom sheet.',
      example: 'Modal / bottom sheet',
      icon: Icons.layers_outlined,
    ),
  ],
  compositionLabel: 'Fade + Blur',
  compositionBuilder: _blurComposition,
  code: r'''FluxBlur(
  trigger: MotionTrigger.onVisibility,
  spec: const BlurSpec(
    sigmaXBegin: 14,
    sigmaYBegin: 14,
    sigmaXEnd: 0,
    sigmaYEnd: 0,
    duration: Duration(milliseconds: 520),
  ),
  child: const MediaPreview(),
)''',
);

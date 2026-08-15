import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

Widget _shimmerDefault(MotionTrigger trigger, Widget child) {
  return FluxShimmer(
    trigger: trigger,
    spec: ShimmerPreset.subtle(),
    child: child,
  );
}

Widget _shimmerSkeleton(MotionTrigger trigger, Widget child) {
  return FluxShimmer(
    trigger: trigger,
    spec: ShimmerPreset.skeleton(
      baseColor: const Color(0xFF202830),
      highlightColor: const Color(0xFF53616D),
    ),
    child: child,
  );
}

Widget _shimmerAction(MotionTrigger trigger, Widget child) {
  return FluxShimmer(
    trigger: trigger,
    spec: ShimmerPreset.accent(
      highlightColor: CatalogColors.amber,
    ),
    child: child,
  );
}

Widget _shimmerVertical(MotionTrigger trigger, Widget child) {
  return FluxShimmer(
    trigger: trigger,
    spec: const ShimmerSpec(
      highlightColor: CatalogColors.violet,
      intensity: .82,
      bandWidth: .22,
      direction: ShimmerDirection.topToBottom,
      duration: Duration(milliseconds: 1100),
    ),
    child: child,
  );
}

Widget _shimmerComposition(Widget child) {
  return FluxFade(
    spec: const FadeSpec(duration: Duration(milliseconds: 520)),
    child: FluxShimmer(
      spec: ShimmerPreset.accent(
        highlightColor: CatalogColors.violet,
      ),
      child: child,
    ),
  );
}

const shimmerCatalog = MotionCatalogEntry(
  id: 'shimmer',
  name: 'Shimmer',
  category: 'Loading light',
  summary: 'Sweep a configurable highlight band across any widget.',
  description:
      'Shimmer applies a directional shader over the child. A transparent base preserves the original widget, while an opaque base creates skeleton loading surfaces. Direction, band width, intensity, timing, and repetition stay configurable.',
  apiLabel: 'FluxShimmer / ShimmerSpec / ShimmerPreset',
  color: CatalogColors.violet,
  icon: Icons.waves_rounded,
  builder: _shimmerDefault,
  examples: [
    CatalogExample(
      title: 'Skeleton loading',
      description: 'Uses a base palette to animate a content placeholder.',
      trigger: MotionTrigger.onMount,
      instruction: 'Continuous loading pass',
      builder: _shimmerSkeleton,
      icon: Icons.view_stream_rounded,
    ),
    CatalogExample(
      title: 'Action highlight',
      description: 'Preserves the child and adds a bright pass after a tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _shimmerAction,
      icon: Icons.touch_app_rounded,
    ),
    CatalogExample(
      title: 'Vertical sweep',
      description: 'Moves the highlight from top to bottom for media surfaces.',
      trigger: MotionTrigger.onMount,
      instruction: 'Top to bottom direction',
      builder: _shimmerVertical,
      icon: Icons.swap_vert_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'baseColor',
      type: 'Color',
      defaultValue: 'transparent',
      description: 'Color used outside the moving highlight band.',
    ),
    CatalogParameter(
      name: 'highlightColor',
      type: 'Color',
      defaultValue: 'white',
      description: 'Color at the center of the moving band.',
    ),
    CatalogParameter(
      name: 'intensity',
      type: 'double',
      defaultValue: '0.7',
      description: 'Opacity multiplier applied to the highlight.',
    ),
    CatalogParameter(
      name: 'bandWidth',
      type: 'double',
      defaultValue: '0.28',
      description: 'Relative width of the highlight band from zero to one.',
    ),
    CatalogParameter(
      name: 'direction',
      type: 'ShimmerDirection',
      defaultValue: 'leftToRight',
      description: 'Axis and direction followed by the shader.',
    ),
    CatalogParameter(
      name: 'duration',
      type: 'Duration',
      defaultValue: '1300ms',
      description: 'Duration of one complete shimmer pass.',
    ),
    CatalogParameter(
      name: 'curve',
      type: 'Curve',
      defaultValue: 'linear',
      description: 'Timing curve applied to the shader progress.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'true',
      description: 'Keeps the shimmer playing after the first pass.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'false',
      description: 'Alternates direction while repeating.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Skeleton loading',
      description: 'Communicate that text, cards, or lists are still loading.',
      example: 'Feed / profile / dashboard',
      icon: Icons.hourglass_top_rounded,
    ),
    CatalogScenario(
      title: 'Primary action',
      description: 'Draw attention to an available next step or offer.',
      example: 'CTA / purchase / upgrade',
      icon: Icons.bolt_rounded,
    ),
    CatalogScenario(
      title: 'Media loading',
      description:
          'Animate image and video placeholders before content arrives.',
      example: 'Photo / video / cover',
      icon: Icons.image_outlined,
    ),
    CatalogScenario(
      title: 'Fresh content',
      description: 'Briefly identify a newly updated value or card.',
      example: 'Balance / score / metric',
      icon: Icons.auto_awesome_rounded,
    ),
  ],
  compositionLabel: 'Fade + Shimmer',
  compositionBuilder: _shimmerComposition,
  code: r'''FluxShimmer(
  trigger: MotionTrigger.onMount,
  spec: ShimmerPreset.skeleton(
    baseColor: const Color(0xFF252C33),
    highlightColor: const Color(0xFF4C5661),
  ),
  child: const SkeletonCard(),
)''',
);

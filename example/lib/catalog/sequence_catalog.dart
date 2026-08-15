import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

List<MotionSequenceStep> _entranceSteps() {
  return <MotionSequenceStep>[
    MotionSequenceStep(
      effect: FadeEffect(
        const FadeSpec(
          duration: Duration(milliseconds: 280),
          curve: Curves.easeOut,
        ),
      ),
    ),
    MotionSequenceStep(
      effect: SlideEffect(
        const SlideSpec(
          begin: Offset(0, 18),
          duration: Duration(milliseconds: 360),
          curve: Curves.easeOutCubic,
        ),
      ),
      delay: const Duration(milliseconds: 40),
    ),
  ];
}

List<MotionSequenceStep> _confirmationSteps() {
  return <MotionSequenceStep>[
    MotionSequenceStep(
      effect: ScaleEffect(
        const ScaleSpec(
          begin: .94,
          duration: Duration(milliseconds: 180),
          curve: Curves.easeOutBack,
        ),
      ),
    ),
    MotionSequenceStep(
      effect: RotateEffect(
        const RotateSpec(
          degrees: 12,
          duration: Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
        ),
      ),
      delay: const Duration(milliseconds: 30),
    ),
  ];
}

List<MotionSequenceStep> _statusSteps() {
  return <MotionSequenceStep>[
    MotionSequenceStep(
      effect: SlideEffect(
        const SlideSpec(
          begin: Offset(-16, 0),
          duration: Duration(milliseconds: 300),
        ),
      ),
    ),
    MotionSequenceStep(
      effect: FadeEffect(
        const FadeSpec(
          begin: .35,
          duration: Duration(milliseconds: 240),
        ),
      ),
      delay: const Duration(milliseconds: 20),
    ),
  ];
}

Widget _sequenceDefault(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    trigger: trigger,
    steps: _entranceSteps(),
    child: child,
  );
}

Widget _sequenceEntrance(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    trigger: trigger,
    steps: _entranceSteps(),
    child: child,
  );
}

Widget _sequenceConfirmation(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    trigger: trigger,
    steps: _confirmationSteps(),
    child: child,
  );
}

Widget _sequenceStatus(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    trigger: trigger,
    steps: _statusSteps(),
    child: child,
  );
}

Widget _sequenceComposition(Widget child) {
  return FluxSequence(
    steps: <MotionSequenceStep>[
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(
            duration: Duration(milliseconds: 260),
            curve: Curves.easeOut,
          ),
        ),
      ),
      MotionSequenceStep(
        effect: SlideEffect(
          const SlideSpec(
            begin: Offset(0, 22),
            duration: Duration(milliseconds: 380),
            curve: Curves.easeOutCubic,
          ),
        ),
        delay: Duration.zero,
      ),
    ],
    child: child,
  );
}

const sequenceCatalog = MotionCatalogEntry(
  id: 'sequence',
  name: 'Sequence',
  category: 'Motion orchestration',
  summary: 'Arrange existing effects on one deterministic mobile timeline.',
  description:
      'Sequence gives each effect an explicit start inside a shared timeline. It turns entrance, confirmation, and state-change choreography into immutable steps while one engine owns playback, cancellation, repetition, accessibility, and disposal.',
  apiLabel:
      'FluxSequence / SequenceSpec / MotionSequenceStep / FluxMotionController',
  color: CatalogColors.cyan,
  icon: Icons.account_tree_rounded,
  builder: _sequenceDefault,
  examples: [
    CatalogExample(
      title: 'Layered entrance',
      description:
          'Reveals the surface first, then settles it vertically into place.',
      trigger: MotionTrigger.onMount,
      instruction: 'Fade runs before slide',
      builder: _sequenceEntrance,
      icon: Icons.vertical_align_center_rounded,
    ),
    CatalogExample(
      title: 'Tap confirmation',
      description:
          'Scales a control, then rotates it to acknowledge a completed tap.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap the preview',
      builder: _sequenceConfirmation,
      icon: Icons.touch_app_rounded,
      circular: true,
    ),
    CatalogExample(
      title: 'Status resolve',
      description:
          'Coordinates lateral travel and opacity as soon as touch begins.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press the preview',
      builder: _sequenceStatus,
      icon: Icons.task_alt_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'effect',
      type: 'MotionEffect',
      defaultValue: 'required',
      description:
          'Effect owned by a MotionSequenceStep and rendered on the shared child.',
    ),
    CatalogParameter(
      name: 'delay',
      type: 'Duration',
      defaultValue: 'Duration.zero',
      description:
          'Wait after the previous step finishes and before this effect starts.',
    ),
    CatalogParameter(
      name: 'spec',
      type: 'SequenceSpec?',
      defaultValue: 'null',
      description:
          'Immutable timeline configuration; pass either spec or steps, never both.',
    ),
    CatalogParameter(
      name: 'steps',
      type: 'List<MotionSequenceStep>?',
      defaultValue: 'null',
      description:
          'Ergonomic inline alternative to spec; it must contain at least one step.',
    ),
    CatalogParameter(
      name: 'repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Restarts the complete timeline after its final step.',
    ),
    CatalogParameter(
      name: 'reverse',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Alternates timeline direction while a repeating sequence runs.',
    ),
    CatalogParameter(
      name: 'totalDuration',
      type: 'Duration',
      defaultValue: 'computed',
      description:
          'Read-only sum of every step delay and effect duration in SequenceSpec.',
    ),
    CatalogParameter(
      name: 'trigger',
      type: 'MotionTrigger',
      defaultValue: 'onMount',
      description:
          'Public engine event that starts the sequence without a controller.',
    ),
    CatalogParameter(
      name: 'controller',
      type: 'FluxMotionController?',
      defaultValue: 'null',
      description:
          'Optional play, stop, reset, and replay control owned outside the widget.',
    ),
    CatalogParameter(
      name: 'controller.play()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Starts the sequence through its configured trigger.',
    ),
    CatalogParameter(
      name: 'controller.stop()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Freezes playback at the current timeline frame.',
    ),
    CatalogParameter(
      name: 'controller.reset()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Stops playback and restores the first timeline frame.',
    ),
    CatalogParameter(
      name: 'controller.replay()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Restores frame zero and immediately starts again.',
    ),
    CatalogParameter(
      name: 'controller.isAttached',
      type: 'bool',
      defaultValue: 'false',
      description: 'Reports whether a mounted Flux widget owns the controller.',
    ),
    CatalogParameter(
      name: 'engineFactory',
      type: 'MotionEngine Function()',
      defaultValue: 'DefaultMotionEngine.new',
      description:
          'Advanced dependency hook for the engine that owns sequence playback.',
    ),
    CatalogParameter(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description: 'Single stable widget that receives every sequenced effect.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Onboarding step',
      description:
          'Reveal copy and settle the current instruction without visual overlap.',
      example: 'Coach mark / first run',
      icon: Icons.swipe_rounded,
    ),
    CatalogScenario(
      title: 'Payment result',
      description:
          'Order acknowledgement, icon response, and final resting state.',
      example: 'Checkout / transfer',
      icon: Icons.payments_rounded,
    ),
    CatalogScenario(
      title: 'State transition',
      description:
          'Coordinate exit and arrival cues when one mobile state replaces another.',
      example: 'Empty / loaded / saved',
      icon: Icons.swap_horiz_rounded,
    ),
    CatalogScenario(
      title: 'Guided action',
      description:
          'Present an instruction before emphasizing its next available control.',
      example: 'Permission / setup / form',
      icon: Icons.assistant_direction_rounded,
    ),
  ],
  compositionLabel: 'Fade step → Slide step',
  compositionBuilder: _sequenceComposition,
  code: r'''final controller = FluxMotionController();

FluxSequence(
  controller: controller,
  trigger: MotionTrigger.onTap,
  spec: SequenceSpec(
    steps: [
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(duration: Duration(milliseconds: 280)),
        ),
      ),
      MotionSequenceStep(
        delay: const Duration(milliseconds: 40),
        effect: SlideEffect(
          const SlideSpec(begin: Offset(0, 18)),
        ),
      ),
    ],
  ),
  child: const CheckoutResult(),
);

controller.replay();''',
);

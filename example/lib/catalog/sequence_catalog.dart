import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

SequenceSpec _entranceSpec() {
  return SequenceSpec(
    steps: <MotionSequenceStep>[
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(
            duration: Duration(milliseconds: 180),
            curve: Curves.easeOut,
          ),
        ),
      ),
      MotionSequenceStep(
        delay: const Duration(milliseconds: 40),
        effect: SlideEffect(
          const SlideSpec(
            begin: Offset(0, 18),
            duration: Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
          ),
        ),
      ),
      MotionSequenceStep(
        delay: const Duration(milliseconds: 80),
        effect: PulseEffect(
          const PulseSpec(
            peakScale: 1.04,
            duration: Duration(milliseconds: 320),
          ),
        ),
      ),
    ],
  );
}

SequenceSpec _confirmationSpec() {
  return SequenceSpec(
    steps: <MotionSequenceStep>[
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(
            begin: .2,
            duration: Duration(milliseconds: 140),
          ),
        ),
      ),
      MotionSequenceStep(
        effect: ScaleEffect(
          const ScaleSpec(
            begin: .82,
            duration: Duration(milliseconds: 180),
            curve: Curves.easeOutBack,
          ),
        ),
      ),
      MotionSequenceStep(
        delay: const Duration(milliseconds: 40),
        effect: PulseEffect(
          const PulseSpec(
            peakScale: 1.08,
            duration: Duration(milliseconds: 320),
          ),
        ),
      ),
    ],
  );
}

SequenceSpec _errorRecoverySpec() {
  return SequenceSpec(
    steps: <MotionSequenceStep>[
      MotionSequenceStep(
        effect: ShakeEffect(
          const ShakeSpec(
            distance: 10,
            oscillations: 3,
            duration: Duration(milliseconds: 420),
          ),
        ),
      ),
      MotionSequenceStep(
        // The delay belongs to this step: the UI rests for 220 ms after the
        // shake and before the recovery pulse starts.
        delay: const Duration(milliseconds: 220),
        effect: PulseEffect(
          const PulseSpec(
            peakScale: 1.07,
            duration: Duration(milliseconds: 360),
          ),
        ),
      ),
    ],
  );
}

Widget _sequenceDefault(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    trigger: trigger,
    spec: _entranceSpec(),
    child: child,
  );
}

Widget _sequenceEntrance(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    key: const ValueKey('sequence-entrance-preview'),
    trigger: trigger,
    spec: _entranceSpec(),
    child: child,
  );
}

Widget _sequenceConfirmation(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    key: const ValueKey('sequence-confirmation-preview'),
    trigger: trigger,
    spec: _confirmationSpec(),
    child: child,
  );
}

Widget _sequenceErrorRecovery(MotionTrigger trigger, Widget child) {
  return FluxSequence(
    key: const ValueKey('sequence-error-recovery-preview'),
    trigger: trigger,
    spec: _errorRecoverySpec(),
    child: child,
  );
}

Widget _sequenceTransport(MotionTrigger _, Widget __) {
  return const _SequenceTransportPreview();
}

Widget _sequenceComposition(Widget child) {
  return FluxSequence(
    spec: _entranceSpec(),
    child: child,
  );
}

class _SequenceTransportPreview extends StatefulWidget {
  const _SequenceTransportPreview();

  @override
  State<_SequenceTransportPreview> createState() =>
      _SequenceTransportPreviewState();
}

class _SequenceTransportPreviewState extends State<_SequenceTransportPreview> {
  final FluxMotionController _controller = FluxMotionController();
  late final SequenceSpec _spec = SequenceSpec(
    steps: <MotionSequenceStep>[
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(duration: Duration(milliseconds: 300)),
        ),
      ),
      MotionSequenceStep(
        delay: const Duration(milliseconds: 100),
        effect: SlideEffect(
          const SlideSpec(
            begin: Offset(0, 12),
            duration: Duration(milliseconds: 500),
          ),
        ),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 188,
      height: 116,
      child: Column(
        children: [
          Expanded(
            child: Center(
              child: FluxSequence(
                key: const ValueKey('sequence-controller-preview'),
                controller: _controller,
                trigger: MotionTrigger.onMount,
                spec: _spec,
                child: Container(
                  key: const ValueKey('sequence-controller-target'),
                  width: 88,
                  height: 48,
                  decoration: BoxDecoration(
                    color: CatalogColors.cyan.withAlpha(22),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: CatalogColors.cyan.withAlpha(150),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: const Text(
                    '900 MS',
                    style: TextStyle(
                      color: CatalogColors.cyan,
                      fontFamily: 'monospace',
                      fontSize: 10,
                      fontWeight: FontWeight.w900,
                      letterSpacing: .8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _TransportButton(
                key: const ValueKey('sequence-controller-stop'),
                tooltip: 'Stop on the current frame',
                icon: Icons.pause_rounded,
                onPressed: _controller.stop,
              ),
              const SizedBox(width: 6),
              _TransportButton(
                key: const ValueKey('sequence-controller-reset'),
                tooltip: 'Reset to frame zero',
                icon: Icons.stop_rounded,
                onPressed: _controller.reset,
              ),
              const SizedBox(width: 6),
              _TransportButton(
                key: const ValueKey('sequence-controller-replay'),
                tooltip: 'Replay from the beginning',
                icon: Icons.replay_rounded,
                onPressed: _controller.replay,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TransportButton extends StatelessWidget {
  const _TransportButton({
    super.key,
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: tooltip,
      onPressed: onPressed,
      icon: Icon(icon, size: 16),
      color: CatalogColors.cyan,
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints.tightFor(width: 30, height: 30),
      style: IconButton.styleFrom(
        backgroundColor: CatalogColors.cyan.withAlpha(18),
        side: BorderSide(color: CatalogColors.cyan.withAlpha(90)),
      ),
    );
  }
}

const sequenceCatalog = MotionCatalogEntry(
  id: 'sequence',
  name: 'Sequence',
  category: 'Motion orchestration',
  summary: 'Turn product feedback into one readable mobile timeline.',
  description:
      'Sequence runs existing effects one after another on the same child. Each step owns an effect and an optional gap before it; SequenceSpec computes the full timeline, while triggers or FluxMotionController decide when playback starts, stops, resets, or replays.',
  apiLabel:
      'FluxSequence / SequenceSpec / MotionSequenceStep / FluxMotionController',
  color: CatalogColors.cyan,
  icon: Icons.account_tree_rounded,
  builder: _sequenceDefault,
  examples: [
    CatalogExample(
      title: 'Screen entrance choreography',
      description:
          'Reveals a new surface, settles it vertically, then adds one quiet pulse so the next action reads clearly.',
      trigger: MotionTrigger.onMount,
      instruction:
          '180ms fade + 40ms gap + 260ms slide + 80ms gap + 320ms pulse = 880ms',
      builder: _sequenceEntrance,
      icon: Icons.mobile_friendly_rounded,
    ),
    CatalogExample(
      title: 'Success confirmation',
      description:
          'A completed action appears, lands, and breathes once using three distinct effects: Fade, Scale, and Pulse.',
      trigger: MotionTrigger.onTap,
      instruction: 'Tap · 3 effects · total duration 680ms',
      builder: _sequenceConfirmation,
      icon: Icons.task_alt_rounded,
      circular: true,
    ),
    CatalogExample(
      title: 'Error to recovery',
      description:
          'Touch-down starts an immediate Shake, holds a deliberate 220ms recovery gap, then plays a reassuring Pulse.',
      trigger: MotionTrigger.onTapDown,
      instruction: 'Press · 420ms error + 220ms gap + 360ms recovery = 1000ms',
      builder: _sequenceErrorRecovery,
      icon: Icons.error_outline_rounded,
    ),
    CatalogExample(
      title: 'Controller transport',
      description:
          'An external FluxMotionController can freeze the current frame, restore frame zero, or replay the complete 900ms timeline.',
      trigger: MotionTrigger.onMount,
      instruction: 'Use pause, reset, and replay',
      builder: _sequenceTransport,
      icon: Icons.tune_rounded,
    ),
  ],
  parameters: [
    CatalogParameter(
      name: 'MotionSequenceStep.effect',
      type: 'MotionEffect',
      defaultValue: 'required',
      description:
          'One existing effect, such as FadeEffect, SlideEffect, ShakeEffect, or PulseEffect, rendered on the shared child.',
    ),
    CatalogParameter(
      name: 'MotionSequenceStep.delay',
      type: 'Duration',
      defaultValue: 'Duration.zero',
      description:
          'Gap before this step starts. Because steps are sequential, that means waiting after the previous effect has finished.',
    ),
    CatalogParameter(
      name: 'SequenceSpec.steps',
      type: 'List<MotionSequenceStep>',
      defaultValue: 'required',
      description:
          'Non-empty, immutable timeline order. Effects never overlap; each step starts after the preceding effect and its own delay.',
    ),
    CatalogParameter(
      name: 'SequenceSpec.totalDuration',
      type: 'Duration',
      defaultValue: 'computed',
      description:
          'Read-only sum of every step delay plus every effect duration. Example: 420ms + 220ms + 360ms equals 1000ms.',
    ),
    CatalogParameter(
      name: 'SequenceSpec.repeat',
      type: 'bool',
      defaultValue: 'false',
      description: 'Restarts the complete timeline after its final step.',
    ),
    CatalogParameter(
      name: 'SequenceSpec.reverse',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Alternates timeline direction only while a repeating sequence runs.',
    ),
    CatalogParameter(
      name: 'spec',
      type: 'SequenceSpec?',
      defaultValue: 'null',
      description:
          'Reusable timeline configuration. Pass either spec or inline steps, never both.',
    ),
    CatalogParameter(
      name: 'steps',
      type: 'List<MotionSequenceStep>?',
      defaultValue: 'null',
      description:
          'Inline alternative to spec for a local, non-empty sequence.',
    ),
    CatalogParameter(
      name: 'trigger',
      type: 'MotionTrigger',
      defaultValue: 'onMount',
      description:
          'Starts the full timeline from a lifecycle or interaction event such as onMount, onTap, or onTapDown.',
    ),
    CatalogParameter(
      name: 'controller',
      type: 'FluxMotionController?',
      defaultValue: 'null',
      description:
          'Optional imperative transport. One controller can be attached to one mounted Flux widget at a time.',
    ),
    CatalogParameter(
      name: 'controller.play()',
      type: 'void',
      defaultValue: 'detached no-op',
      description:
          'Starts playback using the trigger configured by the attached FluxSequence.',
    ),
    CatalogParameter(
      name: 'controller.stop()',
      type: 'void',
      defaultValue: 'detached no-op',
      description: 'Freezes playback on the current timeline frame.',
    ),
    CatalogParameter(
      name: 'controller.reset()',
      type: 'void',
      defaultValue: 'detached no-op',
      description:
          'Stops playback and restores frame zero without starting again.',
    ),
    CatalogParameter(
      name: 'controller.replay()',
      type: 'void',
      defaultValue: 'detached no-op',
      description:
          'Restores frame zero and immediately starts the complete timeline again.',
    ),
    CatalogParameter(
      name: 'controller.isAttached',
      type: 'bool',
      defaultValue: 'false',
      description:
          'Reports whether a mounted Flux widget currently owns the controller.',
    ),
    CatalogParameter(
      name: 'engineFactory',
      type: 'MotionEngine Function()',
      defaultValue: 'DefaultMotionEngine.new',
      description:
          'Advanced dependency hook for the engine that owns playback and disposal.',
    ),
    CatalogParameter(
      name: 'child',
      type: 'Widget',
      defaultValue: 'required',
      description:
          'One stable widget that receives every effect in timeline order.',
    ),
  ],
  scenarios: [
    CatalogScenario(
      title: 'Screen entrance',
      description:
          'Reveal hierarchy in a predictable order when a route or sheet arrives.',
      example: 'Checkout / onboarding',
      icon: Icons.view_agenda_rounded,
    ),
    CatalogScenario(
      title: 'Success feedback',
      description:
          'Turn completion into a short acknowledgement with a clear resting state.',
      example: 'Payment / saved form',
      icon: Icons.verified_rounded,
    ),
    CatalogScenario(
      title: 'Error and recovery',
      description:
          'Separate the error signal from the retry cue with an intentional gap.',
      example: 'Invalid field / retry',
      icon: Icons.refresh_rounded,
    ),
    CatalogScenario(
      title: 'Async status',
      description:
          'Replay or reset a timeline when loading, completion, or cancellation changes.',
      example: 'Upload / sync / transfer',
      icon: Icons.sync_rounded,
    ),
  ],
  compositionLabel: 'Fade + Slide + Pulse',
  compositionBuilder: _sequenceComposition,
  code:
      r'''class TransferConfirmationState extends State<TransferConfirmation> {
  final motion = FluxMotionController();

  late final confirmation = SequenceSpec(
    steps: [
      MotionSequenceStep(
        effect: FadeEffect(
          const FadeSpec(duration: Duration(milliseconds: 140)),
        ),
      ),
      MotionSequenceStep(
        effect: ScaleEffect(
          const ScaleSpec(
            begin: .82,
            duration: Duration(milliseconds: 180),
          ),
        ),
      ),
      MotionSequenceStep(
        // This is a 40ms gap after Scale and before Pulse.
        delay: const Duration(milliseconds: 40),
        effect: PulseEffect(
          const PulseSpec(
            peakScale: 1.08,
            duration: Duration(milliseconds: 320),
          ),
        ),
      ),
    ],
  ); // totalDuration: 680ms

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FluxSequence(
          controller: motion,
          trigger: MotionTrigger.onTap,
          spec: confirmation,
          child: const TransferReceipt(),
        ),
        Text('${confirmation.totalDuration.inMilliseconds} ms'),
        Wrap(
          children: [
            TextButton(
              onPressed: motion.stop,
              child: const Text('Pause'),
            ),
            TextButton(
              onPressed: motion.reset,
              child: const Text('Reset'),
            ),
            FilledButton(
              onPressed: motion.replay,
              child: const Text('Replay'),
            ),
          ],
        ),
      ],
    );
  }
}''',
);

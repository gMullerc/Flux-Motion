import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

class CatalogComponentPage extends StatefulWidget {
  const CatalogComponentPage({
    super.key,
    required this.entry,
  });

  final MotionCatalogEntry entry;

  @override
  State<CatalogComponentPage> createState() => _CatalogComponentPageState();
}

class _CatalogComponentPageState extends State<CatalogComponentPage> {
  int _replayKey = 0;

  void _replay() {
    setState(() => _replayKey++);
  }

  @override
  Widget build(BuildContext context) {
    final entry = widget.entry;

    return SingleChildScrollView(
      key: PageStorageKey<String>('catalog-${entry.id}'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1120),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CatalogHero(
                entry: entry,
                replayKey: _replayKey,
                onReplay: _replay,
              ),
              const SizedBox(height: 38),
              _CatalogSectionHeader(
                eyebrow: 'EXAMPLES',
                title: 'Usage examples',
                subtitle:
                    'Live configurations that demonstrate distinct behaviors.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              KeyedSubtree(
                key: ValueKey('${entry.id}-examples-$_replayKey'),
                child: _ExampleGallery(entry: entry),
              ),
              const SizedBox(height: 42),
              _CatalogSectionHeader(
                eyebrow: 'REFERENCE',
                title: 'Parameters',
                subtitle:
                    'Public fields, types, defaults, and their responsibilities.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              _ParameterTable(entry: entry),
              const SizedBox(height: 42),
              _CatalogSectionHeader(
                eyebrow: 'TRIGGERS',
                title: 'Activation',
                subtitle:
                    'Every activation mode supported by the motion engine.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              KeyedSubtree(
                key: ValueKey('${entry.id}-triggers-$_replayKey'),
                child: _TriggerGallery(entry: entry),
              ),
              const SizedBox(height: 42),
              _CatalogSectionHeader(
                eyebrow: 'PRODUCT',
                title: 'Scenarios',
                subtitle:
                    'Common mobile situations where this motion communicates clearly.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              _ScenarioGallery(entry: entry),
              const SizedBox(height: 42),
              _CatalogSectionHeader(
                eyebrow: 'COMPOSITION',
                title: 'Combine motions',
                subtitle:
                    'A composed example that preserves the intent of each primitive.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              KeyedSubtree(
                key: ValueKey('${entry.id}-composition-$_replayKey'),
                child: _CompositionPanel(entry: entry),
              ),
              const SizedBox(height: 42),
              _CatalogSectionHeader(
                eyebrow: 'DART API',
                title: 'Implementation',
                subtitle:
                    'A minimal, copy-ready example using the public package API.',
                color: entry.color,
              ),
              const SizedBox(height: 16),
              _CodePanel(entry: entry),
              const SizedBox(height: 48),
              const _CatalogFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogHero extends StatelessWidget {
  const _CatalogHero({
    required this.entry,
    required this.replayKey,
    required this.onReplay,
  });

  final MotionCatalogEntry entry;
  final int replayKey;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return _CatalogPanel(
      padding: const EdgeInsets.all(26),
      gradient: LinearGradient(
        colors: [entry.color.withAlpha(30), CatalogColors.panel],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 720;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Wrap(
                spacing: 10,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  _CatalogTag(
                    label: 'MOTION COMPONENT / LIVE',
                    color: entry.color,
                  ),
                  _CatalogTag(label: entry.category.toUpperCase()),
                ],
              ),
              const SizedBox(height: 18),
              Text(
                entry.name,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: CatalogColors.text,
                      fontWeight: FontWeight.w900,
                      height: .98,
                      letterSpacing: -1.4,
                    ),
              ),
              const SizedBox(height: 10),
              Text(
                entry.summary,
                style: const TextStyle(
                  color: CatalogColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  height: 1.35,
                ),
              ),
              const SizedBox(height: 10),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 650),
                child: Text(
                  entry.description,
                  style: const TextStyle(
                    color: CatalogColors.muted,
                    fontSize: 14,
                    height: 1.5,
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final apiName in entry.apiLabel.split(' / '))
                    _CatalogTag(label: apiName, color: entry.color),
                  const _CatalogTag(label: 'MOBILE FIRST'),
                  const _CatalogTag(label: 'COMPOSABLE'),
                ],
              ),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Replay examples'),
                style: FilledButton.styleFrom(
                  backgroundColor: entry.color,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 13,
                  ),
                ),
              ),
            ],
          );

          final preview = KeyedSubtree(
            key: ValueKey('${entry.id}-hero-$replayKey'),
            child: entry.builder(
              MotionTrigger.onMount,
              _HeroSurface(entry: entry),
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                copy,
                const SizedBox(height: 32),
                Center(child: preview),
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 38),
              preview,
            ],
          );
        },
      ),
    );
  }
}

class _HeroSurface extends StatelessWidget {
  const _HeroSurface({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 190,
      height: 164,
      decoration: BoxDecoration(
        color: CatalogColors.canvas,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: entry.color.withAlpha(180)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(entry.icon, color: entry.color, size: 46),
          const SizedBox(height: 14),
          Text(
            entry.name.toUpperCase(),
            style: const TextStyle(
              color: CatalogColors.text,
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.6,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'LIVE PREVIEW',
            style: TextStyle(
              color: CatalogColors.muted,
              fontFamily: 'monospace',
              fontSize: 9,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExampleGallery extends StatelessWidget {
  const _ExampleGallery({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = width >= 900
            ? (width - 24) / 3
            : width >= 620
                ? (width - 12) / 2
                : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final example in entry.examples)
              SizedBox(
                width: tileWidth,
                child: _ExampleCard(entry: entry, example: example),
              ),
          ],
        );
      },
    );
  }
}

class _ExampleCard extends StatelessWidget {
  const _ExampleCard({required this.entry, required this.example});

  final MotionCatalogEntry entry;
  final CatalogExample example;

  @override
  Widget build(BuildContext context) {
    final sample = Container(
      width: example.circular ? 82 : 170,
      height: example.circular ? 82 : 76,
      decoration: BoxDecoration(
        color: entry.color.withAlpha(20),
        shape: example.circular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: example.circular ? null : BorderRadius.circular(18),
        border: Border.all(color: entry.color.withAlpha(145)),
      ),
      child: Icon(example.icon, color: entry.color, size: 30),
    );

    return _CatalogPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(example.icon, color: entry.color, size: 18),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  example.title,
                  style: const TextStyle(
                    color: CatalogColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              _CatalogTag(
                label: example.trigger.name,
                color: entry.color,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 126,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CatalogColors.canvas,
              borderRadius: BorderRadius.circular(15),
            ),
            child: example.builder(example.trigger, sample),
          ),
          const SizedBox(height: 12),
          Text(
            example.description,
            style: const TextStyle(
              color: CatalogColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            example.instruction.toUpperCase(),
            style: TextStyle(
              color: entry.color,
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: .6,
            ),
          ),
        ],
      ),
    );
  }
}

class _ParameterTable extends StatelessWidget {
  const _ParameterTable({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return _CatalogPanel(
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          for (var index = 0; index < entry.parameters.length; index++) ...[
            _ParameterRow(
              parameter: entry.parameters[index],
              color: entry.color,
            ),
            if (index != entry.parameters.length - 1)
              const Divider(height: 1, color: CatalogColors.line),
          ],
        ],
      ),
    );
  }
}

class _ParameterRow extends StatelessWidget {
  const _ParameterRow({required this.parameter, required this.color});

  final CatalogParameter parameter;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 15),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 660;
          final identity = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                parameter.name,
                style: TextStyle(
                  color: color,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                parameter.type,
                style: const TextStyle(
                  color: CatalogColors.muted,
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ],
          );
          final defaultValue = _CatalogTag(
            label: 'default  ${parameter.defaultValue}',
            color: color,
          );
          final description = Text(
            parameter.description,
            style: const TextStyle(
              color: CatalogColors.muted,
              fontSize: 12,
              height: 1.4,
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(child: identity),
                    Flexible(child: defaultValue),
                  ],
                ),
                const SizedBox(height: 10),
                description,
              ],
            );
          }

          return Row(
            children: [
              SizedBox(width: 175, child: identity),
              SizedBox(width: 225, child: defaultValue),
              Expanded(child: description),
            ],
          );
        },
      ),
    );
  }
}

class _TriggerGallery extends StatelessWidget {
  const _TriggerGallery({required this.entry});

  final MotionCatalogEntry entry;

  static const triggers = [
    (
      MotionTrigger.onMount,
      'Automatic when inserted',
      Icons.play_arrow_rounded
    ),
    (MotionTrigger.onTap, 'After a completed tap', Icons.touch_app_rounded),
    (
      MotionTrigger.onTapDown,
      'As the finger touches',
      Icons.front_hand_rounded
    ),
    (
      MotionTrigger.onTapUp,
      'As the finger releases',
      Icons.pan_tool_alt_rounded
    ),
    (
      MotionTrigger.onVisibility,
      'When the widget becomes visible',
      Icons.visibility_rounded
    ),
    (
      MotionTrigger.onScroll,
      'When descendant scrolling starts',
      Icons.swap_vert_rounded
    ),
    (
      MotionTrigger.onHover,
      'Pointer only; web and desktop',
      Icons.mouse_rounded
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = width >= 900
            ? (width - 24) / 3
            : width >= 620
                ? (width - 12) / 2
                : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final trigger in triggers)
              SizedBox(
                width: tileWidth,
                child: _TriggerCard(
                  entry: entry,
                  trigger: trigger.$1,
                  description: trigger.$2,
                  icon: trigger.$3,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _TriggerCard extends StatelessWidget {
  const _TriggerCard({
    required this.entry,
    required this.trigger,
    required this.description,
    required this.icon,
  });

  final MotionCatalogEntry entry;
  final MotionTrigger trigger;
  final String description;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final isScroll = trigger == MotionTrigger.onScroll;
    final isHover = trigger == MotionTrigger.onHover;
    final child = isScroll
        ? SizedBox(
            height: 62,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 8),
              itemBuilder: (_, index) => Container(
                width: 50,
                decoration: BoxDecoration(
                  color: entry.color.withAlpha(24 + index * 12),
                  borderRadius: BorderRadius.circular(11),
                  border: Border.all(color: entry.color.withAlpha(90)),
                ),
                child: Icon(entry.icon, color: entry.color, size: 18),
              ),
            ),
          )
        : Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: entry.color.withAlpha(20),
              border: Border.all(color: entry.color.withAlpha(130)),
            ),
            child: Icon(icon, color: entry.color, size: 26),
          );

    return _CatalogPanel(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: entry.color, size: 17),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  trigger.name,
                  style: TextStyle(
                    color: entry.color,
                    fontFamily: 'monospace',
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              if (isHover) const _CatalogTag(label: 'WEB'),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            height: 102,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: CatalogColors.canvas,
              borderRadius: BorderRadius.circular(14),
            ),
            child: entry.builder(trigger, child),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: CatalogColors.muted,
              fontSize: 11,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}

class _ScenarioGallery extends StatelessWidget {
  const _ScenarioGallery({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final tileWidth = width >= 900
            ? (width - 36) / 4
            : width >= 620
                ? (width - 12) / 2
                : width;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final scenario in entry.scenarios)
              SizedBox(
                width: tileWidth,
                child: _CatalogPanel(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(scenario.icon, color: entry.color, size: 23),
                      const SizedBox(height: 14),
                      Text(
                        scenario.title,
                        style: const TextStyle(
                          color: CatalogColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        scenario.description,
                        style: const TextStyle(
                          color: CatalogColors.muted,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                      _CatalogTag(
                        label: scenario.example,
                        color: entry.color,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _CompositionPanel extends StatelessWidget {
  const _CompositionPanel({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    final preview = entry.compositionBuilder(
      Container(
        width: 220,
        height: 110,
        decoration: BoxDecoration(
          color: CatalogColors.canvas,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: entry.color.withAlpha(150)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(entry.icon, color: entry.color, size: 32),
            const SizedBox(width: 12),
            Text(
              entry.compositionLabel.replaceAll(' + ', '\n+ '),
              style: const TextStyle(
                color: CatalogColors.text,
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );

    return _CatalogPanel(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 640;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _CatalogTag(
                label: entry.compositionLabel,
                color: entry.color,
              ),
              const SizedBox(height: 14),
              const Text(
                'Use one motion as the primary signal and the other as supporting context. Similar durations help both effects read as a single intentional transition.',
                style: TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Each effect keeps its own configuration and controller inside the shared render pipeline.',
                style: TextStyle(
                  color: entry.color,
                  fontFamily: 'monospace',
                  fontSize: 10,
                  height: 1.4,
                ),
              ),
            ],
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: preview),
                const SizedBox(height: 22),
                copy,
              ],
            );
          }

          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 30),
              preview,
            ],
          );
        },
      ),
    );
  }
}

class _CodePanel extends StatelessWidget {
  const _CodePanel({required this.entry});

  final MotionCatalogEntry entry;

  @override
  Widget build(BuildContext context) {
    return _CatalogPanel(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 11),
            child: Row(
              children: [
                Icon(Icons.code_rounded, color: entry.color, size: 18),
                const SizedBox(width: 8),
                const Text(
                  'DART / PUBLIC API',
                  style: TextStyle(
                    color: CatalogColors.muted,
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 1,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: CatalogColors.line),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(18),
            child: Text(
              entry.code,
              style: TextStyle(
                color: entry.color,
                fontFamily: 'monospace',
                fontSize: 12,
                height: 1.55,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CatalogSectionHeader extends StatelessWidget {
  const _CatalogSectionHeader({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 38,
          height: 38,
          decoration: BoxDecoration(
            color: color.withAlpha(18),
            borderRadius: BorderRadius.circular(11),
            border: Border.all(color: color.withAlpha(85)),
          ),
          child: Icon(Icons.arrow_downward_rounded, color: color, size: 17),
        ),
        const SizedBox(width: 13),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                eyebrow,
                style: TextStyle(
                  color: color,
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                title,
                style: const TextStyle(
                  color: CatalogColors.text,
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                subtitle,
                style: const TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 12,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CatalogPanel extends StatelessWidget {
  const _CatalogPanel({
    required this.child,
    this.padding = const EdgeInsets.all(18),
    this.gradient,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Gradient? gradient;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: gradient == null ? CatalogColors.panel : null,
        gradient: gradient,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: CatalogColors.line),
      ),
      child: child,
    );
  }
}

class _CatalogTag extends StatelessWidget {
  const _CatalogTag({
    required this.label,
    this.color = CatalogColors.muted,
  });

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withAlpha(15),
        borderRadius: BorderRadius.circular(100),
        border: Border.all(color: color.withAlpha(70)),
      ),
      child: Text(
        label,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: color,
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: .35,
        ),
      ),
    );
  }
}

class _CatalogFooter extends StatelessWidget {
  const _CatalogFooter();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'FLUX MOTION / COMPONENT DOCUMENTATION / MOBILE-FIRST MOTION',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: CatalogColors.muted,
          fontFamily: 'monospace',
          fontSize: 9,
          letterSpacing: 1.1,
        ),
      ),
    );
  }
}

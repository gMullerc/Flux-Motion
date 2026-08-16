import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import 'catalog_entry.dart';
import 'catalog_theme.dart';

class CatalogLandingPage extends StatefulWidget {
  const CatalogLandingPage({
    super.key,
    required this.entries,
  });

  final List<MotionCatalogEntry> entries;

  @override
  State<CatalogLandingPage> createState() => _CatalogLandingPageState();
}

class _CatalogLandingPageState extends State<CatalogLandingPage> {
  final GlobalKey _showcaseKey = GlobalKey();
  int _replayKey = 0;

  void _replay() {
    setState(() => _replayKey++);
  }

  void _showMotions() {
    final showcaseContext = _showcaseKey.currentContext;
    if (showcaseContext == null) {
      return;
    }
    Scrollable.ensureVisible(
      showcaseContext,
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeOutCubic,
      alignment: .06,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: const PageStorageKey<String>('catalog-landing'),
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 64),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1180),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _LandingHero(
                key: ValueKey('landing-hero-$_replayKey'),
                replayKey: _replayKey,
                onReplay: _replay,
                onExplore: _showMotions,
              ),
              const SizedBox(height: 18),
              _MetricStrip(componentCount: widget.entries.length),
              const SizedBox(height: 82),
              const _SectionHeading(
                eyebrow: 'BUILT FOR PRODUCT TEAMS',
                title: 'Motion with a job to do.',
                subtitle:
                    'A focused toolkit for entrances, feedback, orchestration, and navigation—designed to make mobile interfaces clearer, not noisier.',
              ),
              const SizedBox(height: 24),
              const _PrincipleGrid(),
              const SizedBox(height: 88),
              KeyedSubtree(
                key: _showcaseKey,
                child: _SectionHeading(
                  eyebrow: 'LIVE MOTION SHOWROOM',
                  title: '${widget.entries.length} motions. Tap to replay.',
                  subtitle:
                      'Every tile runs the real library API in place. Watch the entrance, tap any preview to replay it, and compare the rhythm of each motion without leaving this page.',
                  trailing: _SectionAction(
                    label: 'REPLAY ALL',
                    onTap: _replay,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              KeyedSubtree(
                key: ValueKey('showcase-grid-$_replayKey'),
                child: _ComponentGrid(entries: widget.entries),
              ),
              const SizedBox(height: 88),
              _CodeShowcase(onReplay: _replay),
              const SizedBox(height: 88),
              _FinalCallToAction(onReplay: _replay),
              const SizedBox(height: 34),
              const _LandingFooter(),
            ],
          ),
        ),
      ),
    );
  }
}

class _LandingHero extends StatelessWidget {
  const _LandingHero({
    super.key,
    required this.replayKey,
    required this.onReplay,
    required this.onExplore,
  });

  final int replayKey;
  final VoidCallback onReplay;
  final VoidCallback onExplore;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: CatalogColors.panel,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: CatalogColors.line),
        boxShadow: const [
          BoxShadow(
            color: Color(0x52000000),
            blurRadius: 42,
            offset: Offset(0, 24),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          const Positioned.fill(child: _HeroAtmosphere()),
          Padding(
            padding: const EdgeInsets.all(28),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxWidth < 820;
                final copy = _HeroCopy(
                  compact: compact,
                  onExplore: onExplore,
                  onReplay: onReplay,
                );
                final stage = _MotionStage(
                  key: ValueKey('motion-stage-$replayKey'),
                  onReplay: onReplay,
                );

                if (compact) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      copy,
                      const SizedBox(height: 38),
                      stage,
                    ],
                  );
                }

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(flex: 11, child: copy),
                    const SizedBox(width: 34),
                    Expanded(flex: 9, child: stage),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _HeroAtmosphere extends StatelessWidget {
  const _HeroAtmosphere();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            right: -90,
            top: -120,
            child: Container(
              width: 430,
              height: 430,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x38FF765D), Color(0x00FF765D)],
                ),
              ),
            ),
          ),
          Positioned(
            left: -130,
            bottom: -210,
            child: Container(
              width: 460,
              height: 460,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [Color(0x2072E2D0), Color(0x0072E2D0)],
                ),
              ),
            ),
          ),
          const Positioned.fill(
            child: CustomPaint(painter: _TechnicalGridPainter()),
          ),
        ],
      ),
    );
  }
}

class _TechnicalGridPainter extends CustomPainter {
  const _TechnicalGridPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = CatalogColors.line.withAlpha(82)
      ..strokeWidth = .6;
    const gap = 46.0;

    for (var x = 0.0; x < size.width; x += gap) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += gap) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy({
    required this.compact,
    required this.onExplore,
    required this.onReplay,
  });

  final bool compact;
  final VoidCallback onExplore;
  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return FluxStagger(
      spec: const StaggerSpec(
        interval: Duration(milliseconds: 80),
        itemDuration: Duration(milliseconds: 520),
        beginOffset: Offset(0, 24),
        fadeFrom: 0,
      ),
      children: [
        const _LiveBadge(),
        Padding(
          padding: const EdgeInsets.only(top: 24),
          child: Text(
            'Make interfaces\nfeel inevitable.',
            key: const ValueKey('landing-title'),
            style: TextStyle(
              color: CatalogColors.text,
              fontSize: compact ? 48 : 68,
              fontWeight: FontWeight.w900,
              height: .91,
              letterSpacing: compact ? -2.2 : -3.8,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 22),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 590),
            child: const Text(
              'Production-ready motion for Flutter. Built around intent, mobile ergonomics, and one predictable API—from a quiet fade to complete navigation choreography.',
              style: TextStyle(
                color: CatalogColors.muted,
                fontSize: 16,
                height: 1.55,
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 26),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _HeroPill(label: 'MOBILE FIRST', icon: Icons.smartphone_rounded),
              _HeroPill(
                label: 'ACCESSIBLE',
                icon: Icons.accessibility_new_rounded,
              ),
              _HeroPill(label: 'COMPOSABLE', icon: Icons.layers_rounded),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 30),
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              FilledButton.icon(
                key: const ValueKey('landing-explore-button'),
                onPressed: onExplore,
                icon: const Icon(Icons.arrow_forward_rounded, size: 18),
                label: const Text('See motions in action'),
                style: FilledButton.styleFrom(
                  backgroundColor: CatalogColors.coral,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 17,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ),
              OutlinedButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Replay all motions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CatalogColors.text,
                  side: const BorderSide(color: CatalogColors.line),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 17,
                  ),
                  textStyle: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LiveBadge extends StatelessWidget {
  const _LiveBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: const BoxDecoration(
            color: CatalogColors.cyan,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: CatalogColors.cyan, blurRadius: 10),
            ],
          ),
        ),
        const SizedBox(width: 9),
        const Flexible(
          child: Text(
            'FLUX MOTION / V1 CATALOG',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: CatalogColors.cyan,
              fontFamily: 'monospace',
              fontSize: 10.5,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.1,
            ),
          ),
        ),
      ],
    );
  }
}

class _HeroPill extends StatelessWidget {
  const _HeroPill({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: CatalogColors.canvas.withAlpha(172),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: CatalogColors.line),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: CatalogColors.amber),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              color: CatalogColors.text,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w800,
              letterSpacing: .8,
            ),
          ),
        ],
      ),
    );
  }
}

class _MotionStage extends StatelessWidget {
  const _MotionStage({super.key, required this.onReplay});

  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 500,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          const Positioned(
            top: 25,
            right: 18,
            child: _StageMarker(
              color: CatalogColors.amber,
              icon: Icons.auto_awesome_rounded,
              label: 'ON MOUNT',
            ),
          ),
          const Positioned(
            bottom: 38,
            left: 8,
            child: _StageMarker(
              color: CatalogColors.cyan,
              icon: Icons.touch_app_rounded,
              label: 'ON TAP',
            ),
          ),
          FluxGlow(
            spec: GlowSpec(
              radius: 34,
              spreadRadius: 5,
              color: CatalogColors.coral,
              intensity: .36,
              duration: const Duration(milliseconds: 900),
              borderRadius: BorderRadius.circular(34),
            ),
            child: Container(
              width: 278,
              height: 438,
              padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
              decoration: BoxDecoration(
                color: const Color(0xFF090D11),
                borderRadius: BorderRadius.circular(34),
                border: Border.all(color: const Color(0xFF3C484F), width: 1.3),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x88000000),
                    blurRadius: 32,
                    offset: Offset(0, 20),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 78,
                    height: 5,
                    decoration: BoxDecoration(
                      color: CatalogColors.line,
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 19),
                  const _PhoneHeader(),
                  const SizedBox(height: 18),
                  const Expanded(
                    child: FluxStagger(
                      spec: StaggerSpec(
                        interval: Duration(milliseconds: 110),
                        itemDuration: Duration(milliseconds: 480),
                        beginOffset: Offset(20, 0),
                        fadeFrom: .1,
                      ),
                      children: [
                        _PhoneCard(
                          icon: Icons.check_rounded,
                          color: CatalogColors.cyan,
                          title: 'Payment complete',
                          caption: 'Just now · Secure checkout',
                        ),
                        SizedBox(height: 10),
                        _PhoneCard(
                          icon: Icons.local_shipping_outlined,
                          color: CatalogColors.amber,
                          title: 'Order in motion',
                          caption: 'Arrives tomorrow',
                        ),
                        SizedBox(height: 10),
                        _PhoneCard(
                          icon: Icons.favorite_border_rounded,
                          color: CatalogColors.violet,
                          title: 'Saved for later',
                          caption: '3 items in your list',
                        ),
                      ],
                    ),
                  ),
                  FluxSlide(
                    spec: const SlideSpec(
                      begin: Offset(0, 18),
                      duration: Duration(milliseconds: 620),
                      curve: Curves.easeOutCubic,
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: onReplay,
                        style: FilledButton.styleFrom(
                          backgroundColor: CatalogColors.coral,
                          foregroundColor: Colors.black,
                          padding: const EdgeInsets.symmetric(vertical: 15),
                        ),
                        child: const Text(
                          'Replay motion',
                          style: TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PhoneHeader extends StatelessWidget {
  const _PhoneHeader();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'TODAY',
                style: TextStyle(
                  color: CatalogColors.coral,
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Everything flows.',
                style: TextStyle(
                  color: CatalogColors.text,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.5,
                ),
              ),
            ],
          ),
        ),
        CircleAvatar(
          radius: 18,
          backgroundColor: CatalogColors.panelRaised,
          child: Icon(Icons.bolt_rounded, color: CatalogColors.coral, size: 19),
        ),
      ],
    );
  }
}

class _PhoneCard extends StatelessWidget {
  const _PhoneCard({
    required this.icon,
    required this.color,
    required this.title,
    required this.caption,
  });

  final IconData icon;
  final Color color;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: CatalogColors.panel,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: CatalogColors.line),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: color.withAlpha(20),
              borderRadius: BorderRadius.circular(11),
            ),
            child: Icon(icon, color: color, size: 19),
          ),
          const SizedBox(width: 11),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CatalogColors.text,
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  caption,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: CatalogColors.muted,
                    fontSize: 9.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StageMarker extends StatelessWidget {
  const _StageMarker({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return FluxFade(
      spec: const FadeSpec(duration: Duration(milliseconds: 700)),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: CatalogColors.canvas,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withAlpha(130)),
          boxShadow: const [
            BoxShadow(color: Color(0x66000000), blurRadius: 18),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 14),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontFamily: 'monospace',
                fontSize: 9,
                fontWeight: FontWeight.w900,
                letterSpacing: .8,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricStrip extends StatelessWidget {
  const _MetricStrip({required this.componentCount});

  final int componentCount;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 17),
      decoration: BoxDecoration(
        color: CatalogColors.canvas,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: CatalogColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 660;
          const metrics = <_MetricData>[
            _MetricData('7', 'activation modes'),
            _MetricData('3', 'navigation APIs'),
            _MetricData('100%', 'reduced-motion aware'),
          ];
          final all = <_MetricData>[
            _MetricData('$componentCount', 'documented components'),
            ...metrics,
          ];

          if (compact) {
            return Wrap(
              spacing: 16,
              runSpacing: 20,
              children: [
                for (final metric in all)
                  SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _Metric(data: metric),
                  ),
              ],
            );
          }

          return Row(
            children: [
              for (var index = 0; index < all.length; index++) ...[
                Expanded(child: _Metric(data: all[index])),
                if (index != all.length - 1)
                  const SizedBox(
                    height: 34,
                    child: VerticalDivider(color: CatalogColors.line),
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _MetricData {
  const _MetricData(this.value, this.label);

  final String value;
  final String label;
}

class _Metric extends StatelessWidget {
  const _Metric({required this.data});

  final _MetricData data;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          data.value,
          style: const TextStyle(
            color: CatalogColors.text,
            fontSize: 22,
            fontWeight: FontWeight.w900,
            letterSpacing: -.7,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          data.label.toUpperCase(),
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: CatalogColors.muted,
            fontFamily: 'monospace',
            fontSize: 8.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .7,
          ),
        ),
      ],
    );
  }
}

class _SectionHeading extends StatelessWidget {
  const _SectionHeading({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final copy = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              eyebrow,
              style: const TextStyle(
                color: CatalogColors.coral,
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.35,
              ),
            ),
            const SizedBox(height: 11),
            Text(
              title,
              style: const TextStyle(
                color: CatalogColors.text,
                fontSize: 36,
                fontWeight: FontWeight.w900,
                height: 1,
                letterSpacing: -1.5,
              ),
            ),
            const SizedBox(height: 12),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 720),
              child: Text(
                subtitle,
                style: const TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
            ),
          ],
        );

        if (trailing == null || constraints.maxWidth < 720) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              copy,
              if (trailing != null) ...[
                const SizedBox(height: 18),
                trailing!,
              ],
            ],
          );
        }

        return Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(child: copy),
            const SizedBox(width: 24),
            trailing!,
          ],
        );
      },
    );
  }
}

class _SectionAction extends StatelessWidget {
  const _SectionAction({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton.icon(
      onPressed: onTap,
      iconAlignment: IconAlignment.end,
      icon: const Icon(Icons.arrow_forward_rounded, size: 16),
      label: Text(label),
      style: TextButton.styleFrom(
        foregroundColor: CatalogColors.coral,
        textStyle: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          fontWeight: FontWeight.w900,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _PrincipleGrid extends StatelessWidget {
  const _PrincipleGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 900
            ? 3
            : constraints.maxWidth >= 580
                ? 2
                : 1;
        final width = (constraints.maxWidth - (columns - 1) * 16) / columns;
        const cards = [
          _PrincipleCard(
            number: '01',
            color: CatalogColors.coral,
            icon: Icons.visibility_rounded,
            title: 'Reveal with restraint',
            description:
                'Fade, slide, scale, blur, glow, and shimmer make hierarchy visible without competing with content.',
            action: '6 VISUAL PRIMITIVES',
          ),
          _PrincipleCard(
            number: '02',
            color: CatalogColors.amber,
            icon: Icons.touch_app_rounded,
            title: 'Respond to intent',
            description:
                'Seven activation modes connect motion to mount, touch, hover, scroll, and visibility moments.',
            action: '7 ACTIVATION MODES',
          ),
          _PrincipleCard(
            number: '03',
            color: CatalogColors.cyan,
            icon: Icons.route_rounded,
            title: 'Choreograph the journey',
            description:
                'Sequence, stagger, routes, dialogs, and sheets coordinate transitions across complete mobile flows.',
            action: '5 FLOW TOOLS',
          ),
        ];

        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            for (final card in cards) SizedBox(width: width, child: card),
          ],
        );
      },
    );
  }
}

class _PrincipleCard extends StatelessWidget {
  const _PrincipleCard({
    required this.number,
    required this.color,
    required this.icon,
    required this.title,
    required this.description,
    required this.action,
  });

  final String number;
  final Color color;
  final IconData icon;
  final String title;
  final String description;
  final String action;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 286),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: CatalogColors.panel,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: CatalogColors.line),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: color.withAlpha(18),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const Spacer(),
              Text(
                number,
                style: TextStyle(
                  color: color,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Text(
            title,
            style: const TextStyle(
              color: CatalogColors.text,
              fontSize: 21,
              fontWeight: FontWeight.w900,
              letterSpacing: -.6,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            description,
            style: const TextStyle(
              color: CatalogColors.muted,
              fontSize: 13,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Icon(Icons.check_circle_outline_rounded, color: color, size: 15),
              const SizedBox(width: 7),
              Text(
                action,
                style: TextStyle(
                  color: color,
                  fontFamily: 'monospace',
                  fontSize: 9.5,
                  fontWeight: FontWeight.w900,
                  letterSpacing: .8,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ComponentGrid extends StatelessWidget {
  const _ComponentGrid({required this.entries});

  final List<MotionCatalogEntry> entries;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 940
            ? 3
            : constraints.maxWidth >= 590
                ? 2
                : 1;
        final width = (constraints.maxWidth - (columns - 1) * 12) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (final entry in entries)
              SizedBox(
                width: width,
                height: 268,
                child: _ComponentCard(entry: entry),
              ),
          ],
        );
      },
    );
  }
}

class _ComponentCard extends StatefulWidget {
  const _ComponentCard({required this.entry});

  final MotionCatalogEntry entry;

  @override
  State<_ComponentCard> createState() => _ComponentCardState();
}

class _ComponentCardState extends State<_ComponentCard> {
  int _replayKey = 0;

  MotionCatalogEntry get entry => widget.entry;

  void _replay() {
    setState(() => _replayKey++);
  }

  Widget _buildMotion(Widget child) {
    final motion = switch (entry.id) {
      'stagger' => FluxStagger(
          spec: const StaggerSpec(
            interval: Duration(milliseconds: 90),
            itemDuration: Duration(milliseconds: 420),
            beginOffset: Offset(0, 18),
            fadeFrom: .1,
          ),
          children: [
            for (var index = 0; index < 3; index++)
              Container(
                width: 42 + index * 13,
                height: 9,
                decoration: BoxDecoration(
                  color: entry.color.withAlpha(90 + index * 45),
                  borderRadius: BorderRadius.circular(99),
                ),
              ),
          ],
          layoutBuilder: (_, children) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var index = 0; index < children.length; index++) ...[
                children[index],
                if (index != children.length - 1) const SizedBox(height: 8),
              ],
            ],
          ),
        ),
      'page-route' => FluxSlide(
          spec: const SlideSpec(
            begin: Offset(34, 0),
            duration: Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          ),
          child: child,
        ),
      'dialog' => FluxFade(
          spec: const FadeSpec(duration: Duration(milliseconds: 260)),
          child: FluxScale(
            spec: const ScaleSpec(
              begin: .78,
              duration: Duration(milliseconds: 360),
              curve: Curves.easeOutBack,
            ),
            child: child,
          ),
        ),
      'bottom-sheet' => FluxSlide(
          spec: const SlideSpec(
            begin: Offset(0, 34),
            duration: Duration(milliseconds: 420),
            curve: Curves.easeOutCubic,
          ),
          child: child,
        ),
      _ => entry.builder(MotionTrigger.onMount, child),
    };

    return KeyedSubtree(
      key: ValueKey('${entry.id}-showcase-$_replayKey'),
      child: motion,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: CatalogColors.panel,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        key: ValueKey('landing-motion-${entry.id}'),
        onTap: _replay,
        borderRadius: BorderRadius.circular(16),
        hoverColor: entry.color.withAlpha(10),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: CatalogColors.line),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: entry.color.withAlpha(18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(entry.icon, color: entry.color, size: 19),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CatalogColors.text,
                            fontSize: 14,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.category.toUpperCase(),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: CatalogColors.muted,
                            fontFamily: 'monospace',
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: .55,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(Icons.replay_rounded, color: entry.color, size: 18),
                ],
              ),
              const SizedBox(height: 14),
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: CatalogColors.canvas,
                    borderRadius: BorderRadius.circular(13),
                    border: Border.all(color: CatalogColors.line),
                  ),
                  child: Center(
                    child: _buildMotion(
                      Container(
                        constraints: const BoxConstraints(minWidth: 116),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 13,
                        ),
                        decoration: BoxDecoration(
                          color: entry.color.withAlpha(18),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: entry.color.withAlpha(105)),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(entry.icon, color: entry.color, size: 18),
                            const SizedBox(width: 8),
                            Text(
                              'LIVE',
                              style: TextStyle(
                                color: entry.color,
                                fontFamily: 'monospace',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 11),
              Text(
                entry.summary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 11.5,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CodeShowcase extends StatelessWidget {
  const _CodeShowcase({required this.onReplay});

  final VoidCallback onReplay;

  static const _code = '''FluxSlide(
  trigger: MotionTrigger.onMount,
  spec: const SlideSpec(
    begin: Offset(0, 24),
    duration: Duration(milliseconds: 420),
    curve: Curves.easeOutCubic,
  ),
  child: const CheckoutCard(),
)''';

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(26),
      decoration: BoxDecoration(
        color: const Color(0xFF0C1014),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: CatalogColors.line),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 760;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'PREDICTABLE BY DEFAULT',
                style: TextStyle(
                  color: CatalogColors.cyan,
                  fontFamily: 'monospace',
                  fontSize: 10,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 13),
              const Text(
                'Describe the intent.\nFlux handles the timeline.',
                style: TextStyle(
                  color: CatalogColors.text,
                  fontSize: 31,
                  fontWeight: FontWeight.w900,
                  height: 1.05,
                  letterSpacing: -1.1,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                'Every motion follows the same mental model: widget, trigger, immutable spec. Compose primitives or move to orchestration without learning a different API.',
                style: TextStyle(
                  color: CatalogColors.muted,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
              const SizedBox(height: 22),
              OutlinedButton.icon(
                onPressed: onReplay,
                icon: const Icon(Icons.replay_rounded, size: 18),
                label: const Text('Replay the live motions'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: CatalogColors.cyan,
                  side: const BorderSide(color: CatalogColors.line),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 17,
                    vertical: 14,
                  ),
                ),
              ),
            ],
          );
          final code = Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: CatalogColors.canvas,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: CatalogColors.line),
            ),
            child: const SelectableText(
              _code,
              style: TextStyle(
                color: CatalogColors.text,
                fontFamily: 'monospace',
                fontSize: 12.5,
                height: 1.62,
              ),
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 28), code],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(child: copy),
              const SizedBox(width: 44),
              Expanded(child: code),
            ],
          );
        },
      ),
    );
  }
}

class _FinalCallToAction extends StatelessWidget {
  const _FinalCallToAction({required this.onReplay});

  final VoidCallback onReplay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 34),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF765D), Color(0xFFFFA15D)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 660;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BUILD THE MOMENT,\nNOT THE BOILERPLATE.',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: compact ? 28 : 36,
                  fontWeight: FontWeight.w900,
                  height: .98,
                  letterSpacing: -1.4,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Start with a primitive. Grow into a complete motion system.',
                style: TextStyle(
                  color: Color(0xC9000000),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          );
          final button = FilledButton.icon(
            onPressed: onReplay,
            icon: const Icon(Icons.replay_rounded),
            label: const Text('Replay the showcase'),
            style: FilledButton.styleFrom(
              backgroundColor: Colors.black,
              foregroundColor: CatalogColors.text,
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              textStyle: const TextStyle(fontWeight: FontWeight.w900),
            ),
          );

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [copy, const SizedBox(height: 24), button],
            );
          }

          return Row(
            children: [
              Expanded(child: copy),
              const SizedBox(width: 24),
              button,
            ],
          );
        },
      ),
    );
  }
}

class _LandingFooter extends StatelessWidget {
  const _LandingFooter();

  @override
  Widget build(BuildContext context) {
    return const Wrap(
      spacing: 12,
      runSpacing: 7,
      alignment: WrapAlignment.spaceBetween,
      children: [
        Text(
          'FLUX MOTION / FLUTTER MOTION LIBRARY',
          style: TextStyle(
            color: CatalogColors.muted,
            fontFamily: 'monospace',
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        Text(
          'MOBILE-FIRST · ACCESSIBLE · COMPOSABLE',
          style: TextStyle(
            color: CatalogColors.muted,
            fontFamily: 'monospace',
            fontSize: 9.5,
            fontWeight: FontWeight.w800,
            letterSpacing: .8,
          ),
        ),
      ],
    );
  }
}

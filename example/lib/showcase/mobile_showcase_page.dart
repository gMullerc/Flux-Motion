import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

const _ink = Color(0xFF11110F);
const _paper = Color(0xFFF3EFE5);
const _paperRaised = Color(0xFFFFFCF5);
const _coral = Color(0xFFFF6B52);
const _acid = Color(0xFFD8FF6A);
const _sky = Color(0xFF68C9FF);
const _lilac = Color(0xFFB9A6FF);
const _mutedInk = Color(0xFF6D6A63);

/// A product-style mobile experience built entirely with public Flux Motion
/// APIs. It is intentionally separate from the component documentation so it
/// can be recorded as a concise launch demo.
class MobileShowcasePage extends StatefulWidget {
  const MobileShowcasePage({super.key});

  @override
  State<MobileShowcasePage> createState() => _MobileShowcasePageState();
}

class _MobileShowcasePageState extends State<MobileShowcasePage> {
  final ScrollController _scrollController = ScrollController();
  final FluxMotionController _favoriteCounterController =
      FluxMotionController();

  var _favoriteCount = 0;
  var _sheetShown = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_handleScroll);
  }

  void _handleScroll() {
    if (_sheetShown || !_scrollController.hasClients) {
      return;
    }

    if (_scrollController.position.extentAfter <= 28) {
      _sheetShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _showRouteReadySheet();
        }
      });
    }
  }

  Future<void> _showRouteReadySheet() async {
    await showFluxBottomSheet<void>(
      context: context,
      spec: const FluxBottomSheetSpec.gentle(),
      backgroundColor: Colors.transparent,
      barrierColor: _ink.withAlpha(178),
      isScrollControlled: true,
      useSafeArea: true,
      constraints: const BoxConstraints(maxWidth: 430),
      builder: (_) => const _RouteReadySheet(),
    );
  }

  void _handleFavoriteChanged(bool selected) {
    setState(() {
      _favoriteCount += selected ? 1 : -1;
    });
    _favoriteCounterController.replay();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_handleScroll)
      ..dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: const ValueKey('mobile-showcase-page'),
      backgroundColor: _ink,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final framed = constraints.maxWidth > 520;

          return Center(
            child: Container(
              width: framed ? 430 : double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                color: _paper,
                border: framed
                    ? Border.symmetric(
                        vertical: BorderSide(color: Colors.white.withAlpha(28)),
                      )
                    : null,
                boxShadow: framed
                    ? const [
                        BoxShadow(
                          color: Color(0x99000000),
                          blurRadius: 48,
                          offset: Offset(0, 20),
                        ),
                      ]
                    : null,
              ),
              child: SafeArea(
                child: ListView(
                  key: const PageStorageKey<String>('mobile-showcase-scroll'),
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 42),
                  children: [
                    _ShowcaseTopBar(
                      favoriteCount: _favoriteCount,
                      favoriteCounterController: _favoriteCounterController,
                    ),
                    const SizedBox(height: 30),
                    FluxStagger(
                      spec: const StaggerSpec(
                        interval: Duration(milliseconds: 95),
                        itemDuration: Duration(milliseconds: 560),
                        beginOffset: Offset(0, 28),
                        fadeFrom: 0,
                      ),
                      children: [
                        const _EditorialHero(),
                        const Padding(
                          padding: EdgeInsets.only(top: 24),
                          child: _DayFilter(),
                        ),
                        for (var index = 0;
                            index < _experiences.length;
                            index++)
                          Padding(
                            padding: const EdgeInsets.only(top: 18),
                            child: _ExperienceCard(
                              key: ValueKey('showcase-card-$index'),
                              index: index,
                              experience: _experiences[index],
                              onFavoriteChanged: _handleFavoriteChanged,
                            ),
                          ),
                        const Padding(
                          padding: EdgeInsets.only(top: 30),
                          child: _EndNote(
                            key: ValueKey('mobile-showcase-end'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ShowcaseTopBar extends StatelessWidget {
  const _ShowcaseTopBar({
    required this.favoriteCount,
    required this.favoriteCounterController,
  });

  final int favoriteCount;
  final FluxMotionController favoriteCounterController;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton.filledTonal(
          key: const ValueKey('mobile-showcase-back'),
          onPressed: () => Navigator.maybePop(context),
          style: IconButton.styleFrom(
            backgroundColor: _paperRaised,
            foregroundColor: _ink,
            side: const BorderSide(color: _ink, width: 1.2),
          ),
          icon: const Icon(Icons.arrow_back_rounded, size: 20),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'DOCE ROTA',
                style: TextStyle(
                  color: _ink,
                  fontFamily: 'monospace',
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.6,
                ),
              ),
              SizedBox(height: 2),
              Text(
                'São Paulo · Fornada 04',
                style: TextStyle(
                  color: _mutedInk,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
        FluxScale(
          controller: favoriteCounterController,
          trigger: MotionTrigger.onTap,
          spec: const ScaleSpec(
            begin: .72,
            end: 1,
            duration: Duration(milliseconds: 420),
            curve: Curves.easeOutBack,
          ),
          child: Container(
            key: const ValueKey('mobile-favorite-counter'),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: _ink,
              borderRadius: BorderRadius.circular(99),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.favorite_rounded, color: _coral, size: 15),
                const SizedBox(width: 7),
                Text(
                  '$favoriteCount SALVOS',
                  key: const ValueKey('mobile-favorite-count-label'),
                  style: const TextStyle(
                    color: _paper,
                    fontFamily: 'monospace',
                    fontSize: 9,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _EditorialHero extends StatelessWidget {
  const _EditorialHero();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Expanded(child: Divider(color: _ink, thickness: 1.2)),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                'ROSQUINHAS EM MOVIMENTO',
                style: TextStyle(
                  color: _ink,
                  fontFamily: 'monospace',
                  fontSize: 9,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Expanded(child: Divider(color: _ink, thickness: 1.2)),
          ],
        ),
        const SizedBox(height: 24),
        const Text(
          'Seu sábado já está\nem movimento.',
          style: TextStyle(
            color: _ink,
            fontFamily: 'serif',
            fontSize: 47,
            fontWeight: FontWeight.w800,
            height: .9,
            letterSpacing: -2.2,
          ),
        ),
        const SizedBox(height: 18),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 9,
              height: 72,
              decoration: BoxDecoration(
                color: _coral,
                borderRadius: BorderRadius.circular(99),
              ),
            ),
            const SizedBox(width: 13),
            const Expanded(
              child: Text(
                'Quatro rosquinhas para provar sem pressa. Favorite seus sabores e deixe o Flux montar a caixa.',
                style: TextStyle(
                  color: _mutedInk,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.45,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _DayFilter extends StatelessWidget {
  const _DayFilter();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _FilterChip(label: 'TODAS', selected: true),
              _FilterChip(label: 'DOCES'),
              _FilterChip(label: 'FRUTADAS'),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          '04 SABORES',
          style: TextStyle(
            color: _mutedInk,
            fontFamily: 'monospace',
            fontSize: 9,
            fontWeight: FontWeight.w900,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, this.selected = false});

  final String label;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 9),
      decoration: BoxDecoration(
        color: selected ? _ink : Colors.transparent,
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: _ink, width: 1.1),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? _paper : _ink,
          fontFamily: 'monospace',
          fontSize: 9,
          fontWeight: FontWeight.w900,
          letterSpacing: .8,
        ),
      ),
    );
  }
}

class _ExperienceCard extends StatefulWidget {
  const _ExperienceCard({
    super.key,
    required this.index,
    required this.experience,
    required this.onFavoriteChanged,
  });

  final int index;
  final _Experience experience;
  final ValueChanged<bool> onFavoriteChanged;

  @override
  State<_ExperienceCard> createState() => _ExperienceCardState();
}

class _ExperienceCardState extends State<_ExperienceCard> {
  final FluxMotionController _favoriteController = FluxMotionController();
  final List<PulseEffect> _favoriteEffects = <PulseEffect>[
    PulseEffect(
      const PulseSpec(
        beginScale: 1,
        peakScale: 1.1,
        duration: Duration(milliseconds: 280),
        curve: Curves.easeInOut,
      ),
      activation: MotionTrigger.onScroll,
    ),
  ];
  var _favorite = false;

  void _toggleFavorite() {
    setState(() => _favorite = !_favorite);
    _favoriteController.replay();
    widget.onFavoriteChanged(_favorite);
  }

  @override
  Widget build(BuildContext context) {
    final experience = widget.experience;

    return Container(
      decoration: BoxDecoration(
        color: _paperRaised,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: _ink, width: 1.25),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1911110F),
            blurRadius: 0,
            offset: Offset(4, 5),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 174,
            child: Stack(
              fit: StackFit.expand,
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [experience.color, experience.secondaryColor],
                    ),
                  ),
                ),
                Positioned(
                  left: 18,
                  top: 10,
                  child: Text(
                    '0${widget.index + 1}',
                    style: TextStyle(
                      color: _ink.withAlpha(42),
                      fontFamily: 'serif',
                      fontSize: 92,
                      fontWeight: FontWeight.w900,
                      height: 1,
                      letterSpacing: -7,
                    ),
                  ),
                ),
                Center(
                  child: _DonutIllustration(
                    icingColor: experience.icingColor,
                    toppingColor: experience.toppingColor,
                    rotation: experience.rotation,
                  ),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: FluxPulse(
                    controller: _favoriteController,
                    // O pulso parte apenas do IconButton.onPressed. Um gatilho
                    // sem ponteiro evita uma segunda área de toque no wrapper.
                    trigger: MotionTrigger.onScroll,
                    effects: _favoriteEffects,
                    child: SizedBox.square(
                      key: ValueKey(
                        'showcase-favorite-pulse-child-${widget.index}',
                      ),
                      dimension: 58,
                      child: IconButton.filled(
                        key: ValueKey('showcase-favorite-${widget.index}'),
                        tooltip: _favorite
                            ? 'Remover dos favoritos'
                            : 'Salvar como favorito',
                        onPressed: _toggleFavorite,
                        iconSize: 27,
                        padding: EdgeInsets.zero,
                        style: IconButton.styleFrom(
                          fixedSize: const Size.square(58),
                          backgroundColor: _paperRaised,
                          foregroundColor: _ink,
                          side: const BorderSide(color: _ink, width: 1.4),
                        ),
                        icon: Icon(
                          _favorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(
                            'showcase-favorite-icon-${widget.index}-$_favorite',
                          ),
                          color: _favorite ? _coral : _ink,
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 14,
                  bottom: 14,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 11,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: _ink,
                      borderRadius: BorderRadius.circular(99),
                    ),
                    child: Text(
                      experience.time,
                      style: const TextStyle(
                        color: _paper,
                        fontFamily: 'monospace',
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: .7,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 17, 18, 19),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        experience.eyebrow,
                        style: const TextStyle(
                          color: _coral,
                          fontFamily: 'monospace',
                          fontSize: 9,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.1,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        experience.title,
                        style: const TextStyle(
                          color: _ink,
                          fontFamily: 'serif',
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                          height: 1,
                          letterSpacing: -.8,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        experience.description,
                        style: const TextStyle(
                          color: _mutedInk,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      experience.distance,
                      style: const TextStyle(
                        color: _ink,
                        fontFamily: 'monospace',
                        fontSize: 10,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Icon(Icons.arrow_outward_rounded,
                        color: _ink, size: 19),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EndNote extends StatelessWidget {
  const _EndNote({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 22),
      decoration: BoxDecoration(
        color: _ink,
        borderRadius: BorderRadius.circular(22),
      ),
      child: const Row(
        children: [
          Icon(Icons.south_rounded, color: _acid, size: 28),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Você chegou ao fim.\nSua caixa está pronta.',
              style: TextStyle(
                color: _paper,
                fontFamily: 'serif',
                fontSize: 21,
                fontWeight: FontWeight.w800,
                height: 1.05,
              ),
            ),
          ),
          Text(
            'MAIS UM\nPASSO',
            textAlign: TextAlign.right,
            style: TextStyle(
              color: _coral,
              fontFamily: 'monospace',
              fontSize: 9,
              fontWeight: FontWeight.w900,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteReadySheet extends StatefulWidget {
  const _RouteReadySheet();

  @override
  State<_RouteReadySheet> createState() => _RouteReadySheetState();
}

class _RouteReadySheetState extends State<_RouteReadySheet> {
  var _completed = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      key: const ValueKey('showcase-route-sheet'),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 22),
      decoration: const BoxDecoration(
        color: _paper,
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
        border: Border(
          top: BorderSide(color: _ink, width: 1.4),
          left: BorderSide(color: _ink, width: 1.4),
          right: BorderSide(color: _ink, width: 1.4),
        ),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 320),
        child: _completed
            ? _RouteSuccess(
                key: const ValueKey('showcase-route-success'),
                onDone: () => Navigator.pop(context),
              )
            : Column(
                key: const ValueKey('showcase-route-action'),
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 48,
                    height: 5,
                    decoration: BoxDecoration(
                      color: _ink.withAlpha(60),
                      borderRadius: BorderRadius.circular(99),
                    ),
                  ),
                  const SizedBox(height: 22),
                  const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'CAIXA PRONTA / 04 SABORES',
                              style: TextStyle(
                                color: _coral,
                                fontFamily: 'monospace',
                                fontSize: 9,
                                fontWeight: FontWeight.w900,
                                letterSpacing: 1.1,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Leve a fornada.',
                              style: TextStyle(
                                color: _ink,
                                fontFamily: 'serif',
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                height: 1,
                                letterSpacing: -1.2,
                              ),
                            ),
                          ],
                        ),
                      ),
                      _RouteBadge(),
                    ],
                  ),
                  const SizedBox(height: 18),
                  const _RouteSummary(),
                  const SizedBox(height: 20),
                  FluxGlow(
                    spec: GlowSpec(
                      color: _coral,
                      radius: 25,
                      spreadRadius: 3,
                      intensity: .7,
                      duration: const Duration(milliseconds: 920),
                      curve: Curves.easeInOut,
                      repeat: true,
                      reverse: true,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        key: const ValueKey('showcase-glowing-cta'),
                        onPressed: () => setState(() => _completed = true),
                        style: FilledButton.styleFrom(
                          backgroundColor: _ink,
                          foregroundColor: _paper,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                        icon: const Icon(Icons.auto_awesome_rounded,
                            color: _acid),
                        label: const Text(
                          'MONTAR MINHA CAIXA',
                          style: TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _RouteBadge extends StatelessWidget {
  const _RouteBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: _acid,
        shape: BoxShape.circle,
        border: Border.all(color: _ink, width: 1.2),
      ),
      child: const Icon(Icons.route_rounded, color: _ink, size: 25),
    );
  }
}

class _RouteSummary extends StatelessWidget {
  const _RouteSummary();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: _paperRaised,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: _ink.withAlpha(42)),
      ),
      child: const Row(
        children: [
          _RouteMetric(value: '04', label: 'SABORES'),
          _RouteDivider(),
          _RouteMetric(value: '12', label: 'UNIDADES'),
          _RouteDivider(),
          _RouteMetric(value: '35 MIN', label: 'ENTREGA'),
        ],
      ),
    );
  }
}

class _RouteMetric extends StatelessWidget {
  const _RouteMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: _ink,
              fontFamily: 'monospace',
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: const TextStyle(
              color: _mutedInk,
              fontFamily: 'monospace',
              fontSize: 7,
              fontWeight: FontWeight.w800,
              letterSpacing: .7,
            ),
          ),
        ],
      ),
    );
  }
}

class _RouteDivider extends StatelessWidget {
  const _RouteDivider();

  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: _ink.withAlpha(32));
  }
}

class _RouteSuccess extends StatelessWidget {
  const _RouteSuccess({super.key, required this.onDone});

  final VoidCallback onDone;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FluxBounce(
            spec: BouncePreset.success(),
            child: Container(
              width: 74,
              height: 74,
              decoration:
                  const BoxDecoration(color: _acid, shape: BoxShape.circle),
              child: const Icon(Icons.check_rounded, color: _ink, size: 38),
            ),
          ),
          const SizedBox(height: 18),
          const Text(
            'Pedido montado.',
            style: TextStyle(
              color: _ink,
              fontFamily: 'serif',
              fontSize: 32,
              fontWeight: FontWeight.w800,
              letterSpacing: -1,
            ),
          ),
          const SizedBox(height: 7),
          const Text(
            'Um pouco de motion, bem quando importa.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _mutedInk,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              key: const ValueKey('showcase-route-done'),
              onPressed: onDone,
              style: OutlinedButton.styleFrom(
                foregroundColor: _ink,
                side: const BorderSide(color: _ink, width: 1.2),
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
              child: const Text(
                'CONCLUIR',
                style: TextStyle(
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w900,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DonutIllustration extends StatelessWidget {
  const _DonutIllustration({
    required this.icingColor,
    required this.toppingColor,
    required this.rotation,
  });

  final Color icingColor;
  final Color toppingColor;
  final double rotation;

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotation,
      child: SizedBox.square(
        dimension: 106,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Transform.translate(
              offset: const Offset(7, 9),
              child: Container(
                width: 88,
                height: 88,
                decoration: const BoxDecoration(
                  color: Color(0x4411110F),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: const Color(0xFFD69A5B),
                shape: BoxShape.circle,
                border: Border.all(color: _ink, width: 1.4),
              ),
            ),
            Container(
              width: 74,
              height: 74,
              decoration: BoxDecoration(
                color: icingColor,
                shape: BoxShape.circle,
                border: Border.all(color: _ink.withAlpha(105), width: .8),
              ),
            ),
            _Sprinkle(
              top: 22,
              left: 49,
              color: toppingColor,
              angle: .3,
            ),
            _Sprinkle(
              top: 39,
              left: 23,
              color: toppingColor,
              angle: 1.2,
            ),
            _Sprinkle(
              top: 64,
              left: 40,
              color: toppingColor,
              angle: -.35,
            ),
            _Sprinkle(
              top: 52,
              left: 70,
              color: toppingColor,
              angle: .8,
            ),
            Container(
              width: 25,
              height: 25,
              decoration: BoxDecoration(
                color: _paperRaised,
                shape: BoxShape.circle,
                border: Border.all(color: _ink, width: 1.2),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Sprinkle extends StatelessWidget {
  const _Sprinkle({
    required this.top,
    required this.left,
    required this.color,
    required this.angle,
  });

  final double top;
  final double left;
  final Color color;
  final double angle;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: top,
      left: left,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          width: 5,
          height: 11,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(99),
          ),
        ),
      ),
    );
  }
}

class _Experience {
  const _Experience({
    required this.eyebrow,
    required this.title,
    required this.description,
    required this.time,
    required this.distance,
    required this.color,
    required this.secondaryColor,
    required this.icingColor,
    required this.toppingColor,
    this.rotation = 0,
  });

  final String eyebrow;
  final String title;
  final String description;
  final String time;
  final String distance;
  final Color color;
  final Color secondaryColor;
  final Color icingColor;
  final Color toppingColor;
  final double rotation;
}

const _experiences = <_Experience>[
  _Experience(
    eyebrow: 'CLÁSSICA / BAUNILHA',
    title: 'Baunilha tostada',
    description: 'Massa macia, glacê de baunilha e açúcar queimado na medida.',
    time: 'MAIS PEDIDA',
    distance: 'R\$ 12',
    color: _coral,
    secondaryColor: Color(0xFFFFB067),
    icingColor: Color(0xFFFFE8BD),
    toppingColor: _coral,
    rotation: -.08,
  ),
  _Experience(
    eyebrow: 'INTENSA / CHOCOLATE',
    title: 'Chocolate 70%',
    description:
        'Massa de cacau, cobertura amarga e pequenos cristais de caramelo.',
    time: 'NOVA FORNADA',
    distance: 'R\$ 14',
    color: _sky,
    secondaryColor: _lilac,
    icingColor: Color(0xFF57362D),
    toppingColor: _acid,
    rotation: .08,
  ),
  _Experience(
    eyebrow: 'FRUTADA / LIMÃO',
    title: 'Limão & pistache',
    description:
        'Glacê cítrico, pistache torrado e uma massa leve que derrete na boca.',
    time: 'EDIÇÃO DO MÊS',
    distance: 'R\$ 15',
    color: _acid,
    secondaryColor: Color(0xFFFFD86F),
    icingColor: Color(0xFFDDF29A),
    toppingColor: Color(0xFF477743),
    rotation: -.05,
  ),
  _Experience(
    eyebrow: 'ESPECIAL / FRAMBOESA',
    title: 'Framboesa brûlée',
    description:
        'Framboesa fresca, creme suave e uma casquinha fina de açúcar queimado.',
    time: 'ÚLTIMAS',
    distance: 'R\$ 16',
    color: _lilac,
    secondaryColor: _coral,
    icingColor: Color(0xFFFF89A9),
    toppingColor: Color(0xFFFFE8BD),
    rotation: .06,
  ),
];

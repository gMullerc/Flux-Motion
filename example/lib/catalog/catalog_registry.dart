import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

import '../showcase/mobile_showcase_page.dart';

import 'blur_catalog.dart';
import 'bottom_sheet_catalog.dart';
import 'bounce_catalog.dart';
import 'catalog_component_page.dart';
import 'catalog_entry.dart';
import 'catalog_landing_page.dart';
import 'catalog_theme.dart';
import 'dialog_catalog.dart';
import 'fade_catalog.dart';
import 'glow_catalog.dart';
import 'page_route_catalog.dart';
import 'pulse_catalog.dart';
import 'rotate_catalog.dart';
import 'scale_catalog.dart';
import 'sequence_catalog.dart';
import 'shake_catalog.dart';
import 'shimmer_catalog.dart';
import 'slide_catalog.dart';
import 'stagger_catalog.dart';

/// The single source of truth used by navigation and screen rendering.
final motionCatalogs = <MotionCatalogEntry>[
  fadeCatalog,
  slideCatalog,
  scaleCatalog,
  rotateCatalog,
  blurCatalog,
  glowCatalog,
  shimmerCatalog,
  shakeCatalog,
  pulseCatalog,
  bounceCatalog,
  sequenceCatalog,
  staggerCatalog,
  pageRouteCatalog,
  dialogCatalog,
  bottomSheetCatalog,
];

const _catalogOverviewId = 'overview';

class CatalogRenderer extends StatefulWidget {
  const CatalogRenderer({super.key});

  @override
  State<CatalogRenderer> createState() => _CatalogRendererState();
}

class _CatalogRendererState extends State<CatalogRenderer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedId = _catalogOverviewId;
  bool _reducedMotion = false;

  MotionCatalogEntry? get _selectedEntry {
    if (_selectedId == _catalogOverviewId) {
      return null;
    }
    return motionCatalogs.firstWhere((entry) => entry.id == _selectedId);
  }

  void _select(String id) {
    _scaffoldKey.currentState?.closeDrawer();
    if (_selectedId == id) {
      return;
    }
    setState(() => _selectedId = id);
  }

  void _showOverview() => _select(_catalogOverviewId);

  void _openMobileShowcase() {
    Navigator.of(context).push<void>(
      FluxPageRoute<void>(
        spec: const FluxPageRouteSpec.fadeThrough(),
        builder: (_) => const MobileShowcasePage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 540;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _CatalogDrawer(
        entries: motionCatalogs,
        selectedId: _selectedId,
        onOverview: _showOverview,
        onSelect: _select,
      ),
      appBar: AppBar(
        backgroundColor: CatalogColors.canvas,
        titleSpacing: compact ? 8 : 22,
        title: _CatalogBrand(
          compact: compact,
          onTap: _showOverview,
        ),
        actions: [
          if (compact)
            IconButton(
              key: const ValueKey('open-mobile-showcase'),
              tooltip: 'Open mobile showcase',
              onPressed: _openMobileShowcase,
              icon: const Icon(Icons.smartphone_rounded),
            )
          else
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: FilledButton.icon(
                key: const ValueKey('open-mobile-showcase'),
                onPressed: _openMobileShowcase,
                style: FilledButton.styleFrom(
                  backgroundColor: CatalogColors.coral,
                  foregroundColor: Colors.black,
                ),
                icon: const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text(
                  'MOBILE DEMO',
                  style: TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    letterSpacing: .8,
                  ),
                ),
              ),
            ),
          if (compact)
            IconButton(
              tooltip: 'Toggle reduced motion',
              onPressed: () {
                setState(() => _reducedMotion = !_reducedMotion);
              },
              icon: Icon(
                _reducedMotion
                    ? Icons.motion_photos_off_rounded
                    : Icons.motion_photos_on_rounded,
              ),
            )
          else ...[
            const Text(
              'REDUCE MOTION',
              style: TextStyle(
                color: CatalogColors.muted,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            Switch(
              value: _reducedMotion,
              onChanged: (value) {
                setState(() => _reducedMotion = value);
              },
            ),
            const SizedBox(width: 18),
          ],
        ],
      ),
      body: MediaQuery(
        data: MediaQuery.of(context).copyWith(
          disableAnimations: _reducedMotion,
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: _selectedEntry == null
              ? CatalogLandingPage(
                  key: const ValueKey('catalog-landing-page'),
                  entries: motionCatalogs,
                )
              : CatalogComponentPage(
                  key: ValueKey('catalog-page-${_selectedEntry!.id}'),
                  entry: _selectedEntry!,
                ),
        ),
      ),
    );
  }
}

class _CatalogDrawer extends StatelessWidget {
  const _CatalogDrawer({
    required this.entries,
    required this.selectedId,
    required this.onOverview,
    required this.onSelect,
  });

  final List<MotionCatalogEntry> entries;
  final String selectedId;
  final VoidCallback onOverview;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CatalogColors.canvas,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            _CatalogBrand(onTap: onOverview),
            const SizedBox(height: 32),
            _CatalogOverviewItem(
              active: selectedId == _catalogOverviewId,
              onTap: onOverview,
            ),
            const SizedBox(height: 28),
            const Text(
              'PUBLIC COMPONENTS',
              style: TextStyle(
                color: CatalogColors.coral,
                fontFamily: 'monospace',
                fontSize: 11,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.4,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Choose a component to open its examples, parameters, activation contract, and scenarios.',
              style: TextStyle(
                color: CatalogColors.muted,
                fontSize: 13,
                height: 1.45,
              ),
            ),
            const SizedBox(height: 20),
            for (var index = 0; index < entries.length; index++) ...[
              _CatalogDrawerItem(
                key: ValueKey('catalog-${entries[index].id}'),
                entry: entries[index],
                active: entries[index].id == selectedId,
                onTap: () => onSelect(entries[index].id),
              ),
              if (index != entries.length - 1) const SizedBox(height: 10),
            ],
            const SizedBox(height: 28),
            const Divider(color: CatalogColors.line),
            const SizedBox(height: 18),
            const Text(
              'CONSISTENT BY DESIGN',
              style: TextStyle(
                color: CatalogColors.text,
                fontFamily: 'monospace',
                fontSize: 10,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 9),
            const Text(
              'Every component uses the same documentation contract and the same visual renderer.',
              style: TextStyle(
                color: CatalogColors.muted,
                fontSize: 12,
                height: 1.45,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CatalogOverviewItem extends StatelessWidget {
  const _CatalogOverviewItem({
    required this.active,
    required this.onTap,
  });

  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? CatalogColors.coral.withAlpha(22) : CatalogColors.panel,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        key: const ValueKey('catalog-overview'),
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active
                  ? CatalogColors.coral.withAlpha(175)
                  : CatalogColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: CatalogColors.coral.withAlpha(18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.home_rounded,
                  color: CatalogColors.coral,
                  size: 19,
                ),
              ),
              const SizedBox(width: 11),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Overview',
                      style: TextStyle(
                        color: CatalogColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 3),
                    Text(
                      'Library introduction',
                      style: TextStyle(
                        color: CatalogColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: CatalogColors.coral,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogDrawerItem extends StatelessWidget {
  const _CatalogDrawerItem({
    super.key,
    required this.entry,
    required this.active,
    required this.onTap,
  });

  final MotionCatalogEntry entry;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: active ? entry.color.withAlpha(22) : CatalogColors.panel,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: active ? entry.color.withAlpha(175) : CatalogColors.line,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: entry.color.withAlpha(18),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(entry.icon, color: entry.color, size: 19),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      entry.name,
                      style: TextStyle(
                        color: active ? entry.color : CatalogColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      entry.category,
                      style: const TextStyle(
                        color: CatalogColors.muted,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: entry.color,
                size: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CatalogBrand extends StatelessWidget {
  const _CatalogBrand({this.compact = false, this.onTap});

  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: onTap != null,
      label: 'Flux Motion catalog overview',
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 3),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: compact ? 30 : 36,
                height: compact ? 30 : 36,
                decoration: BoxDecoration(
                  color: CatalogColors.coral,
                  borderRadius: BorderRadius.circular(compact ? 8 : 9),
                ),
                child: Icon(
                  Icons.bolt_rounded,
                  color: Colors.black,
                  size: compact ? 18 : 21,
                ),
              ),
              SizedBox(width: compact ? 9 : 12),
              Text(
                compact ? 'FLUX' : 'FLUX MOTION',
                style: const TextStyle(
                  color: CatalogColors.text,
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.05,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

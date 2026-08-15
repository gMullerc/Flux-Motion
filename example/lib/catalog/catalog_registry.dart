import 'package:flutter/material.dart';

import 'blur_catalog.dart';
import 'catalog_component_page.dart';
import 'catalog_entry.dart';
import 'catalog_theme.dart';
import 'fade_catalog.dart';
import 'glow_catalog.dart';
import 'rotate_catalog.dart';
import 'scale_catalog.dart';
import 'shimmer_catalog.dart';
import 'slide_catalog.dart';

/// The single source of truth used by navigation and screen rendering.
final motionCatalogs = <MotionCatalogEntry>[
  fadeCatalog,
  slideCatalog,
  scaleCatalog,
  rotateCatalog,
  blurCatalog,
  glowCatalog,
  shimmerCatalog,
];

class CatalogRenderer extends StatefulWidget {
  const CatalogRenderer({super.key});

  @override
  State<CatalogRenderer> createState() => _CatalogRendererState();
}

class _CatalogRendererState extends State<CatalogRenderer> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String _selectedId = motionCatalogs.first.id;
  bool _reducedMotion = false;

  MotionCatalogEntry get _selectedEntry {
    return motionCatalogs.firstWhere((entry) => entry.id == _selectedId);
  }

  void _select(String id) {
    _scaffoldKey.currentState?.closeDrawer();
    if (_selectedId == id) {
      return;
    }
    setState(() => _selectedId = id);
  }

  @override
  Widget build(BuildContext context) {
    final compact = MediaQuery.sizeOf(context).width < 540;

    return Scaffold(
      key: _scaffoldKey,
      drawer: _CatalogDrawer(
        entries: motionCatalogs,
        selectedId: _selectedId,
        onSelect: _select,
      ),
      appBar: AppBar(
        backgroundColor: CatalogColors.canvas,
        titleSpacing: compact ? 8 : 22,
        title: _CatalogBrand(compact: compact),
        actions: [
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
          child: CatalogComponentPage(
            key: ValueKey('catalog-page-${_selectedEntry.id}'),
            entry: _selectedEntry,
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
    required this.onSelect,
  });

  final List<MotionCatalogEntry> entries;
  final String selectedId;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: CatalogColors.canvas,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
          children: [
            const _CatalogBrand(),
            const SizedBox(height: 32),
            const Text(
              'MOTION COMPONENTS',
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
              'Choose a component to open its examples, parameters, triggers, and scenarios.',
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
  const _CatalogBrand({this.compact = false});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 29,
          height: 29,
          decoration: BoxDecoration(
            color: CatalogColors.coral,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.bolt_rounded, color: Colors.black, size: 18),
        ),
        const SizedBox(width: 10),
        Text(
          compact ? 'FLUX' : 'FLUX MOTION',
          style: const TextStyle(
            color: CatalogColors.text,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 1.7,
          ),
        ),
        if (!compact) ...[
          const SizedBox(width: 8),
          const Text(
            'DOCS',
            style: TextStyle(
              color: CatalogColors.coral,
              fontFamily: 'monospace',
              fontSize: 10,
              fontWeight: FontWeight.w900,
              letterSpacing: 1.2,
            ),
          ),
        ],
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

typedef CatalogMotionBuilder = Widget Function(
  MotionTrigger trigger,
  Widget child,
);

typedef CatalogCompositionBuilder = Widget Function(Widget child);

/// Complete documentation contract for one public motion component.
class MotionCatalogEntry {
  const MotionCatalogEntry({
    required this.id,
    required this.name,
    required this.category,
    required this.summary,
    required this.description,
    required this.apiLabel,
    required this.color,
    required this.icon,
    required this.builder,
    required this.examples,
    required this.parameters,
    required this.scenarios,
    required this.compositionLabel,
    required this.compositionBuilder,
    required this.code,
  });

  final String id;
  final String name;
  final String category;
  final String summary;
  final String description;
  final String apiLabel;
  final Color color;
  final IconData icon;
  final CatalogMotionBuilder builder;
  final List<CatalogExample> examples;
  final List<CatalogParameter> parameters;
  final List<CatalogScenario> scenarios;
  final String compositionLabel;
  final CatalogCompositionBuilder compositionBuilder;
  final String code;
}

class CatalogExample {
  const CatalogExample({
    required this.title,
    required this.description,
    required this.trigger,
    required this.instruction,
    required this.builder,
    required this.icon,
    this.circular = false,
  });

  final String title;
  final String description;
  final MotionTrigger trigger;
  final String instruction;
  final CatalogMotionBuilder builder;
  final IconData icon;
  final bool circular;
}

class CatalogParameter {
  const CatalogParameter({
    required this.name,
    required this.type,
    required this.defaultValue,
    required this.description,
  });

  final String name;
  final String type;
  final String defaultValue;
  final String description;
}

class CatalogScenario {
  const CatalogScenario({
    required this.title,
    required this.description,
    required this.example,
    required this.icon,
  });

  final String title;
  final String description;
  final String example;
  final IconData icon;
}

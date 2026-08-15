import 'package:flutter/material.dart';
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

typedef CatalogMotionBuilder = Widget Function(
  MotionTrigger trigger,
  Widget child,
);

typedef CatalogCompositionBuilder = Widget Function(Widget child);

typedef CatalogExamplePreviewBuilder = Widget Function(Widget child);

typedef CatalogSectionBuilder = Widget Function(Color color);

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
    required this.code,
    this.compositionLabel,
    this.compositionBuilder,
    this.activation,
    this.documentationSections = const [],
  }) : assert(
          (compositionLabel == null) == (compositionBuilder == null),
          'compositionLabel and compositionBuilder must be provided together.',
        );

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
  final String? compositionLabel;
  final CatalogCompositionBuilder? compositionBuilder;
  final CatalogCustomSection? activation;
  final List<CatalogDocumentationSection> documentationSections;
  final String code;
}

class CatalogExample {
  const CatalogExample({
    required this.title,
    required this.description,
    required this.instruction,
    required this.icon,
    this.trigger,
    this.builder,
    this.previewBuilder,
    this.badge,
    this.circular = false,
  }) : assert(
          builder != null || previewBuilder != null,
          'An example needs a motion builder or a custom preview builder.',
        );

  final String title;
  final String description;
  final MotionTrigger? trigger;
  final String instruction;
  final CatalogMotionBuilder? builder;
  final CatalogExamplePreviewBuilder? previewBuilder;
  final String? badge;
  final IconData icon;
  final bool circular;
}

class CatalogCustomSection {
  const CatalogCustomSection({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.builder,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final CatalogSectionBuilder builder;
}

class CatalogDocumentationSection {
  const CatalogDocumentationSection({
    required this.eyebrow,
    required this.title,
    required this.subtitle,
    required this.items,
  });

  final String eyebrow;
  final String title;
  final String subtitle;
  final List<CatalogDocumentationItem> items;
}

class CatalogDocumentationItem {
  const CatalogDocumentationItem({
    required this.title,
    required this.description,
    required this.label,
    required this.icon,
  });

  final String title;
  final String description;
  final String label;
  final IconData icon;
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

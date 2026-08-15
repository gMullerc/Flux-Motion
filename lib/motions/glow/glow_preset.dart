import 'package:flutter/material.dart';

import 'glow_spec.dart';

/// Ready-to-use glow configurations.
class GlowPreset {
  const GlowPreset._();

  static GlowSpec soft({
    Color color = Colors.white,
    double intensity = 0.55,
  }) {
    return GlowSpec(
      color: color,
      radius: 18,
      intensity: intensity,
      duration: const Duration(milliseconds: 700),
    );
  }

  static GlowSpec neon({
    Color color = Colors.cyan,
    double intensity = 0.85,
  }) {
    return GlowSpec(
      color: color,
      radius: 24,
      spreadRadius: 1,
      intensity: intensity,
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
    );
  }

  static GlowSpec pulse({
    Color color = Colors.amber,
    double intensity = 0.8,
    BoxShape shape = BoxShape.rectangle,
  }) {
    return GlowSpec(
      color: color,
      radius: 20,
      intensity: intensity,
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeInOut,
      repeat: true,
      shape: shape,
    );
  }
}

import 'package:flutter/material.dart';

class CatalogColors {
  static const canvas = Color(0xFF080A0D);
  static const panel = Color(0xFF10151A);
  static const panelRaised = Color(0xFF171D23);
  static const line = Color(0xFF29343C);
  static const text = Color(0xFFF4F0E8);
  static const muted = Color(0xFF98A4AA);
  static const coral = Color(0xFFFF765D);
  static const cyan = Color(0xFF72E2D0);
  static const amber = Color(0xFFFFC66D);
  static const violet = Color(0xFFBDA7FF);
  static const blue = Color(0xFF82B7FF);

  const CatalogColors._();
}

ThemeData buildCatalogTheme() {
  return ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: CatalogColors.canvas,
    colorScheme: ColorScheme.fromSeed(
      seedColor: CatalogColors.coral,
      brightness: Brightness.dark,
      surface: CatalogColors.panel,
    ),
    useMaterial3: true,
    dividerColor: CatalogColors.line,
  );
}

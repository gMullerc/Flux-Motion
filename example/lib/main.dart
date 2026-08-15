import 'package:flutter/material.dart';

import 'catalog/catalog_registry.dart';
import 'catalog/catalog_theme.dart';

void main() {
  runApp(const FluxMotionPreviewApp());
}

class FluxMotionPreviewApp extends StatelessWidget {
  const FluxMotionPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flux Motion Documentation',
      debugShowCheckedModeBanner: false,
      theme: buildCatalogTheme(),
      home: const CatalogRenderer(),
    );
  }
}

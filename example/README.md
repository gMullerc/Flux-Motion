# Flux Motion Catalog

Documentação visual e interativa dos componentes públicos de Flux Motion.

```text
flutter pub get
flutter run -d chrome
```

Cada componente é declarado em um arquivo dentro de `lib/catalog/`. O registro
central em `catalog_registry.dart` instancia essas definições e o renderer
compartilhado garante a mesma estrutura para exemplos, parâmetros, triggers,
cenários e implementação.

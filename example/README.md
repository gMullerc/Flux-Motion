# Flux Motion Catalog

Interactive visual documentation for every public Flux Motion component.

```text
flutter pub get
flutter run -d chrome
```

Each component is declared in its own file under `lib/catalog/`. The central
`catalog_registry.dart` registry instantiates these definitions, while the
shared renderer keeps examples, parameters, triggers, scenarios, and
implementation guidance consistent.

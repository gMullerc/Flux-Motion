# Flux Motion

[![pub package](https://img.shields.io/pub/v/flutter_flux_motion.svg)](https://pub.dev/packages/flutter_flux_motion)
[![license: BSD-3-Clause](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](LICENSE)

Declarative, mobile-first motion for Flutter. Apply polished animation to any
widget without spreading `AnimationController`, listeners, and lifecycle logic
through your application.

[![Flux Motion catalog](https://raw.githubusercontent.com/gMullerc/Flux-Motion/main/example/web/fluxmotions-thumbnail.png)](https://gmullerc.github.io/Flux-Motion/)

## Install

```console
flutter pub add flutter_flux_motion
```

```dart
import 'package:flutter_flux_motion/flutter_flux_motion.dart';
```

## Quick start

Every motion wraps an ordinary Flutter widget. Configure its behavior with an
immutable spec and choose when it starts with `MotionTrigger`.

```dart
FluxSlide(
  trigger: MotionTrigger.onMount,
  spec: const SlideSpec(
    begin: Offset(0, 24),
    duration: Duration(milliseconds: 480),
    curve: Curves.easeOutCubic,
  ),
  child: const Card(
    child: Padding(
      padding: EdgeInsets.all(16),
      child: Text('Ready to move'),
    ),
  ),
)
```

## Interaction and imperative playback

Motions can start on mount, tap, tap down, tap up, hover, scroll, or visibility.

```dart
FluxGlow(
  trigger: MotionTrigger.onTap,
  spec: const GlowSpec(
    color: Color(0xFF8B5CF6),
    radius: 24,
    spreadRadius: 3,
  ),
  child: const Icon(Icons.favorite, size: 44),
)
```

Use `FluxMotionController` when product state, validation, or an asynchronous
result should control playback.

```dart
final motion = FluxMotionController();

FluxShake(
  controller: motion,
  child: const TextField(),
)

// For example, after invalid form submission:
motion.replay();
```

The controller exposes `play()`, `stop()`, `reset()`, and `replay()` and attaches
to one motion widget at a time.

## Orchestration

Use `FluxSequence` for ordered effects and `FluxStagger` for coordinated lists
or groups. Both own their timeline and support the same interaction triggers and
imperative controller.

```dart
FluxStagger(
  spec: const StaggerSpec(
    interval: Duration(milliseconds: 70),
    beginOffset: Offset(0, 18),
  ),
  children: const [
    ListTile(title: Text('Profile')),
    ListTile(title: Text('Notifications')),
    ListTile(title: Text('Security')),
  ],
)
```

## Navigation motion

Flux Motion integrates with Flutter's native navigator, dialogs, and Material
bottom sheets.

```dart
final result = await Navigator.of(context).push<String>(
  FluxPageRoute(
    spec: const FluxPageRouteSpec.sharedAxis(),
    builder: (_) => const CheckoutPage(),
  ),
);
```

Use `showFluxDialog` and `showFluxBottomSheet` for typed results, native
barriers and gestures, and consistent transition timing.

## Available APIs

| Category | APIs |
| --- | --- |
| Essential motion | `FluxFade`, `FluxSlide`, `FluxScale`, `FluxRotate`, `FluxBlur` |
| Feedback and emphasis | `FluxGlow`, `FluxShimmer`, `FluxShake`, `FluxPulse`, `FluxBounce` |
| Orchestration | `FluxSequence`, `FluxStagger` |
| Navigation | `FluxPageRoute`, `showFluxDialog`, `showFluxBottomSheet` |
| Control | `MotionTrigger`, `FluxMotionController`, `FluxMotion` |

All widget and navigation motions honor Flutter's reduced-motion setting via
`MediaQuery.disableAnimations`.

## Interactive catalog

The [Flux Motion catalog](https://gmullerc.github.io/Flux-Motion/) documents each
public component with live examples, parameters, activation modes, mobile
scenarios, composition guidance, and copy-ready Dart code.

To run the catalog locally:

```console
cd example
flutter run -d chrome
```

## Development

```console
flutter pub get
flutter analyze
flutter test
```

Architecture and testing principles live in the
[`docs/` directory](https://github.com/gMullerc/Flux-Motion/tree/main/docs).
Contributions and real-world motion scenarios are welcome through the
[issue tracker](https://github.com/gMullerc/Flux-Motion/issues).

## License

Flux Motion is available under the [BSD 3-Clause License](LICENSE).

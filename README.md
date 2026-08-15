# Flux Motion

Biblioteca Flutter para aplicar motion declarativo a qualquer widget sem
espalhar `AnimationController`, listeners e lógica de lifecycle pela aplicação.

```dart
import 'package:flutter_flux_motion/flutter_flux_motion.dart';

FluxSlide(
  spec: const SlideSpec(
    begin: Offset(0, 24),
    duration: Duration(milliseconds: 480),
  ),
  child: const ResultCard(),
)
```

## Componentes disponíveis

| Componente | Responsabilidade |
| --- | --- |
| `FluxFade` | Transições de opacidade |
| `FluxSlide` | Movimento entre offsets em pixels lógicos |
| `FluxScale` | Ênfase, entrada e resposta ao toque |
| `FluxRotate` | Rotação em graus mantendo o widget no lugar |
| `FluxBlur` | Transições entre foco suave e nítido |
| `FluxGlow` | Halo animado ao redor do widget completo |
| `FluxShimmer` | Faixa de luz animada para loading e destaque |
| `FluxShake` | Feedback corretivo por oscilação horizontal ou vertical |
| `FluxPulse` | Ênfase e status por pulsação de escala |
| `FluxBounce` | Feedback expressivo com deslocamento e acomodação |
| `FluxSequence` | Timeline declarativa de effects executados em ordem |
| `FluxStagger` | Entrada coordenada de grupos com intervalo entre itens |

Todos os componentes respeitam `MediaQuery.disableAnimations` e compartilham o
mesmo contrato de ativação por `onMount`, `onTap`, `onTapDown`, `onTapUp`,
`onHover`, `onScroll` ou `onVisibility`. Motions de um único widget usam a
engine comum; orquestradores coordenam a timeline sem expor tickers.

Os componentes `Flux*` aceitam um `FluxMotionController` para controle
imperativo com `play()`, `stop()`, `reset()` e `replay()`. Isso permite
coordenar motions e timelines com o estado do produto sem expor
`AnimationController` ao aplicativo.

## Catálogo visual

O projeto em `example/` funciona como documentação interativa. Cada motion
possui uma página própria com:

- exemplos animados;
- parâmetros, tipos e valores padrão;
- formas de ativação;
- cenários de uso mobile;
- composição com outros motions;
- código Dart pronto para copiar.

Para executar:

```text
cd example
flutter run -d chrome
```

## Desenvolvimento

```text
flutter pub get
flutter test
flutter analyze
```

Veja [docs/ARCHITECTURE.md](docs/ARCHITECTURE.md) para os contratos da engine,
[docs/OVERVIEW.md](docs/OVERVIEW.md) para uma visão geral da biblioteca e
[docs/TESTING.md](docs/TESTING.md) para os critérios obrigatórios de testes por
cenários reais de widget.

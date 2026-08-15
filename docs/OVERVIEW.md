# Visão geral do Flux Motion

Flux Motion é uma biblioteca Flutter de motion design declarativo. Ela envolve
widgets existentes e centraliza animação, triggers e lifecycle em uma engine
comum.

```dart
FluxScale(
  trigger: MotionTrigger.onTapDown,
  spec: const ScaleSpec(
    begin: 1,
    end: .96,
    duration: Duration(milliseconds: 120),
  ),
  child: const PrimaryButton(),
)
```

## Objetivos

- Aplicar motion sobre qualquer `Widget` sem alterar sua implementação.
- Reduzir boilerplate de controllers, listeners e dispose.
- Oferecer uma API previsível entre componentes diferentes.
- Permitir composição por meio de um pipeline ordenado de effects.
- Respeitar as preferências de redução de movimento do sistema.

## API pública atual

| Motion | Uso principal |
| --- | --- |
| Fade | Entrada, saída e mudanças de estado por opacidade |
| Slide | Direção, navegação e entrada de listas |
| Scale | Ênfase, confirmação e feedback de toque |
| Rotate | Estado, refresh e processamento por ângulo |
| Blur | Privacidade, foco e revelação de conteúdo |
| Glow | Status, seleção e destaque por halo externo |
| Shimmer | Loading, skeleton e destaque por faixa de luz |
| Shake | Erro, rejeição e atenção por oscilação controlada |
| Pulse | Ênfase, toque e status por pulsação de escala |
| Bounce | Sucesso, notificação e reação por deslocamento elástico |

Cada módulo contém seu próprio `Spec`, `Effect`, `Render` e componente
ergonômico `Flux*`. Glow, Shimmer, Shake, Pulse e Bounce também disponibilizam
presets prontos para os cenários mobile mais recorrentes.

## Fluxo em runtime

```text
Widget do app
  → componente Flux + spec
  → FluxMotion
  → MotionEngine
  → pipeline de MotionRender
  → widget animado
```

A engine não conhece efeitos concretos. Cada effect produz seu render e o
`FluxWrapper` aplica a lista na ordem declarada.

## Ativação

Os componentes compartilham os triggers `onMount`, `onTap`, `onTapDown`,
`onTapUp`, `onHover`, `onScroll` e `onVisibility`.

## Catálogo

O app em `example/` é a documentação visual da biblioteca. As definições ficam
em `example/lib/catalog/`, uma por componente, e são renderizadas por um
template compartilhado. Isso mantém exemplos, parâmetros, cenários e código
consistentes conforme a biblioteca cresce.

Cada página documenta o comportamento do motion, seus parâmetros, triggers,
cenários reais, composição e um exemplo Dart copiável. Shake, Pulse e Bounce
usam páginas independentes, assim como os demais componentes públicos.

Para detalhes internos, veja [ARCHITECTURE.md](ARCHITECTURE.md).

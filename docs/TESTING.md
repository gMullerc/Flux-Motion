# Estratégia de testes

Os testes de um motion devem provar o comportamento que uma pessoa realmente
encontra no aplicativo. Cobertura de linhas, teste isolado de `Spec` ou chamada
direta de `tick()` são verificações complementares; sozinhos, não aprovam um
componente público.

## Caminho obrigatório do widget

Cada motion público deve ter testes que:

1. montem o componente `Flux*` completo dentro de `MaterialApp` ou de uma
   árvore equivalente com `MediaQuery`;
2. usem um `child` identificável por `Key`;
3. acionem o motion pelo trigger público configurado;
4. avancem o tempo com `WidgetTester.pump`;
5. observem o resultado produzido na árvore renderizada ou no effect que foi
   conectado à engine pelo widget.

Para triggers de interação, o teste deve executar o gesto correspondente. Um
teste de `onTap`, por exemplo, usa `tester.tap`; ele não chama `play()` ou
`tick()` diretamente.

## Cenários mínimos por motion

Um novo motion deve validar, quando aplicável:

- o estado de repouso antes da ativação;
- um frame intermediário visivelmente diferente;
- o estado final ou retorno ao repouso;
- a ativação por gesto real;
- uma configuração ou preset representativo de uso mobile;
- uma segunda ativação depois que a primeira terminou;
- `MediaQuery.disableAnimations = true`;
- preservação do `child` e ausência de exceções durante dispose.

Motions contínuos também devem provar que repetem sem criar controllers extras
ou deixar tickers ativos após a remoção do widget.

## Orquestração

Testes de `FluxSequence` devem montar o widget público, avançar a timeline e
provar a ordem observável das etapas com effects reais de tipos diferentes.
Testes de `FluxStagger` devem renderizar um grupo real e provar que os itens
iniciam no intervalo e na ordem configurados.

Quando `FluxMotionController` estiver presente, o teste deve chamar `play`,
`stop`, `reset` e `replay` pelo controller conectado ao widget e observar o
resultado na árvore. A remoção do componente precisa encerrar tickers e tornar
comandos posteriores seguros, sem exceções.

## Testes matemáticos

Specs, asserts, renders e interpolação podem ser testados isoladamente quando
isso documenta uma regra importante, como direção, limite ou geometria. Esses
testes não substituem o cenário do widget e não devem reproduzir a própria
implementação como expectativa.

## Catálogo

Todo motion público precisa de uma página própria no catálogo. O smoke test do
`example` deve garantir que a entrada existe, possui exemplos, parâmetros,
cenários e pode ser renderizada em viewport mobile.

## Critério de conclusão

Um motion só está pronto quando componente, testes de widget e documentação
visual são entregues juntos e `flutter test` e `flutter analyze` passam tanto
no package quanto no `example`.

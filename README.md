# NewsApp

Aplicativo para consultar notícias e categorias.

## Stack e organização
Flutter/Dart, ValueNotifier, http e intl.

Notícias e favoritos ficam em features próprias; transporte HTTP em core. Repositório, estado e tela têm responsabilidades separadas. GetX foi substituído por ValueNotifier para evitar dois mecanismos de estado. Favoritos usam identidade da notícia, e respostas antigas não sobrescrevem a categoria atual.

## Executar
Use a versão de Flutter registrada em `.github/workflows/ci.yml`.
```sh
git clone https://github.com/FloraRosaPupo/NewsApp.git
cd NewsApp
flutter pub get
flutter run --dart-define=GNEWS_API_KEY=SUA_CHAVE
```

## Verificações
```sh
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
```
A CI verifica erros de análise e os testes. Avisos e sugestões continuam visíveis no relatório do analisador. Testes locais não substituem a validação no dispositivo e dos serviços externos.

## Contribuir
Abra uma branch por alteração, descreva o comportamento esperado e inclua testes para regras ou regressões. Mantenha credenciais e arquivos gerados fora do Git.

## Licença
Não há licença de distribuição definida neste repositório.


## Funcionalidades

- Notícias por categoria.
- detalhes.
- favoritos em memória.


## Configuração da API

Execute com `flutter run --dart-define=GNEWS_API_KEY=SUA_CHAVE`. A chave antiga foi removida do código e deve ser revogada no provedor. Uma chave embarcada em aplicativo cliente continua extraível; restrinja uso e quota no provedor. Não inclua chaves privilegiadas no aplicativo.


## Organização e manutenção

Notícias e favoritos ficam em features próprias; transporte HTTP em core. Repositório, estado e tela têm responsabilidades separadas. GetX foi substituído por ValueNotifier para evitar dois mecanismos de estado. Favoritos usam identidade da notícia, e respostas antigas não sobrescrevem a categoria atual.

Veja [a revisão de desenvolvimento](docs/REVISAO.md) para decisões, testes e limites, e [o guia de contribuição](CONTRIBUTING.md) para o fluxo de manutenção.

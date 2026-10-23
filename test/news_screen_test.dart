import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:newa/features/news/data/newsRepository.dart';
import 'package:newa/features/news/domain/newsModel.dart';
import 'package:newa/features/news/presentation/homePage.dart';
import 'package:newa/features/favorites/presentation/favoritesPage.dart';
import 'package:newa/features/favorites/presentation/favorites_controller.dart';

class ScreenRepository implements INewsRepository {
  final requests = <Completer<List<NewsModel>>>[];
  @override
  Future<List<NewsModel>> getNews(String category) {
    final result = Completer<List<NewsModel>>();
    requests.add(result);
    return result.future;
  }
}

void main() {
  testWidgets('categoria permite recuperar consulta que falhou',
      (tester) async {
    final repo = ScreenRepository();
    await tester.pumpWidget(MaterialApp(home: HomePage(repository: repo)));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    repo.requests.single.completeError(StateError('offline'));
    await tester.pumpAndSettle();
    expect(find.textContaining('offline'), findsOneWidget);
    await tester.tap(find.text('Geral'));
    await tester.pump();
    expect(find.textContaining('offline'), findsNothing);
    repo.requests.last.complete([]);
    await tester.pumpAndSettle();
    expect(find.text('Nenhum item na lista'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('remover último favorito atualiza a tela', (tester) async {
    final favorites = FavoritesController();
    addTearDown(favorites.dispose);
    favorites.toggle(NewsModel.fromMap(
        {'title': 'Notícia', 'url': 'https://example.com/a'}));
    await tester
        .pumpWidget(MaterialApp(home: FavoritesPage(favorites: favorites)));
    expect(find.text('Notícia'), findsOneWidget);
    await tester.tap(find.byTooltip('Remover dos favoritos'));
    await tester.pump();
    expect(find.text('Nenhuma notícia foi favoritada'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}

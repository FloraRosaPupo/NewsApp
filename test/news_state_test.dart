import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:newa/features/news/data/newsRepository.dart';
import 'package:newa/features/news/domain/newsModel.dart';
import 'package:newa/features/news/presentation/stores/newsStores.dart';
import 'package:newa/features/favorites/presentation/favorites_controller.dart';

class FakeRepository implements INewsRepository {
  final requests = <String, Completer<List<NewsModel>>>{};
  @override
  Future<List<NewsModel>> getNews(String category) =>
      (requests[category] = Completer<List<NewsModel>>()).future;
}

void main() {
  test('resposta antiga não sobrescreve a categoria atual', () async {
    final repo = FakeRepository();
    final store = NewsStores(repository: repo);
    addTearDown(store.dispose);
    final old = store.getNews('old');
    final latest = store.getNews('new');
    repo.requests['new']!.complete([
      NewsModel.fromMap({'title': 'Atual'})
    ]);
    await latest;
    repo.requests['old']!.complete([
      NewsModel.fromMap({'title': 'Antiga'})
    ]);
    await old;
    expect(store.state.value.single.title, 'Atual');
    expect(store.isLoading.value, false);
  });
  test('nova tentativa limpa o erro anterior', () async {
    final repo = FakeRepository();
    final store = NewsStores(repository: repo);
    addTearDown(store.dispose);
    final failed = store.getNews('a');
    repo.requests['a']!.completeError(StateError('offline'));
    await failed;
    expect(store.error.value, isNotEmpty);
    final retry = store.getNews('b');
    expect(store.error.value, isEmpty);
    repo.requests['b']!.complete([]);
    await retry;
    expect(store.isLoading.value, false);
  });
  test(
      'favoritos usam identidade da notícia, independentemente da lista recebida',
      () {
    final favorites = FavoritesController();
    addTearDown(favorites.dispose);
    final first = NewsModel.fromMap({'url': 'https://example.com/a'});
    favorites.toggle(first);
    final reloaded = NewsModel.fromMap({'url': first.url});
    expect(favorites.contains(reloaded), true);
    favorites.toggle(reloaded);
    expect(favorites.value, isEmpty);
  });
}

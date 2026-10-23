import 'package:flutter/material.dart';
import 'package:newa/core/http/httpClient.dart';
import 'package:newa/features/news/data/newsRepository.dart';
import 'package:newa/features/news/domain/categoryMap.dart';
import 'package:newa/features/favorites/presentation/favoritesPage.dart';
import 'package:newa/features/favorites/presentation/favorites_controller.dart';
import 'stores/newsStores.dart';
import 'widgets/gridNews.dart';

class HomePage extends StatefulWidget {
  final INewsRepository? repository;
  const HomePage({super.key, this.repository});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  HttpClient? _client;
  late final NewsStores store;
  final favorites = FavoritesController();
  String selectedCategory = 'Geral';
  @override
  void initState() {
    super.initState();
    final repository =
        widget.repository ?? NewsRepository(client: _client = HttpClient());
    store = NewsStores(repository: repository);
    store.getNews(categoryMap[selectedCategory]!);
  }

  @override
  void dispose() {
    store.dispose();
    favorites.dispose();
    _client?.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('News App'), actions: [
          IconButton(
              tooltip: 'Notícias Curtidas',
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (_) => FavoritesPage(favorites: favorites)));
              }),
        ]),
        body: Column(children: [
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(children: [
                for (final category in listCategory)
                  TextButton(
                    onPressed: () {
                      setState(() => selectedCategory = category);
                      store.getNews(categoryMap[category]!);
                    },
                    child: Text(category,
                        style: TextStyle(
                            fontWeight: category == selectedCategory
                                ? FontWeight.bold
                                : FontWeight.normal)),
                  ),
              ])),
          Expanded(child: GridNews(store: store, favorites: favorites)),
        ]),
      );
}

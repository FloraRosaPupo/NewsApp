import 'package:flutter/material.dart';
import 'favorites_controller.dart';
import '../../news/presentation/newPage.dart';

class FavoritesPage extends StatelessWidget {
  final FavoritesController favorites;
  const FavoritesPage({super.key, required this.favorites});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('News Favoritas')),
        body: ValueListenableBuilder(
          valueListenable: favorites,
          builder: (context, news, _) => news.isEmpty
              ? const Center(child: Text('Nenhuma notícia foi favoritada'))
              : ListView.builder(
                  itemCount: news.length,
                  itemBuilder: (context, index) => ListTile(
                        onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (_) => NewPage(item: news[index]))),
                        title: Text(news[index].title),
                        trailing: IconButton(
                            icon: const Icon(Icons.favorite),
                            tooltip: 'Remover dos favoritos',
                            onPressed: () => favorites.toggle(news[index])),
                      )),
        ),
      );
}

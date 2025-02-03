import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newa/data/controllers/newsControllers.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({
    super.key,
    required this.newsList,
    required this.isFavoriteList,
  });

  final List<String> newsList; // Lista de notícias
  final List<bool> isFavoriteList; // Lista de favoritos

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {

  late Newscontrollers newscontrollers = Get.put(Newscontrollers());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back_ios_new),
        ),
        title: Text('News Favoritas'),
      ),
      body: newscontrollers.favoriteNews.isNotEmpty
          ? ListView.builder(
              itemCount: newscontrollers.favoriteNews.length,
              itemBuilder: (BuildContext context, int index) {
                final news = newscontrollers.favoriteNews[index];
                return ListTile(
                  title: Text(news.title),
                  trailing: Icon(
                    Icons.favorite,
                    color: Colors.black,
                  ),
                );
              },
            )
          : Center(
              child: Text('Nenhuma notícia foi favoritada'),
            ),
    );
  }
}

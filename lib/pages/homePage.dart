import 'package:flutter/material.dart';
import 'package:newa/data/http/httpClient.dart';
import 'package:newa/data/repositories/newsRepository.dart';
import 'package:newa/pages/components/gridNews.dart';
import 'package:newa/pages/favoritesPage.dart';
import 'package:newa/pages/stores/newsStores.dart';
import 'package:newa/utils/categoryMap.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //estancia do Store
  final NewsStores store = NewsStores(
    repository: NewsRepository(
      client: HttpClient(),
    ),
  );

  late List<bool> isFavoriteList = [];
  String selectedCategory = 'Geral';

  @override
  //initState é chamado quando o widget é inserido na árvore de widgets
  //e é o lugar ideal para inicializar variáveis e fazer chamadas de rede.
  void initState() {
    super.initState();
    // Inicializa a lista de favoritos com false para todas as notícias
    store.getNews(categoryMap[selectedCategory]!).then((_) {
      setState(() {
        isFavoriteList = List<bool>.filled(store.state.value.length, false);
      });
    });
  }

  void toggleFavorite(int index) {
    setState(() {
      isFavoriteList[index] = !isFavoriteList[index];
    });
  }

  void selectCategory(String category) {
    setState(() {
      selectedCategory = category;
    });
    filterNewsByCategory(categoryMap[category]!);
  }

  void filterNewsByCategory(String category) {
    store.getNews(category);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News App'),
        actions: <Widget>[
          IconButton(
              tooltip: 'Notícias Curtidas',
              icon: const Icon(Icons.favorite_border),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => FavoritesPage(
                      isFavoriteList: isFavoriteList,
                      newsList: store.state.value
                          .asMap()
                          .entries
                          .where((entry) => isFavoriteList[entry.key])
                          .map((entry) => entry.value.title)
                          .toList(),
                    ),
                  ),
                );
              }),
        ],
      ),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (var i = 0; i < listCategory.length; i++)
                    TextButton(
                      onPressed: () {
                        selectCategory(listCategory[i]);
                      },
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) {
                          return i == listCategory[i]
                              ? Colors.transparent
                              : Colors.purple.withOpacity(0.2);
                        }),
                      ),
                      child: Text(
                        '${listCategory[i]}',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: selectedCategory == listCategory[i]
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: GridNews(
              store: store,
              isFavoriteList: isFavoriteList,
              toggleFavorite: toggleFavorite,
            ),
          ),
        ],
      ),
    );
  }
}
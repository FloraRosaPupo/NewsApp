import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:newa/data/controllers/newsControllers.dart';
import 'package:newa/data/http/httpClient.dart';
import 'package:newa/data/repositories/newsRepository.dart';
import 'package:newa/pages/components/gridNews.dart';
import 'package:newa/pages/favoritesPage.dart';
import 'package:newa/pages/newPage.dart';
import 'package:newa/pages/stores/newsStores.dart';

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
      category: 'general',
    ),
  );

  List<String> listCategory = ['Geral', 'Mundo', 'Nação', 'Negócios', 'Tecnologia', 'Entretenimento', 'Esportes', 'Ciência', 'Saúde'];  
  late List<bool> isFavoriteList = [];
  String selectedCategory = 'Geral';

  @override
  void initState() {
    super.initState();
    store.getNews();
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
    // Aqui você pode adicionar lógica para filtrar as notícias com base na categoria selecionada
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
            child:SingleChildScrollView(child: Row(
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
            ),),
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

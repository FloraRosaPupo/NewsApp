import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newa/pages/newPage.dart';
import 'package:newa/pages/stores/newsStores.dart';
import 'package:newa/data/controllers/newsControllers.dart';
import 'package:get/get.dart';


class GridNews extends StatelessWidget {
  final NewsStores store;
  late List<bool> isFavoriteList;
  final Function(int) toggleFavorite;

   GridNews({
    Key? key,
    required this.store,
    required this.isFavoriteList,
    required this.toggleFavorite,
  }) : super(key: key);

    late Newscontrollers newscontrollers = Get.put(Newscontrollers());


  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([
        store.isLoading,
        store.error,
        store.state,
      ]),
      builder: (context, child) {
        if (store.isLoading.value == true) {
          return const Center(child: CircularProgressIndicator());
        }

        if (store.error.value.isNotEmpty) {
          return Center(
            child: Text(
              store.error.value,
              style: const TextStyle(
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        }

        if (store.state.value.isEmpty) {
          return const Center(
            child: Text(
              'Nenhum item na lista',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
              textAlign: TextAlign.center,
            ),
          );
        } else {
          return GridView.builder(
            padding: EdgeInsets.all(8),
            itemCount: store.state.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 20,
            ),
            itemBuilder: (_, index) {
              final item = store.state.value[index];

              if (isFavoriteList.length != store.state.value.length) {
                isFavoriteList =
                    List<bool>.filled(store.state.value.length, false);
              }

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => NewPage(
                        item: item,
                      ),
                    ),
                  );
                },
                child: Card(
                  child: Column(
                    children: [
                      Container(
                        width: 200,
                        height: 75,
                        child: Image.network(
                          item.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                      SizedBox(height: 5,),
                      Row(
                        children: [
                          //toggle
                          IconButton(
                              icon: Icon(
                                isFavoriteList[index]
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () {
                               toggleFavorite(index);
                               isFavoriteList[index]? newscontrollers.add(item): newscontrollers.remove(item);
                              }),
                          Container(
                            width: 80,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  item.source.name,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      
                      Padding(
                        padding: EdgeInsets.all(8),
                        child: Column(
                          children: [
                            Text(
                              item.title,
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                            Text(
                              DateFormat('dd/MM/yyyy')
                                  .format(DateTime.parse(item.publishedAt)),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}
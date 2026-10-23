import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newa/features/favorites/presentation/favorites_controller.dart';
import '../newPage.dart';
import '../stores/newsStores.dart';

class GridNews extends StatelessWidget {
  final NewsStores store;
  final FavoritesController favorites;
  const GridNews({super.key, required this.store, required this.favorites});
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: Listenable.merge(
            [store.isLoading, store.error, store.state, favorites]),
        builder: (context, _) {
          if (store.isLoading.value)
            return const Center(child: CircularProgressIndicator());
          if (store.error.value.isNotEmpty)
            return Center(child: Text(store.error.value));
          if (store.state.value.isEmpty)
            return const Center(child: Text('Nenhum item na lista'));
          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: store.state.value.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 16, mainAxisSpacing: 20),
            itemBuilder: (context, index) {
              final item = store.state.value[index];
              final date = DateTime.tryParse(item.publishedAt);
              return Card(
                  child: InkWell(
                onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => NewPage(item: item))),
                child: Column(children: [
                  Expanded(
                      child: Image.network(item.image,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) =>
                              const Icon(Icons.image_not_supported))),
                  Row(children: [
                    IconButton(
                        tooltip: 'Favoritar notícia',
                        icon: Icon(favorites.contains(item)
                            ? Icons.favorite
                            : Icons.favorite_border),
                        onPressed: () => favorites.toggle(item)),
                    Expanded(
                        child: Text(item.source.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis)),
                  ]),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(item.title,
                          maxLines: 1, overflow: TextOverflow.ellipsis)),
                  Text(date == null
                      ? 'Data indisponível'
                      : DateFormat('dd/MM/yyyy').format(date)),
                ]),
              ));
            },
          );
        },
      );
}

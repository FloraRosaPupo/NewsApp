import 'package:flutter/foundation.dart';
import 'package:newa/features/news/domain/newsModel.dart';

class FavoritesController extends ValueNotifier<List<NewsModel>> {
  FavoritesController() : super(const []);
  String _id(NewsModel item) =>
      item.url.isNotEmpty ? item.url : '${item.source.name}:${item.title}';
  bool contains(NewsModel item) =>
      value.any((other) => _id(other) == _id(item));
  void toggle(NewsModel item) {
    value = List.unmodifiable(contains(item)
        ? value.where((other) => _id(other) != _id(item))
        : [...value, item]);
  }
}

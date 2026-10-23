import 'package:flutter/foundation.dart';
import 'package:newa/core/http/exception.dart';
import 'package:newa/features/news/domain/newsModel.dart';
import 'package:newa/features/news/data/newsRepository.dart';

class NewsStores {
  final INewsRepository repository;
  final isLoading = ValueNotifier(false);
  final state = ValueNotifier<List<NewsModel>>([]);
  final error = ValueNotifier('');
  int _request = 0;
  bool _disposed = false;
  NewsStores({required this.repository});
  Future<void> getNews(String category) async {
    if (_disposed) return;
    final request = ++_request;
    isLoading.value = true;
    error.value = '';
    try {
      final result = await repository.getNews(category);
      if (!_disposed && request == _request) state.value = result;
    } catch (e) {
      if (!_disposed && request == _request)
        error.value = e is NotFoundException ? e.message : e.toString();
    } finally {
      if (!_disposed && request == _request) isLoading.value = false;
    }
  }

  void dispose() {
    _disposed = true;
    isLoading.dispose();
    state.dispose();
    error.dispose();
  }
}

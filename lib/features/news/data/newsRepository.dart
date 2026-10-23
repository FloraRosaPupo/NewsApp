import 'dart:convert';
import 'package:newa/core/http/exception.dart';
import 'package:newa/core/http/httpClient.dart';
import 'package:newa/features/news/domain/newsModel.dart';

abstract class INewsRepository {
  Future<List<NewsModel>> getNews(String category);
}

class NewsRepository implements INewsRepository {
  final IHttpClient client;
  final String apiKey;
  NewsRepository(
      {required this.client,
      this.apiKey = const String.fromEnvironment('GNEWS_API_KEY')});
  @override
  Future<List<NewsModel>> getNews(String category) async {
    if (apiKey.isEmpty) throw StateError('Configure GNEWS_API_KEY.');
    final uri = Uri.https('gnews.io', '/api/v4/top-headlines', {
      'category': category,
      'lang': 'pt',
      'country': 'br',
      'max': '100',
      'apikey': apiKey,
    });
    final response = await client.get(url: uri.toString());
    if (response.statusCode == 404)
      throw NotFoundException(message: 'A URL informada não é válida');
    if (response.statusCode != 200)
      throw StateError(
          'Não foi possível carregar as notícias (${response.statusCode}).');
    final body = jsonDecode(response.body);
    if (body is! Map<String, dynamic> || body['articles'] is! List)
      throw const FormatException('Resposta de notícias inválida.');
    return (body['articles'] as List)
        .map((item) => NewsModel.fromMap(item as Map<String, dynamic>))
        .toList();
  }
}

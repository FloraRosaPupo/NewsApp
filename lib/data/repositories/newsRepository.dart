import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:newa/data/http/exception.dart';
import 'package:newa/data/http/httpClient.dart';
import 'package:newa/data/model/newsModel.dart';

//contrato

abstract class INewsRepository {
  //buscar as news
  Future<List<NewsModel>> getNews();
}

class NewsRepository implements INewsRepository {
  final IHttpClient client;

  final category = 'general';
  NewsRepository({required this.client, required category});

  @override
  Future<List<NewsModel>> getNews() async {
    final response = await client.get(
        url:
            'https://gnews.io/api/v4/top-headlines?category=${category}&lang=pt&country=br&max=100&apikey=fda080ffc26b34f9401f4581d836e649');

    if (response.statusCode == 200) {
      //lista de new
      final List<NewsModel> news = [];

      final body = jsonDecode(response.body);

      body["articles"]?.map((item) {
        final NewsModel notice = NewsModel.fromMap(item);
        news.add(notice);
      }).toList();
      print('Resposta da API: $body');
      return news;
    } else if (response.statusCode == 404) {
      throw NotFoundException(message: 'A url informada não é valida');
    } else {
      throw Exception('Não foi possivel carregar as Noticias');
    }
  }
}

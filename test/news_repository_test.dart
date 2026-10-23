import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:newa/core/http/httpClient.dart';
import 'package:newa/features/news/data/newsRepository.dart';

void main() {
  test('usa chave configurada e codifica categoria', () async {
    final client = HttpClient(client: MockClient((request) async {
      expect(request.url.queryParameters['category'], 'tech & science');
      expect(request.url.queryParameters['apikey'], 'test');
      return http.Response('{"articles":[{"title":"Notícia"}]}', 200,
          headers: {'content-type': 'application/json; charset=utf-8'});
    }));
    addTearDown(client.close);
    final news = await NewsRepository(client: client, apiKey: 'test')
        .getNews('tech & science');
    expect(news.single.title, 'Notícia');
  });
  test('resposta sem articles é erro e não lista vazia', () async {
    final client =
        HttpClient(client: MockClient((_) async => http.Response('{}', 200)));
    addTearDown(client.close);
    await expectLater(
        NewsRepository(client: client, apiKey: 'test').getNews('general'),
        throwsFormatException);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:newa/features/news/domain/newsModel.dart';

void main() {
  test('notícia incompleta recebe valores de apresentação seguros', () {
    final news = NewsModel.fromMap({});
    expect(news.title, 'Sem título');
    expect(news.source.name, 'Fonte desconhecida');
    expect(news.image, isEmpty);
  });
  test('nome da fonte é preservado', () {
    final news = NewsModel.fromMap({
      'title': 'Notícia',
      'source': {'name': 'Fonte'}
    });
    expect(news.source.name, 'Fonte');
    expect(news.nameSource, 'Fonte');
  });
}

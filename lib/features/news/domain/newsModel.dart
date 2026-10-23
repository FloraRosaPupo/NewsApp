class NewsModel {
  final String title;
  final String category;
  final String description;
  final String url;
  final String image;
  final String publishedAt;
  final SourceModel source; // map
  final String nameSource;

  NewsModel({
    required this.title,
    required this.category,
    required this.description,
    required this.url,
    required this.image,
    required this.publishedAt,
    required this.source,
    required this.nameSource,
  });

  // Construtor nomeado - transforma o JSON
  factory NewsModel.fromMap(Map<String, dynamic> map) {
    return NewsModel(
      title: map['title'] ?? 'Sem título',
      category: map['category'] ?? 'Sem categoria',
      description: map['description'] ?? 'Sem descrição',
      url: map['url'] ?? '',
      image: map['image'] ?? '',
      publishedAt: map['publishedAt'] ?? '',
      source: map['source'] != null
          ? SourceModel.fromMap(map['source'])
          : SourceModel(name: 'Fonte desconhecida'),
      nameSource: map['source']?['name'] ?? 'Fonte desconhecida',
    );
  }
}

class SourceModel {
  final String name;

  SourceModel({required this.name});

  factory SourceModel.fromMap(Map<String, dynamic> map) {
    return SourceModel(
      name: map['name'] ?? 'Fonte desconhecida',
    );
  }
}

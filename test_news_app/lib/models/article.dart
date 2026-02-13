class Article {
  final String id;
  final String title;
  final String description;
  final ArticleImage image;
  final DateTime date;
  final String author;
  final String category;
  final String content;
  final String blogUrl;
  final int readTime;

  Article({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.date,
    required this.author,
    required this.category,
    required this.content,
    required this.blogUrl,
    this.readTime = 5,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      image: ArticleImage.fromJson(json['image'] ?? {}),
      date: DateTime.parse(json['date'] ?? DateTime.now().toIso8601String()),
      author: json['author'] ?? '',
      category: json['category'] ?? '',
      content: json['content'] ?? '',
      blogUrl: json['blog_url'] ?? '',
      readTime: json['read_time'] ?? 5,
    );
  }
}

class ArticleImage {
  final String url;
  final String alt;

  ArticleImage({
    required this.url,
    required this.alt,
  });

  factory ArticleImage.fromJson(Map<String, dynamic> json) {
    return ArticleImage(
      url: json['url'] ?? '',
      alt: json['alt'] ?? '',
    );
  }
}

class Feed {
  final FeedMeta meta;
  final List<Article> articles;

  Feed({
    required this.meta,
    required this.articles,
  });

  factory Feed.fromJson(Map<String, dynamic> json) {
    var articlesJson = json['articles'] as List? ?? [];
    List<Article> articles = articlesJson
        .map((article) => Article.fromJson(article as Map<String, dynamic>))
        .toList();

    return Feed(
      meta: FeedMeta.fromJson(json['meta'] ?? {}),
      articles: articles,
    );
  }
}

class FeedMeta {
  final String name;
  final String description;
  final String url;
  final String generatedAt;
  final int totalArticles;

  FeedMeta({
    required this.name,
    required this.description,
    required this.url,
    required this.generatedAt,
    required this.totalArticles,
  });

  factory FeedMeta.fromJson(Map<String, dynamic> json) {
    return FeedMeta(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      generatedAt: json['generated_at'] ?? '',
      totalArticles: json['total_articles'] ?? 0,
    );
  }
}

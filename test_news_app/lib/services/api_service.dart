import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class ApiService {
  // Updated to use your actual repository: sarvadarshitarang/news
  static const String feedUrl =
      'https://raw.githubusercontent.com/sarvadarshitarang/news/main/feed/news-feed.json';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<Feed> fetchFeed() async {
    try {
      // Try fetching from GitHub first
      final response = await http.get(Uri.parse(feedUrl)).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Feed fetch timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Feed.fromJson(json);
      }
      
      // If GitHub returns error, use mock data
      print('GitHub feed returned ${response.statusCode}, using mock data');
      return _getMockFeed();
    } catch (e) {
      // Return mock data on error (e.g., no internet connection)
      print('Error fetching feed: $e, using mock data');
      return _getMockFeed();
    }
  }

  Feed _getMockFeed() {
    // Mock data for demonstration
    final mockData = {
      "meta": {
        "name": "SarvadarshiTarang",
        "description": "Daily news in shorts",
        "url": feedUrl,
        "generated_at": DateTime.now().toIso8601String(),
        "total_articles": 3
      },
      "articles": [
        {
          "id": "2026-02-13-welcome",
          "title": "Welcome to SarvadarshiTarang! 🎉",
          "description": "Your free, serverless news app is live and ready to use",
          "image": {
            "url": "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800",
            "alt": "Welcome"
          },
          "date": "2026-02-13T00:00:00Z",
          "author": "Team SarvadarshiTarang",
          "category": "Tech",
          "content": "<h2>Welcome!</h2><p>This is your news app powered by GitHub, Flutter, and Firebase.</p><p><strong>Zero hosting costs!</strong> Start publishing articles by committing to your GitHub repository.</p>",
          "blog_url": "https://github.com",
          "read_time": 2
        },
        {
          "id": "2026-02-13-how-it-works",
          "title": "How It Works: GitHub as Your Backend",
          "description": "Learn how this app uses GitHub for free content hosting",
          "image": {
            "url": "https://images.unsplash.com/photo-1618401471353-b98afee0b2eb?w=800",
            "alt": "GitHub"
          },
          "date": "2026-02-13T00:00:00Z",
          "author": "Tech Team",
          "category": "Tech",
          "content": "<p>Your articles live in GitHub as markdown files. GitHub Actions automatically converts them to JSON when you merge changes.</p>",
          "blog_url": "https://github.com",
          "read_time": 5
        },
        {
          "id": "2026-02-13-getting-started",
          "title": "Getting Started with Content",
          "description": "Start publishing your first news article today",
          "image": {
            "url": "https://images.unsplash.com/photo-1499750310107-5fef28a66643?w=800",
            "alt": "Content"
          },
          "date": "2026-02-13T00:00:00Z",
          "author": "Content Team",
          "category": "Guide",
          "content": "<p>Create articles in content/articles/ folder. Commit to GitHub. Your app automatically updates!</p>",
          "blog_url": "https://github.com",
          "read_time": 3
        }
      ]
    };

    return Feed.fromJson(mockData);
  }

  Future<Article> fetchArticle(String id) async {
    try {
      final feed = await fetchFeed();
      return feed.articles.firstWhere((article) => article.id == id);
    } catch (e) {
      throw Exception('Error fetching article: $e');
    }
  }
}

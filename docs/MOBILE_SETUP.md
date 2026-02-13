# Mobile App Setup Guide

## Overview

SarvadarshiTarang uses **Flutter** to build for both iOS and Android from a single codebase.

### Why Flutter?
- ✅ One codebase for iOS + Android
- ✅ Hot reload for rapid development
- ✅ Beautiful UI components
- ✅ Great Firebase integration
- ✅ High performance
- ✅ Active community

## Prerequisites

### Install Flutter

**macOS/Linux:**
```bash
# Download Flutter
git clone https://github.com/flutter/flutter.git -b stable
export PATH="$PATH:`pwd`/flutter/bin"

# Verify installation
flutter doctor
```

**Windows:**
1. Download from [flutter.dev](https://flutter.dev/docs/get-started/install/windows)
2. Extract to a folder (e.g., `C:\src\flutter`)
3. Add to PATH:
   - Right-click "This PC" → Properties
   - Advanced System Settings → Environment Variables
   - Add: `C:\src\flutter\bin`
4. Restart terminal and run:
```bash
flutter doctor
```

### Install Dependencies

```bash
# After Flutter installation
flutter pub get

# Install for iOS (macOS only)
cd ios
pod install
cd ..

# Install for Android
# Android Studio: File → Settings → SDK Manager
```

## Project Structure

```
mobile-app/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── article.dart         # Article data model
│   │   └── feed_response.dart   # API response model
│   ├── services/
│   │   ├── api_service.dart     # GitHub API client
│   │   ├── notification_service.dart
│   │   └── local_storage.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── article_detail_screen.dart
│   │   └── settings_screen.dart
│   └── widgets/
│       ├── article_card.dart
│       └── loading_shimmer.dart
├── android/
│   ├── app/
│   │   ├── build.gradle
│   │   └── google-services.json
│   └── gradle.properties
├── ios/
│   ├── Podfile
│   ├── Runner.xcodeproj
│   └── GoogleService-Info.plist
├── pubspec.yaml                 # Dependencies
└── pubspec.lock
```

## Setup Steps

### 1. Create Flutter Project

```bash
cd mobile-app
flutter create .
flutter pub get
```

### 2. Update pubspec.yaml

```yaml
name: sarvadarshi_tarang
description: News app powered by GitHub
version: 1.0.0+1

environment:
  sdk: '>=3.0.0 <4.0.0'

dependencies:
  flutter:
    sdk: flutter
  
  # HTTP client
  http: ^1.1.0
  dio: ^5.3.0
  
  # JSON serialization
  json_annotation: ^4.8.0
  
  # Local storage
  shared_preferences: ^2.2.0
  hive: ^2.2.0
  
  # Firebase
  firebase_core: ^2.24.0
  firebase_messaging: ^14.6.0
  
  # UI components
  cached_network_image: ^3.3.0
  shimmer: ^3.0.0
  
  # Navigation
  go_router: ^12.0.0
  
  # Time formatting
  intl: ^0.19.0
  
  # Analytics (optional)
  firebase_analytics: ^10.7.0
  
  # Notifications
  flutter_local_notifications: ^16.1.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  
  build_runner: ^2.4.0
  json_serializable: ^6.7.0
  flutter_launcher_icons: ^0.13.0

flutter:
  uses-material-design: true
```

### 3. Install Dependencies

```bash
flutter pub get
```

## Core Files

### Article Model (lib/models/article.dart)

```dart
import 'package:json_annotation/json_annotation.dart';

part 'article.g.dart';

@JsonSerializable()
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

  factory Article.fromJson(Map<String, dynamic> json) =>
      _$ArticleFromJson(json);
  
  Map<String, dynamic> toJson() => _$ArticleToJson(this);
}

@JsonSerializable()
class ArticleImage {
  final String url;
  final String alt;

  ArticleImage({
    required this.url,
    required this.alt,
  });

  factory ArticleImage.fromJson(Map<String, dynamic> json) =>
      _$ArticleImageFromJson(json);
  
  Map<String, dynamic> toJson() => _$ArticleImageToJson(this);
}

@JsonSerializable()
class Feed {
  final FeedMeta meta;
  final List<Article> articles;

  Feed({
    required this.meta,
    required this.articles,
  });

  factory Feed.fromJson(Map<String, dynamic> json) =>
      _$FeedFromJson(json);
  
  Map<String, dynamic> toJson() => _$FeedToJson(this);
}

@JsonSerializable()
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

  factory FeedMeta.fromJson(Map<String, dynamic> json) =>
      _$FeedMetaFromJson(json);
  
  Map<String, dynamic> toJson() => _$FeedMetaToJson(this);
}
```

### API Service (lib/services/api_service.dart)

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/article.dart';

class ApiService {
  static const String feedUrl =
      'https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json';

  static final ApiService _instance = ApiService._internal();

  factory ApiService() {
    return _instance;
  }

  ApiService._internal();

  Future<Feed> fetchFeed() async {
    try {
      final response = await http.get(Uri.parse(feedUrl)).timeout(
        const Duration(seconds: 15),
        onTimeout: () => throw Exception('Feed fetch timeout'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return Feed.fromJson(json);
      } else {
        throw Exception('Failed to load feed: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching feed: $e');
    }
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
```

### Notification Service (lib/services/notification_service.dart)

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() {
    return _instance;
  }

  NotificationService._internal();

  Future<void> initialize() async {
    // Request permission
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carryForwardToken: true,
      critical: false,
      provisional: false,
      sound: true,
    );

    // Get token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      _handleMessage(message);
    });

    // Handle background message tap
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _handleMessageTap(message);
    });

    // Initialize local notifications
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings();

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(initSettings);
  }

  void _handleMessage(RemoteMessage message) {
    final title = message.notification?.title ?? 'New Article';
    final body = message.notification?.body ?? 'Check out new news';

    _showLocalNotification(title, body);
  }

  void _handleMessageTap(RemoteMessage message) {
    // Navigate to article
    print('Notification tapped: ${message.data}');
  }

  Future<void> _showLocalNotification(String title, String body) async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'sarvadarshi_channel',
      'News Notifications',
      channelDescription: 'Notifications for new articles',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
    );

    await _localNotifications.show(
      0,
      title,
      body,
      details,
    );
  }
}
```

### Main App (lib/main.dart)

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'services/notification_service.dart';
import 'services/api_service.dart';
import 'models/article.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  await NotificationService().initialize();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SarvadarshiTarang',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late Future<Feed> _feedFuture;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _feedFuture = _apiService.fetchFeed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SarvadarshiTarang'),
        centerTitle: true,
      ),
      body: FutureBuilder<Feed>(
        future: _feedFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 48, color: Colors.red),
                  const SizedBox(height: 16),
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => setState(() {
                      _feedFuture = _apiService.fetchFeed();
                    }),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.articles.isEmpty) {
            return const Center(child: Text('No articles available'));
          }

          final feed = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _feedFuture = _apiService.fetchFeed();
              });
            },
            child: ListView.builder(
              itemCount: feed.articles.length,
              itemBuilder: (context, index) {
                final article = feed.articles[index];
                return ArticleCard(article: article);
              },
            ),
          );
        },
      ),
    );
  }
}

class ArticleCard extends StatelessWidget {
  final Article article;

  const ArticleCard({Key? key, required this.article}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ArticleDetailScreen(article: article),
          ),
        );
      },
      child: Card(
        margin: const EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.url.isNotEmpty)
              Image.network(
                article.image.url,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Chip(
                        label: Text(article.category,
                            style:
                                const TextStyle(color: Colors.white, fontSize: 12)),
                        backgroundColor: Colors.blue,
                      ),
                      Text(
                        '${article.readTime} min read',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.description,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        article.author,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      Text(
                        article.date.toString().split(' ')[0],
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ArticleDetailScreen extends StatelessWidget {
  final Article article;

  const ArticleDetailScreen({Key? key, required this.article})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Article'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.image.url.isNotEmpty)
              Image.network(
                article.image.url,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(
                      height: 300,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image_not_supported),
                    ),
              ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(article.author),
                      Text(article.date.toString().split(' ')[0]),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(article.description),
                  const SizedBox(height: 16),
                  // HTML content would be rendered here with webview or html package
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Open blog URL
                    },
                    child: const Text('Read Full Article'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

## Firebase Setup

### 1. Create Firebase Project

1. Go to [firebase.google.com](https://firebase.google.com)
2. Click "Get Started"
3. Create new project: "SarvadarshiTarang"
4. Skip analytics for now
5. Go to console

### 2. Register Android App

1. Click **Add app** → **Android**
2. Package name: `com.example.sarvadarshi_tarang`
3. Click **Register app**
4. Download `google-services.json`
5. Place in `android/app/`

### 3. Register iOS App

1. Click **Add app** → **iOS**
2. Bundle ID: `com.example.sarvasarshiTarang`
3. Click **Register app**
4. Download `GoogleService-Info.plist`
5. Open `ios/Runner.xcodeproj` and add file

### 4. Enable Cloud Messaging

1. In Firebase Console: **Build** → **Cloud Messaging**
2. Get your **Server Key** (for backend notifications)
3. Save it in GitHub Secrets

## Building & Deploying

### Build APK (Android)

```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

### Build iOS

```bash
# Requires macOS and Apple Developer Account
flutter build ios --release
```

### Release to Stores

- **Google Play**: Use `flutter build appbundle`
- **App Store**: Use Xcode or Fastlane

## Testing

Run the app:

```bash
# On emulator/device
flutter run

# Hot reload (press 'r' in terminal)
# Hot restart (press 'R' in terminal)
```

---

**Next**: Setup notifications in [NOTIFICATIONS_SETUP.md](NOTIFICATIONS_SETUP.md)

# Firebase Notifications Setup

SarvadarshiTarang uses **Firebase Cloud Messaging (FCM)** for real-time push notifications - completely free!

## Why Firebase Cloud Messaging?

✅ **Free**: Unlimited notifications  
✅ **Simple**: Easy integration with mobile apps  
✅ **Real-time**: Instant delivery  
✅ **Reliable**: 99.9% uptime SLA  
✅ **Analytics**: Built-in tracking  

## Architecture

```
New Article Published
        ↓
GitHub Actions Workflow
        ↓
Send to Firebase Cloud Messaging
        ↓
Delivered to All App Users
        ↓
Local Notification Shown
```

## Firebase Setup

### 1. Create Firebase Project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Click **Create Project**
3. Project name: `SarvadarshiTarang`
4. Disable Analytics (optional)
5. Click **Create Project**

### 2. Get Credentials

#### Android Credentials

1. Click **Add app** → **Android**
2. Package name: `com.example.sarvadarshi_tarang`
3. Download `google-services.json`
4. Move to `android/app/google-services.json`

#### iOS Credentials

1. Click **Add app** → **iOS**
2. Bundle ID: `com.example.sarvadarshiTarang`
3. Download `GoogleService-Info.plist`
4. Add to Xcode project

### 3. Get Server Key

For sending notifications from GitHub Actions:

1. Go to **Project Settings** (⚙️ icon)
2. Choose **Service Accounts** tab
3. Click **Generate new private key**
4. Save the JSON file securely

Or use **Legacy Server Key**:

1. Go to **Cloud Messaging** tab
2. Copy **Server Key** under "Legacy Server API Key"

## Configure Mobile App

### pubspec.yaml Dependencies

```yaml
dependencies:
  firebase_core: ^2.24.0
  firebase_messaging: ^14.6.0
  flutter_local_notifications: ^16.1.0
```

### Android Configuration

**android/app/build.gradle**:

```gradle
dependencies {
    implementation 'com.google.firebase:firebase-messaging'
}

apply plugin: 'com.google.gms.google-services'
```

**android/build.gradle**:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

### iOS Configuration

**No additional setup needed** - Firebase cocoapod handles it.

## Implementation

### Initialize Firebase in App

**lib/main.dart**:

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  runApp(const MyApp());
}
```

### Handle Notifications

**lib/services/notification_service.dart**:

```dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _instance = 
      NotificationService._internal();

  final FirebaseMessaging _firebaseMessaging = 
      FirebaseMessaging.instance;
  
  final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  factory NotificationService() => _instance;

  NotificationService._internal();

  Future<void> initialize() async {
    // Request permissions
    NotificationSettings settings = 
        await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carryForwardToken: true,
      critical: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == 
        AuthorizationStatus.authorized) {
      print('User granted notification permission');
    }

    // Get FCM token
    String? token = await _firebaseMessaging.getToken();
    print('FCM Token: $token');
    // Save this token to your backend if needed

    // Setup handlers
    _setupMessageHandlers();
    
    // Initialize local notifications
    _initializeLocalNotifications();
  }

  void _setupMessageHandlers() {
    // Handle notification when app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received in foreground');
      _handleNotificationTap(message);
    });

    // Handle notification tap when app was terminated
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? message) {
      if (message != null) {
        _handleNotificationTap(message);
      }
    });

    // Handle notification tap when app was in background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('Notification tapped');
      _handleNotificationTap(message);
    });
  }

  void _initializeLocalNotifications() async {
    const AndroidInitializationSettings androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    const DarwinInitializationSettings iosSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (details) {
        _handleNotificationTap(null);
      },
    );
  }

  Future<void> showNotification(RemoteMessage message) async {
    final notification = message.notification;
    final android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'sarvadarshi_channel',
            'News Notifications',
            channelDescription: 'Notifications for new articles',
            icon: '@mipmap/ic_launcher',
            importance: Importance.max,
            priority: Priority.high,
          ),
          iOS: DarwinNotificationDetails(),
        ),
      );
    }
  }

  void _handleNotificationTap(RemoteMessage? message) {
    // Extract article ID from notification
    final articleId = message?.data['article_id'];
    
    if (articleId != null) {
      // Navigate to article
      // Use your navigation solution (GoRouter, etc.)
      print('Navigate to article: $articleId');
    }
  }
}
```

## Send Notifications from GitHub Actions

### Step 1: Save Firebase Credentials

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Project Settings → **Service Accounts**
3. Click **Generate New Private Key**
4. Copy the entire JSON content

GitHub Actions Setup:

1. Go to repository **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Name: `FIREBASE_CREDENTIALS`
4. Value: Paste the entire service account JSON
5. Click **Add secret**

Or use legacy key:

1. Go to **Cloud Messaging** tab
2. Copy **Server Key**
3. Create secret: `FCM_SERVER_KEY`

### Step 2: Install Firebase Admin SDK

Update `.github/workflows/notify-users.yml`:

```yaml
name: Send Notifications

on:
  workflow_run:
    workflows: ["Generate News Feed"]
    types: [completed]

jobs:
  notify:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install firebase-admin requests
      
      - name: Send notification
        run: python scripts/send_notifications.py
        env:
          FIREBASE_CREDENTIALS: ${{ secrets.FIREBASE_CREDENTIALS }}
```

### Step 3: Send Notification Script

**scripts/send_notifications.py**:

```python
import json
import os
from pathlib import Path
import firebase_admin
from firebase_admin import credentials, messaging

def send_notification():
    """Send FCM notification for new article"""
    
    # Read feed
    with open('dist/feed.json', 'r') as f:
        feed = json.load(f)
    
    if not feed['articles']:
        print("No articles to notify")
        return
    
    latest = feed['articles'][0]
    
    # Initialize Firebase
    creds_json = os.getenv('FIREBASE_CREDENTIALS')
    if creds_json:
        creds_dict = json.loads(creds_json)
        creds = credentials.Certificate(creds_dict)
        firebase_admin.initialize_app(creds)
    else:
        # Or use default credentials if deployed in Google Cloud
        firebase_admin.initialize_app()
    
    # Create message
    message = messaging.Message(
        notification=messaging.Notification(
            title=latest['title'][:80],  # Max 80 chars
            body=latest['description'][:200],
        ),
        data={
            'article_id': latest['id'],
            'image_url': latest['image']['url'],
            'category': latest['category'],
        },
        topic='news',  # Send to all subscribed to 'news' topic
    )
    
    # Send
    try:
        response = messaging.send(message)
        print(f'✓ Notification sent: {response}')
    except Exception as e:
        print(f'✗ Error sending notification: {e}')

if __name__ == '__main__':
    send_notification()
```

## Subscribe to Topic

Make users subscribe to notifications in app:

**lib/services/notification_service.dart**:

```dart
Future<void> subscribeToTopic(String topic) async {
  await _firebaseMessaging.subscribeToTopic(topic);
  print('Subscribed to topic: $topic');
}

Future<void> initialize() async {
  // ... initialization code ...
  
  // Subscribe to news topic
  await subscribeToTopic('news');
}
```

## Test Notifications

### Option 1: Firebase Console

1. Go to **Cloud Messaging** tab
2. Click **Send your first message**
3. Notification title: "Test"
4. Body: "Hello from Firebase"
5. Target: **Topic** → `news`
6. Click **Send**

Should see notification on connected devices!

### Option 2: Manual Test with Script

```bash
python scripts/test_notification.py
```

**scripts/test_notification.py**:

```python
import firebase_admin
from firebase_admin import credentials, messaging
import json
import os

creds_json = os.getenv('FIREBASE_CREDENTIALS')
if creds_json:
    creds = credentials.Certificate(json.loads(creds_json))
    firebase_admin.initialize_app(creds)

# Send test notification
message = messaging.Message(
    notification=messaging.Notification(
        title="Test Notification",
        body="This is a test from GitHub Actions",
    ),
    topic='news',
)

response = messaging.send(message)
print(f'Notification sent: {response}')
```

## Monitor Notifications

### Firebase Console Analytics

1. Go to **Analytics** tab
2. See notification delivery stats
3. Track user interactions
4. Monitor error rates

### Store Token for User Targeting

To send notifications to specific users:

```dart
// Save user's FCM token
Future<void> saveUserToken(String userId) async {
  String? token = await _firebaseMessaging.getToken();
  
  // Save to your backend/database
  // Example: SharedPreferences for local storage
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('fcm_token_$userId', token!);
}
```

## Deep Linking

Send users to specific articles via notification:

**Firebase Console → Message Data**:

```json
{
  "article_id": "2026-02-13-breaking-news"
}
```

**lib/services/notification_service.dart**:

```dart
void _handleNotificationTap(RemoteMessage? message) {
  final articleId = message?.data['article_id'];
  
  if (articleId != null) {
    // Navigate to article detail screen
    // Using GoRouter or Navigator
    navigateToArticle(articleId);
  }
}
```

## Troubleshooting

### Notifications not received

- [ ] Verify FCM topic subscription
- [ ] Check app has notification permission
- [ ] Review Firebase Console logs
- [ ] Test with Firebase Console sender first

### Token issues

- [ ] App must have internet connection
- [ ] Check Google Play Services installed (Android)
- [ ] Verify Firebase project and bundle IDs match

### Delivery Failing

- [ ] Check Firebase credentials are correct
- [ ] Verify user has subscribed to topic
- [ ] Review Firebase Cloud Messaging quota
- [ ] Check service limits in Firebase Console

## Common Issues

| Problem | Solution |
|---------|----------|
| Notifications not showing | Verify notification permission requested and granted |
| Old tokens not working | Tokens can expire, implement refresh logic |
| Message not delivered | Check Firebase quota and project status |
| Can't get token | Verify Google Play Services installed |

## Cost

✅ **Completely Free**
- Firebase Free Tier: 10,000 notifications/day
- For larger apps: pay per million notifications
- Tracking and analytics: included

---

**Next**: Setup team collaboration in [COLLABORATION_GUIDE.md](COLLABORATION_GUIDE.md)

# System Architecture

Complete technical architecture of SarvadarshiTarang news app.

## High-Level Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      USERS                                       │
│          (iOS Devices + Android Devices)                        │
└────────┬─────────────────────────────────────┬──────────────────┘
         │                                     │
         │ (Push Notifications)               │ (Fetch Feed)
         │                                     │
    ┌────▼────────────────────────┐     ┌─────▼──────────────────┐
    │   Firebase Cloud Messaging  │     │  GitHub Raw Content    │
    │   (Free Notification Hub)   │     │  CDN                   │
    │                             │     │                        │
    │ - Topic subscriptions       │     │ API Endpoint:          │
    │ - Device management         │     │ raw.githubusercontent │
    │ - Message delivery          │     │ /USERNAME/repo/main/   │
    │ - Analytics                 │     │ dist/feed.json         │
    └────┬────────────────────────┘     └─────┬──────────────────┘
         │                                     │
         └──────────────┬──────────────────────┘
                        │
              ┌─────────▼──────────┐
              │  GitHub Actions    │
              │  (CI/CD Pipeline)  │
              │                    │
              │ On: git push/merge │
              │ - Validate content │
              │ - Generate JSON    │
              │ - Publish to CDN   │
              │ - Send push notif. │
              └─────────┬──────────┘
                        │
         ┌──────────────┴──────────────┐
         │                             │
    ┌────▼────────────────┐  ┌────────▼─────────────┐
    │  GitHub Repository  │  │  GitHub Pages        │
    │  (Content Storage)  │  │  (Static Hosting)    │
    │                     │  │                      │
    │ content/            │  │ Serves:              │
    │   articles/  ────┐  │  │ - feed.json          │
    │   assets/    ─┐  │  │  │ - Static assets      │
    │              │  │  │  │ - Performance stats  │
    │ .github/     │  │  │  │                      │
    │   workflows/ │  │  │  │ Free CDN powered by  │
    │              │  │  │  │ Fastly               │
    │ scripts/     │  │  │  │ (GitHub's provider)  │
    │              │  │  │  │                      │
    │ Contributors │  │  │  └──────────────────────┘
    │ submit PRs ──┼──┼──┘
    │             │  │
    │ Approvals & ▼  │
    │ Merge triggers │
    │ automation     │
    └────────────────┘
```

## Component Breakdown

### 1. Mobile App (Flutter)

**Technology Stack:**
- **Language**: Dart
- **Framework**: Flutter
- **State Management**: Provider or GetX
- **Storage**: SharedPreferences + Hive
- **Networking**: HTTP/Dio
- **Notifications**: Firebase Cloud Messaging
- **Analytics**: Firebase Analytics

**Key Features:**
```
Main App
├── Home Screen (Feed)
│   ├── Article List
│   │   └── Article Cards
│   │       ├── Image
│   │       ├── Title
│   │       ├── Description
│   │       ├── Category Badge
│   │       └── Read Time
│   ├── Pull to Refresh
│   ├── Offline Caching
│   └── Search (Optional)
│
├── Article Detail Screen
│   ├── Full image
│   ├── Article content
│   ├── "Read More" link
│   └── Share button
│
├── Settings Screen
│   ├── Notification toggle
│   ├── Category preferences
│   ├── Dark mode
│   └── App info
│
└── Notification Handler
    ├── Firebase listener
    ├── Local notification display
    └── Deep linking
```

**App Files Structure:**
```
mobile-app/
├── lib/
│   ├── main.dart                    # App entry point
│   ├── models/
│   │   ├── article.dart            # Article data model
│   │   ├── feed_response.dart
│   │   └── notification.dart
│   ├── services/
│   │   ├── api_service.dart        # GitHub API client
│   │   ├── notification_service.dart
│   │   ├── local_storage.dart
│   │   └── analytics_service.dart
│   ├── screens/
│   │   ├── home_screen.dart
│   │   ├── article_detail_screen.dart
│   │   ├── settings_screen.dart
│   │   └── splash_screen.dart
│   ├── widgets/
│   │   ├── article_card.dart
│   │   ├── loading_shimmer.dart
│   │   ├── bottom_nav.dart
│   │   └── custom_appbar.dart
│   ├── theme/
│   │   ├── light_theme.dart
│   │   └── dark_theme.dart
│   └── utils/
│       ├── constants.dart
│       └── extensions.dart
│
├── android/
│   ├── app/
│   │   └── google-services.json    # Firebase config
│   └── gradle.properties
│
├── ios/
│   ├── Runner/
│   │   └── GoogleService-Info.plist
│   └── Podfile
│
└── pubspec.yaml                     # Dependencies
```

**Estimated Size**: 15-20 MB (APK), 30-40 MB (IPA)

### 2. GitHub Repository

**Purpose**: Content storage and CI/CD orchestration

**Structure:**
```
SarvadarshiTarang/
│
├── content/
│   ├── articles/              # Markdown articles
│   │   └── YYYY-MM-DD-slug.md
│   └── assets/                # Images
│       └── YYYY-MM-DD-image.jpg
│
├── .github/
│   └── workflows/             # GitHub Actions
│       ├── generate-feed.yml  # Convert markdown → JSON
│       └── notify-users.yml   # Send notifications
│
├── scripts/                   # Python automation
│   ├── generate_feed.py       # Markdown to JSON converter
│   ├── validate_feed.py       # Schema validator
│   ├── send_notifications.py  # FCM sender
│   └── test_notification.py   # Testing script
│
├── dist/                      # Generated (not manual)
│   ├── feed.json              # Main feed
│   └── feed.xml               # RSS (optional)
│
├── schemas/
│   └── article-schema.json    # JSON schema definition
│
├── docs/
│   ├── QUICK_START.md
│   ├── CONTENT_GUIDE.md
│   ├── WORKFLOW_SETUP.md
│   ├── MOBILE_SETUP.md
│   ├── NOTIFICATIONS_SETUP.md
│   ├── COLLABORATION_GUIDE.md
│   ├── DEPLOYMENT.md
│   └── ARCHITECTURE.md
│
└── README.md
```

**Key Repositories**:
- Type: Public (anyone can read)
- Size: < 50 MB
- Main branch: Protected (PR required to merge)

### 3. GitHub Actions Workflow

**Trigger Events:**
```
Developer pushes to main
         │
         ▼
GitHub detect content change
         │
         ▼
Workflow: generate-feed.yml triggers
         │
         ├─ Checkout repository
         ├─ Setup Python 3.11
         ├─ Install dependencies
         │  (pyyaml, markdown2, Pillow)
         │
         ├─ Run generate_feed.py
         │  ├─ Parse frontmatter
         │  ├─ Convert markdown → HTML
         │  ├─ Resolve image URLs
         │  └─ Output: dist/feed.json
         │
         ├─ Run validate_feed.py
         │  ├─ Validate JSON schema
         │  ├─ Check required fields
         │  └─ Verify image accessibility
         │
         ├─ Commit dist/ changes
         │  └─ git push
         │
         └─ Trigger notify-users.yml
                    │
                    ▼
            Workflow: notify-users.yml
                    │
                    ├─ Get latest article
                    ├─ Prepare notification
                    │  ├─ Title (max 80 chars)
                    │  ├─ Body (max 200 chars)
                    │  ├─ Image
                    │  └─ Deep link data
                    │
                    └─ Send via Firebase
                       └─ To topic: 'news'
```

**Execution Time**: 1-2 minutes per workflow

**Cost**: Free (2000 min/month included)

### 4. Firebase Cloud Messaging

**Architecture:**
```
GitHub Actions
  │
  ├─ Get FCM Server Key
  ├─ Build message
  │  ├─ Notification (title, body)
  │  ├─ Data (article_id, image_url)
  │  └─ Target: Topic 'news'
  │
  └─ Call Firebase API
         │
         ▼
   Firebase Project
         │
         ├─ Route by topic
         ├─ Compress payload
         ├─ Sign message
         │
         └─ Deliver to devices
            │
            ├─ Connect to FCM servers
            ├─ Receive message
            ├─ Device is online?
            │  ├─ Yes: Immediate delivery
            │  └─ No: Queue for 4 weeks
            │
            ├─ Firebase Messaging handler
            ├─ Extract notification
            ├─ Show local notification
            │
            └─ User tap
               └─ App handles deep link
```

**Key Metrics:**
- Free Tier: 10,000 notifications/day
- Delivery Rate: 99%+
- Latency: < 5 seconds
- Cost per million: $0.50 (after free tier)

### 5. GitHub Pages CDN

**Structure:**
```
User requests feed.json
         │
         ▼
    Browser DNS
         │
         ├─ Resolves raw.githubusercontent.com
         ├─ Routes to nearest CDN edge
         │
         └─ Edge server checks cache
            │
            ├─ Cache hit → serve immediately (< 100ms)
            └─ Cache miss → fetch from GitHub
                    │
                    ├─ GitHub API returns file
                    ├─ Edge caches it
                    └─ Serve to user
```

**Performance:**
- Global CDN powered by Fastly
- Cache TTL: 5 minutes (configurable)
- Bandwidth: Unlimited & free
- Availability: 99.99%

### 6. Data Flow Diagram

**Article Publishing Flow:**
```
┌──────────────┐
│  Contributor │
└──────┬───────┘
       │
       ▼
┌──────────────────────────┐
│  Create/Edit Article     │
│  - Markdown file         │
│  - Image file            │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Git Commit & Push       │
│  - Feature branch        │
│  - Descriptive message   │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Create Pull Request     │
│  - Fill template         │
│  - Request review        │
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Editor Reviews          │
│  - Check format          │
│  - Verify content        │
│  - Approve/Request changes
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────┐
│  Merge to Main           │
│  - Squash or merge commit│
└──────┬───────────────────┘
       │
       ▼
┌──────────────────────────────────┐
│  GitHub Actions Trigger          │
│  - Detect file changes           │
│  - Start generate-feed workflow  │
└──────┬─────────────────────────────┘
       │
       ├─────────────┬──────────────┐
       │             │              │
       ▼             ▼              ▼
   ┌─────────┐  ┌──────────┐  ┌──────────────┐
   │ Validate│  │ Generate │  │ Commit dist/ │
   │ Articles│  │JSON Feed │  │ Push to main │
   └────┬────┘  └────┬─────┘  └──────┬───────┘
        │             │               │
        │             ▼               │
        │        dist/feed.json ◄─────┘
        │             │
        └─────┬───────┘
              │
              ▼
        ┌──────────────────────┐
        │ GitHub Pages hosts   │
        │ - feed.json          │
        │ - Cached by Fastly   │
        └──────┬───────────────┘
               │
    ┌──────────┴───────────┬────────────┐
    │                      │            │
    ▼                      ▼            ▼
Mobile App          Firebase FCM    Reader Browser
(polls every         (subscribers)   (direct access)
 30 minutes)              │
    │                     │
    ├──Parse feed     ├─Get latest article
    ├──Cache locally  ├─Prepare notification
    ├──Display cards  ├─Send to all devices
    └──Handle taps    └─On notification tap
                         └─Open article in app
```

**Article Lifecycle Timeline:**
```
00:00 - Contributor creates article
01:00 - Editor reviews and approves
01:05 - PR merged to main
01:07 - GitHub Actions starts
01:10 - generate-feed.py runs
01:12 - dist/feed.json updated
01:15 - notify-users.yml starts
01:18 - Push notification sent
01:19 - User receives notification
01:20 - App fetches updated feed
01:21 - New article appears in app
```

### 7. Database Schema

**No centralized database!** Data is distributed:

**Content Storage (Git):**
```
Article File (Markdown + YAML Frontmatter)

---
title: string
description: string (max 100)
image: string (path)
date: YYYY-MM-DD
author: string
category: string
blog_url: string (URL)
read_time: integer (1-60)
---

HTML content here...
```

**Generated Feed JSON:**
```json
{
  "meta": {
    "name": "SarvadarshiTarang",
    "description": "string",
    "url": "https://raw.githubusercontent.com/...",
    "generated_at": "2026-02-13T10:30:00Z",
    "total_articles": 42
  },
  "articles": [
    {
      "id": "2026-02-13-article-slug",
      "title": "string",
      "description": "string",
      "image": {
        "url": "https://...",
        "alt": "string"
      },
      "date": "2026-02-13T00:00:00Z",
      "author": "string",
      "category": "string",
      "content": "HTML string",
      "blog_url": "https://...",
      "read_time": 5,
      "published_at": "2026-02-13T10:30:00Z"
    }
  ]
}
```

**Local App Storage (SQLite via Hive):**
```
articles/ (cached copy)
├── article_id_1.json
├── article_id_2.json
└── ...

user_preferences/
├── enabled_categories: ["Tech", "Sports"]
├── dark_mode: true
├── last_sync: "2026-02-13T10:30:00Z"
└── language: "en"

notification_tokens/
├── fcm_token: "...token..."
└── last_updated: "2026-02-13T10:00:00Z"
```

### 8. Security Architecture

**Authentication:** None required (public app)

**Authorization:**
```
GitHub:
├─ Readers: Public access (no auth)
├─ Contributors: GitHub account required
└─ Editors: Added as collaborators

Firebase:
├─ App signing: Automatic with Firebase
├─ API keys: Restricted to mobile apps
└─ Server key: Protected in GitHub Secrets

Content:
├─ Source: Public GitHub repo
├─ Feed: Public JSON (read-only)
└─ Moderation: Manual PR review
```

**Data Privacy:**
```
User Data Collected:
├─ FCM token (Firebase)
├─ Notification opt-in (App local)
├─ Viewed articles (App local only)
├─ App analytics (Firebase)
└─ Crash reports (Firebase)

Data Storage:
├─ User device only (no server)
├─ Firebase limited data
└─ No personal information collected
```

## Deployment Architecture

**Multi-Environment Setup:**

```
Development (Local)
    ↓
Feature Branch Testing
    ↓
Pull Request Review
    ↓
Merge to Main
    ↓
GitHub Actions CI
    ↓
Staging (GitHub Pages)
    ↓
Manual Testing
    ↓
App Store Submission
    ↓
Production (App Stores)
```

## Scalability

**Current Capacity:**

| Component | Limit | Typical | Buffer |
|-----------|-------|---------|--------|
| GitHub Repo | Unlimited | ~100 articles | ✓ |
| GitHub Pages | 1 GB | ~50 MB | ✓ |
| Firebase Notifications | 10K/day free | 100/day | ✓ |
| GitHub Actions | 2000 min/month | 60 min/month | ✓ |
| Feed Size | Unlimited | ~2 MB | ✓ |
| Concurrent Users | Unlimited | 1K/month | ✓ |

**Growth Path:**

```
100 Articles     2000 Articles      10000 Articles
  ~1 MB            ~20 MB             ~100 MB
 Single Author    10 Contributors     50 Contributors
 10K Users        100K Users          1M Users
  ✓ Free          ✓ Free              $ Need CDN upgrade
```

## Monitoring & Observability

**What We Monitor:**

```
GitHub Actions
├─ Workflow success rate
├─ Execution time
└─ Error logs

Firebase
├─ Notification delivery rate
├─ User engagement
├─ Crash frequency
└─ Session duration

App Performance
├─ Startup time
├─ Feed load time
├─ Error rates
└─ Offline functionality

Content Quality
├─ Article count
├─ Update frequency
├─ Image sizes
└─ Broken links
```

---

This architecture provides a completely free, scalable news app platform!

See [DEPLOYMENT.md](DEPLOYMENT.md) for launch guide.

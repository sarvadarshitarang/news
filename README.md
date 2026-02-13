# SarvadarshiTarang - Serverless News App

A completely **free, serverless news application** for Android and iOS using GitHub as your backend. Perfect for In-Shorts style news delivery with zero hosting costs.

## 🎯 Architecture Overview

```
GitHub Repository (Content)
    ↓
GitHub Actions (Content Processing)
    ↓
GitHub Pages / Raw Content (JSON Delivery - Free CDN)
    ↓
Mobile Apps (Android & iOS)
    ↓
Firebase Services (Free Notifications)
    ↓
External Blog (Free - Medium/Substack/Dev.to)
```

## ✨ Key Features

- **Zero Hosting Costs**: Uses GitHub, GitHub Pages, and Firebase free tier
- **Version Control**: All content tracked in Git with PR-based approval workflow
- **Real-time Notifications**: Push notifications via Firebase Cloud Messaging
- **Multi-author Support**: Team members submit content via GitHub PRs
- **Free Blog Integration**: Redirect readers to your free blog for full articles
- **Image Hosting**: Store images directly in GitHub (easy and free)
- **JSON API**: Auto-generated JSON API from your content

## 📋 Project Structure

```
SarvadarshiTarang/
├── .github/
│   └── workflows/              # GitHub Actions workflows
│       ├── generate-feed.yml   # Convert articles to JSON
│       └── notify-users.yml    # Trigger notifications
├── content/
│   ├── articles/              # Your news articles (markdown)
│   └── assets/                # Images and media
├── schemas/                   # JSON schema definitions
├── scripts/                   # Content generation scripts
├── mobile-app/                # Flutter app source
│   ├── lib/
│   ├── android/
│   └── ios/
└── docs/                      # Documentation
```

## 🚀 Quick Start

### 1. **Setup GitHub Repository**
- [ ] Create a public GitHub repository
- [ ] Enable GitHub Pages (Settings → Pages → Deploy from main branch)
- [ ] Clone this repository

### 2. **Setup Content Structure**
- Create articles in `content/articles/` (markdown format)
- Add images to `content/assets/`
- See [Content Guide](docs/CONTENT_GUIDE.md)

### 3. **Setup GitHub Actions**
- Workflows automatically convert markdown to JSON
- JSON is served via GitHub raw content URL
- See [Workflow Setup](docs/WORKFLOW_SETUP.md)

### 4. **Setup Mobile App**
- Uses Flutter (cross-platform iOS + Android)
- Fetches JSON from GitHub
- Configured for Firebase Push Notifications
- See [Mobile Setup](docs/MOBILE_SETUP.md)

### 5. **Setup Notifications**
- Configure Firebase Cloud Messaging
- Free tier supports unlimited notifications
- See [Notifications Setup](docs/NOTIFICATIONS_SETUP.md)

### 6. **Content Approval Workflow**
- Team members create a branch
- Commit articles in `content/articles/`
- Create a Pull Request
- You review and merge
- GitHub Actions automatically:
  - Generates JSON feed
  - Updates GitHub Pages
  - Publishes notifications
- See [Collaboration Guide](docs/COLLABORATION_GUIDE.md)

## 📱 Mobile App Stack

- **Framework**: Flutter
- **API Client**: dio or http
- **Storage**: shared_preferences
- **Notifications**: firebase_messaging
- **Analytics**: firebase_analytics (optional)

## 💾 Content Management

### Article Format (Markdown)
```markdown
---
title: "Breaking News Title"
description: "Short summary for news feed"
image: "path/to/image.jpg"
date: "2026-02-13"
author: "Your Name"
blog_url: "https://yourblog.com/article-link"
category: "Technology"
---

Full article content goes here...
```

### JSON Output Format
```json
{
  "id": "unique-article-id",
  "title": "Article Title",
  "description": "Short summary",
  "image": {
    "url": "https://raw.githubusercontent.com/...",
    "alt": "Image description"
  },
  "date": "2026-02-13T00:00:00Z",
  "author": "Author Name",
  "category": "Category",
  "content": "Full HTML content",
  "blog_url": "https://yourblog.com/article",
  "read_time": 5
}
```

## 🔄 Workflow Example

1. **Contributor** creates branch: `feature/news-article-feb13`
2. **Contributor** adds files:
   - `content/articles/breaking-news.md`
   - `content/assets/breaking-news.jpg`
3. **Contributor** creates PR with description
4. **You (Editor)** review content
5. **You** merge PR to main
6. **GitHub Actions** automatically:
   - Validates article format
   - Converts to JSON
   - Optimizes images
   - Publishes to GitHub Pages
   - Sends push notification to all users

## 📊 Content Flow

```
User Creates Content
        ↓
Git Push → GitHub PR
        ↓
Editor Reviews
        ↓
Merge to Main
        ↓
GitHub Actions Trigger
        ↓
Generate JSON Feed
        ↓
Publish to GitHub Pages
        ↓
Mobile Apps Fetch & Display
        ↓
Push Notification Sent
```

## 🛠️ Free Services Used

| Service | Usage | Free Tier |
|---------|-------|-----------|
| **GitHub** | Code & content storage | Public repos unlimited |
| **GitHub Pages** | Serve JSON files & static site | 1 GB storage |
| **GitHub Actions** | Automate content processing | 2000 minutes/month |
| **Firebase** | Push notifications | 10K/day limit |
| **Cloudinary/Imgur** | (Optional) Image CDN | Limited but free |
| **Medium/Substack** | Full articles | Free plan available |

## 📖 Documentation

- [Content Creation Guide](docs/CONTENT_GUIDE.md)
- [GitHub Actions Workflow Setup](docs/WORKFLOW_SETUP.md)
- [Mobile App Setup](docs/MOBILE_SETUP.md)
- [Firebase Notifications](docs/NOTIFICATIONS_SETUP.md)
- [Collaboration & PR Guide](docs/COLLABORATION_GUIDE.md)
- [JSON Schema Reference](schemas/article-schema.json)
- [Deployment Guide](docs/DEPLOYMENT.md)

## 🎓 Key Concepts

### Why GitHub as Backend?
- **Free**: Unlimited public repositories
- **Reliable**: Enterprise-grade infrastructure
- **Git History**: Track all content changes
- **Collaboration**: Built-in PR review system
- **Support**: Raw content delivery at no cost

### Why Flutter?
- Write once, deploy to both iOS & Android
- Excellent performance
- Strong Firebase integration
- Beautiful UI out of the box

### Why GitHub Actions?
- Free automation (2000 min/month)
- Runs on push/merge events
- Can trigger external services
- Version-controlled workflows

## 🔓 API Endpoints

Once deployed, your JSON feed will be available at:

```
https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/
```

Example article access:
```
https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json
```

## 🚀 Scaling

As you grow:
1. Add more contributors via GitHub team
2. Implement content categories
3. Add search via CloudFlare Workers (free)
4. Use Algolia (free tier for <10k records)
5. Add reader comments via GitHub Discussions
6. Monitor with Firebase Analytics (free)

## 📝 License

MIT - Feel free to use and modify

## 🤝 Contributing

1. Create a feature branch
2. Add your news article in `content/articles/`
3. Create a Pull Request
4. Wait for editor review
5. Once merged, it automatically appears in the app!

## 💡 Tips & Tricks

- Use `[Read More](https://yourblog.com)` markdown links for blog redirects
- Keep article descriptions under 100 characters
- Optimize images before uploading (under 500KB)
- Use consistent date format: YYYY-MM-DD
- Add multiple categories as tags
- Consider timezone for article scheduling

## ❓ FAQ

**Q: Will my content appear instantly?**
A: GitHub Actions typically processes within 1-2 minutes of merge.

**Q: Can I schedule posts?**
A: GitHub Actions supports scheduled workflows - we'll set this up.

**Q: How do I handle multiple languages?**
A: Create separate content folders: `content/articles/en/`, `content/articles/hi/`

**Q: What's the image size limit?**
A: GitHub allows large files, but keep under 5MB for performance.

**Q: Can I include video?**
A: Host videos on YouTube and embed links in articles.

---

**Let's build a free, powerful news app!** 🚀

Started with ❤️ for independent journalists and news creators.

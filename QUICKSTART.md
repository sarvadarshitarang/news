# SarvadarshiTarang Quick Start 🚀

## ⚡ 5-Minute Setup

### 1. Create GitHub Repository
```bash
# Replace YOUR_USERNAME with your GitHub username
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/YOUR_USERNAME/SarvadarshiTarang.git
git branch -M main
git push -u origin main
```

### 2. Enable GitHub Pages
1. Go to: `Settings` → `Pages`
2. Source: **GitHub Actions**
3. Done!

### 3. Update App Configuration
Edit `test_news_app/lib/services/api_service.dart`:
```dart
static const String _baseUrl = 
  'https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/feed/news-feed.json';
```

### 4. Deploy
```bash
git add .
git commit -m "Configure GitHub feed"
git push
```

Wait 2-3 minutes, then visit:
`https://YOUR_USERNAME.github.io/SarvadarshiTarang/`

---

## 📝 Create Your First Article

Create `content/articles/2026-02-14-my-article.md`:

```markdown
---
title: "My First Article"
description: "This is my first news article!"
author: "Your Name"
category: "Tech"
image_url: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800"
image_alt: "Article image"
blog_url: "https://yourblog.com/article"
---

Your article content here!
```

Push to GitHub:
```bash
git add content/articles/2026-02-14-my-article.md
git commit -m "Add first article"
git push
```

**Done!** Article appears in app within 1 minute.

---

## 🎯 URLs You Need

Replace `YOUR_USERNAME` in these URLs:

- **Live App:** `https://YOUR_USERNAME.github.io/SarvadarshiTarang/`
- **Feed JSON:** `https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/feed/news-feed.json`
- **Actions:** `https://github.com/YOUR_USERNAME/SarvadarshiTarang/actions`

---

## 📚 Full Documentation

- [Complete Setup Guide](GITHUB_SETUP.md) - Detailed step-by-step
- [Architecture](ARCHITECTURE.md) - How it works
- [Content Guide](docs/CONTENT_GUIDE.md) - Writing articles

---

## ✅ Done!

Your free news app is now:
- ✓ Live worldwide
- ✓ Auto-updating
- ✓ Cost: $0/month
- ✓ Ready for team collaboration

**Start publishing! 🎉**

# Quick Start Guide

Get your SarvadarshiTarang news app running in 30 minutes!

## 5-Minute Overview

**What is SarvadarshiTarang?**
- News app for Android & iOS
- Articles stored in GitHub (free)
- Push notifications via Firebase (free)
- Zero hosting costs
- Team collaboration via GitHub PRs

## Installation (5 minutes)

### Prerequisites

- GitHub account (free)
- Git installed
- Flutter installed
- Firebase account (free)

### Step 1: Clone Repository

```bash
git clone https://github.com/YOUR_USERNAME/SarvadarshiTarang.git
cd SarvadarshiTarang
```

### Step 2: Install Dependencies

```bash
# Install Flutter packages
flutter pub get

# Install iOS pods (macOS only)
cd ios && pod install && cd ..
```

### Step 3: Configure Firebase

1. Get `google-services.json` from Firebase Console
2. Place in `android/app/`

### Step 4: Run App

```bash
flutter run
```

Done! 🎉

## 30-Minute Setup

### 1. GitHub Repository Setup (5 min)

```bash
# Create new repo on GitHub
# Enable GitHub Pages: Settings → Pages → Deploy from main

git add .
git commit -m "Initial commit"
git push origin main
```

### 2. Create First Article (10 min)

```bash
# Create article markdown
cat > content/articles/2026-02-13-first.md << 'EOF'
---
title: "Welcome to SarvadarshiTarang"
description: "Your free news app is live"
image: "assets/welcome.jpg"
date: "2026-02-13"
author: "You"
category: "Tech"
blog_url: "https://yourblog.com"
---

# Welcome

First article content here...
EOF

git add content/
git commit -m "Add first article"
git push
```

### 3. Setup Workflows (10 min)

Copy workflow files to `.github/workflows/`:
- `generate-feed.yml`
- `notify-users.yml`

Copy scripts to `scripts/`:
- `generate_feed.py`
- `send_notifications.py`

Commit and push.

### 4. Test Everything (5 min)

1. Check GitHub Actions tab
2. Wait for workflow to complete
3. Visit: `https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json`
4. Should see your article in JSON!

## Common Tasks

### Write an Article

```bash
# Create branch
git checkout -b feature/new-article

# Create article
nano content/articles/2026-02-13-my-news.md

# Add image
cp ~/image.jpg content/assets/2026-02-13-my-news.jpg

# Commit
git add content/
git commit -m "Add article about news"
git push origin feature/new-article

# Create PR on GitHub
```

### Publish Article (When You're Editor)

1. Go to Pull Requests
2. Review article
3. Click "Merge" button
4. Article goes live automatically!

### Update App

```bash
# Get latest changes
git pull

# Rebuild
flutter clean
flutter pub get
flutter run
```

## Free Services Used

| Service | Use |
|---------|-----|
| **GitHub** | Code & content storage |
| **GitHub Pages** | Host JSON feed |
| **GitHub Actions** | Automate publishing |
| **Firebase** | Push notifications |
| **Flutter** | Mobile app (iOS + Android) |

**Total cost: $0** 🎉

## Next Steps

1. **[Content Guide](docs/CONTENT_GUIDE.md)** - How to write articles
2. **[Workflow Setup](docs/WORKFLOW_SETUP.md)** - Automate publishing
3. **[Mobile Setup](docs/MOBILE_SETUP.md)** - Build the app
4. **[Notifications](docs/NOTIFICATIONS_SETUP.md)** - Setup push notifications
5. **[Deployment](docs/DEPLOYMENT.md)** - Launch on App Store

## Troubleshooting

### App won't run?
```bash
flutter doctor          # Check setup
flutter clean           # Clean build
flutter pub get         # Get packages
flutter run             # Try again
```

### Feed not generating?
- Check GitHub Actions tab for errors
- Verify article format in `content/articles/`
- Check JSON syntax

### Notifications not working?
- Verify Firebase config
- Check app permissions
- Test in Firebase Console

## Getting Help

- **Flutter**: [flutter.dev/docs](https://flutter.dev/docs)
- **GitHub**: [github.com/support](https://github.com/support)
- **Firebase**: [console.firebase.google.com](https://console.firebase.google.com)

## Project Structure

```
SarvadarshiTarang/
├── content/                     # Your news content
│   ├── articles/               # Markdown articles
│   └── assets/                 # Images
├── mobile-app/                 # Flutter app
├── .github/workflows/          # GitHub Actions
├── scripts/                    # Python scripts
└── docs/                       # Documentation
```

## Key Commands

```bash
# Development
flutter run                 # Run app
flutter run --release      # Release mode

# Building
flutter build apk           # Build Android
flutter build appbundle     # Build for Play Store
flutter build ios           # Build iOS

# Git
git checkout -b feature/name # Create feature branch
git push origin feature/name # Push branch
git pull origin main         # Get latest

# Utilities
flutter doctor             # Check setup
flutter pub get            # Install packages
flutter clean              # Clean build
```

## Ready to Launch?

- [ ] GitHub repo created
- [ ] Article written
- [ ] Workflow tested
- [ ] App built
- [ ] Firebase configured
- [ ] Ready for play store!

👉 **[Full Deployment Guide](docs/DEPLOYMENT.md)**

---

**Questions?** Check the full documentation or create an issue on GitHub.

**Happy building!** 🚀

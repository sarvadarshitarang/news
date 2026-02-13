# 🚀 Deploy to Your Existing Repository

Your app is configured for: **https://github.com/sarvadarshitarang/news**

## ✅ Already Configured

- ✓ Repository URL: `sarvadarshitarang/news`
- ✓ GitHub Pages base: `/news/`
- ✓ Feed URL: Updated to your repo
- ✓ Web app: Built and ready

---

## 📤 Push to GitHub - Step by Step

### 1. Initialize Git (if not already)

```powershell
cd D:\repos\SarvadarshiTarang

# Check if git is initialized
git status
```

If you see "not a git repository", initialize:
```powershell
git init
```

### 2. Add Your Existing Remote

```powershell
# Add your existing repository
git remote add origin https://github.com/sarvadarshitarang/news.git

# Or if already added, update it
git remote set-url origin https://github.com/sarvadarshitarang/news.git

# Verify
git remote -v
```

### 3. Pull Existing Content (if any)

```powershell
# Fetch existing content from GitHub
git fetch origin

# Merge with existing content (if repository has files)
git pull origin main --allow-unrelated-histories

# Or if your default branch is 'master'
git pull origin master --allow-unrelated-histories
```

### 4. Add All Files

```powershell
# Stage all files
git add .

# Check what will be committed
git status
```

### 5. Commit

```powershell
git commit -m "Complete SarvadarshiTarang news app with Flutter + GitHub automation"
```

### 6. Set Branch Name

```powershell
# Make sure you're on main branch
git branch -M main
```

### 7. Push to GitHub

```powershell
# Push everything
git push -u origin main

# If you encounter errors about divergent branches:
git push -u origin main --force
```

---

## 🔧 Enable GitHub Pages

### On GitHub Website:

1. Go to https://github.com/sarvadarshitarang/news
2. Click **Settings** tab
3. Click **Pages** in left sidebar
4. Under "Build and deployment":
   - Source: Select **GitHub Actions**
5. Save

### That's it! GitHub Actions will:
- ✓ Deploy your app automatically
- ✓ Generate JSON feed from articles
- ✓ Update on every push

---

## ⏱️ Wait for Deployment

1. Go to **Actions** tab: https://github.com/sarvadarshitarang/news/actions
2. Watch "Deploy to GitHub Pages" workflow
3. Wait 2-3 minutes
4. Your app will be live!

---

## 🌐 Your URLs

After deployment completes:

**Live App:**
```
https://sarvadarshitarang.github.io/news/
```

**Feed JSON:**
```
https://raw.githubusercontent.com/sarvadarshitarang/news/main/feed/news-feed.json
```

**Repository:**
```
https://github.com/sarvadarshitarang/news
```

---

## 📝 Add Your First Article

After deployment, create new articles:

```powershell
# Create article file
code content/articles/2026-02-14-my-article.md
```

Add content:
```markdown
---
title: "My First News Article"
description: "This is an exciting news update!"
author: "Your Name"
category: "Tech"
image_url: "https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800"
image_alt: "News"
blog_url: "https://yourblog.com/article"
---

Your article content here!
```

Push to publish:
```powershell
git add content/articles/2026-02-14-my-article.md
git commit -m "Add new article"
git push
```

**Auto-updates in 1 minute!** 🎉

---

## 🔍 Troubleshooting

### "Failed to push"
Try:
```powershell
git pull origin main --rebase
git push
```

### "Permission denied"
You need to authenticate:
- Use Personal Access Token (recommended)
- Or GitHub Desktop app
- Or SSH keys

Create token: https://github.com/settings/tokens

### "Pages not deploying"
1. Check repository is **Public** (Settings → Danger Zone)
2. Verify Pages source is **GitHub Actions**
3. Check Actions tab for errors

---

## ✅ Quick Checklist

- [ ] Git initialized
- [ ] Remote added: `sarvadarshitarang/news`
- [ ] Files committed
- [ ] Pushed to GitHub
- [ ] Pages enabled (GitHub Actions)
- [ ] Wait 2-3 minutes
- [ ] Visit: https://sarvadarshitarang.github.io/news/
- [ ] Test article creation
- [ ] Share with team!

---

## 🎉 You're Live!

Your serverless news app is now:
- ✓ Accessible worldwide
- ✓ Auto-updating on every push
- ✓ $0 hosting cost
- ✓ Ready for team collaboration

**Start publishing!** 📰

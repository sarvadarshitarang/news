# GitHub Actions Workflow Setup

This guide explains the automated workflows that power SarvadarshiTarang.

## Overview

GitHub Actions automatically:
1. ✅ Validates article format
2. 🔄 Converts markdown to JSON
3. 📸 Optimizes images
4. 📤 Publishes to GitHub Pages
5. 🔔 Sends push notifications
6. 📊 Tracks analytics

## Workflow Files

### 1. Generate Feed Workflow

**File**: `.github/workflows/generate-feed.yml`

Triggers on:
- Push to `main` branch
- Manual trigger (workflow_dispatch)

**What it does**:
```
Content Change
    ↓
GitHub Actions Triggers
    ↓
Validate Markdown Format
    ↓
Process Frontmatter (YAML)
    ↓
Convert Images to URLs
    ↓
Generate JSON Feed
    ↓
Publish to docs/ (GitHub Pages)
    ↓
Update feed.json & feed.xml
```

### 2. Notification Workflow

**File**: `.github/workflows/notify-users.yml`

Triggers on:
- Feed generation success
- Manual trigger

**What it does**:
```
Feed Updated
    ↓
Extract Latest Article
    ↓
Send Firebase Notifications
    ↓
Log notification stats
    ↓
Update notification history
```

## Setting Up Workflows

### Step 1: Enable GitHub Pages

1. Go to repository **Settings**
2. Navigate to **Pages**
3. Under "Build and deployment":
   - Source: Deploy from a branch
   - Branch: `main`
   - Folder: `/(root)`
4. Click Save

Your site will be available at: `https://YOUR_USERNAME.github.io/SarvadarshiTarang/`

### Step 2: Create Workflow Files

Create `.github/workflows/generate-feed.yml`:

```yaml
name: Generate News Feed

on:
  push:
    branches: [main]
    paths:
      - 'content/articles/**'
      - 'content/assets/**'
  workflow_dispatch:

permissions:
  contents: read
  pages: write
  id-token: write

jobs:
  generate-feed:
    runs-on: ubuntu-latest
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: |
          pip install pyyaml markdown2 Pillow requests
      
      - name: Generate JSON feed
        run: python scripts/generate_feed.py
      
      - name: Validate JSON
        run: python scripts/validate_feed.py
      
      - name: Commit and push changes
        run: |
          git config --local user.email "action@github.com"
          git config --local user.name "GitHub Action"
          git add dist/
          git commit -m "chore: auto-generate news feed" || echo "No changes"
          git push
      
      - name: Trigger notification workflow
        if: success()
        run: |
          gh workflow run notify-users.yml
        env:
          GH_TOKEN: ${{ secrets.GITHUB_TOKEN }}
```

Create `.github/workflows/notify-users.yml`:

```yaml
name: Send Notifications

on:
  workflow_run:
    workflows: ["Generate News Feed"]
    types: [completed]
  workflow_dispatch:

jobs:
  notify:
    runs-on: ubuntu-latest
    if: github.event.workflow_run.conclusion == 'success'
    
    steps:
      - uses: actions/checkout@v3
      
      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install requests firebase-admin
      
      - name: Send notifications
        run: python scripts/send_notifications.py
        env:
          FIREBASE_CREDENTIALS: ${{ secrets.FIREBASE_CREDENTIALS }}
          FCM_SERVER_KEY: ${{ secrets.FCM_SERVER_KEY }}
```

### Step 3: Create Python Scripts

Create `scripts/generate_feed.py`:

```python
import os
import json
import yaml
import markdown2
from pathlib import Path
from datetime import datetime
from PIL import Image
import hashlib

def read_frontmatter(content):
    """Extract YAML frontmatter from markdown"""
    if not content.startswith('---'):
        raise ValueError("No frontmatter found")
    
    parts = content.split('---', 2)
    frontmatter = yaml.safe_load(parts[1])
    body = parts[2].strip()
    
    return frontmatter, body

def process_article(filepath):
    """Convert markdown article to JSON"""
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Extract frontmatter
    frontmatter, body = read_frontmatter(content)
    
    # Convert markdown to HTML
    html_content = markdown2.markdown(body, extras=['tables', 'fenced-code-blocks'])
    
    # Generate article ID from filename
    article_id = filepath.stem.lower()
    
    # Build image URL
    image_path = frontmatter.get('image', '')
    if image_path:
        image_url = f"https://raw.githubusercontent.com/{os.getenv('GITHUB_REPOSITORY')}/main/{image_path}"
    else:
        image_url = ""
    
    # Create article object
    article = {
        "id": article_id,
        "title": frontmatter.get('title', ''),
        "description": frontmatter.get('description', ''),
        "image": {
            "url": image_url,
            "alt": frontmatter.get('title', '')
        },
        "date": f"{frontmatter.get('date', '')}T00:00:00Z",
        "author": frontmatter.get('author', ''),
        "category": frontmatter.get('category', ''),
        "content": html_content,
        "blog_url": frontmatter.get('blog_url', ''),
        "read_time": frontmatter.get('read_time', 5),
        "published_at": datetime.now().isoformat()
    }
    
    return article

def generate_feed():
    """Generate complete news feed"""
    articles = []
    
    # Find all article files
    articles_dir = Path('content/articles')
    if articles_dir.exists():
        for filepath in sorted(articles_dir.glob('*.md'), reverse=True):
            try:
                article = process_article(filepath)
                articles.append(article)
                print(f"✓ Processed: {filepath.name}")
            except Exception as e:
                print(f"✗ Error processing {filepath.name}: {e}")
    
    # Create feed metadata
    feed = {
        "meta": {
            "name": "SarvadarshiTarang",
            "description": "Daily news in shorts",
            "url": f"https://raw.githubusercontent.com/{os.getenv('GITHUB_REPOSITORY')}/main/dist/feed.json",
            "generated_at": datetime.now().isoformat(),
            "total_articles": len(articles)
        },
        "articles": articles
    }
    
    # Create output directory
    output_dir = Path('dist')
    output_dir.mkdir(exist_ok=True)
    
    # Write JSON feed
    with open(output_dir / 'feed.json', 'w', encoding='utf-8') as f:
        json.dump(feed, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Feed generated: {len(articles)} articles")
    return feed

if __name__ == '__main__':
    generate_feed()
```

Create `scripts/validate_feed.py`:

```python
import json
from pathlib import Path

def validate_feed():
    """Validate generated feed.json"""
    feed_path = Path('dist/feed.json')
    
    if not feed_path.exists():
        print("✗ feed.json not found")
        exit(1)
    
    try:
        with open(feed_path, 'r', encoding='utf-8') as f:
            feed = json.load(f)
        
        # Check structure
        assert 'meta' in feed, "Missing 'meta' field"
        assert 'articles' in feed, "Missing 'articles' field"
        
        # Check each article
        for article in feed['articles']:
            required_fields = ['id', 'title', 'description', 'image', 'date', 'author', 'category', 'blog_url']
            for field in required_fields:
                assert field in article, f"Missing field '{field}' in article"
        
        print(f"✓ Feed validation passed ({len(feed['articles'])} articles)")
        
    except Exception as e:
        print(f"✗ Feed validation failed: {e}")
        exit(1)

if __name__ == '__main__':
    validate_feed()
```

Create `scripts/send_notifications.py`:

```python
import json
import os
from pathlib import Path
from datetime import datetime, timedelta

def send_notifications():
    """Send push notifications for new articles"""
    
    # Read latest feed
    feed_path = Path('dist/feed.json')
    with open(feed_path, 'r', encoding='utf-8') as f:
        feed = json.load(f)
    
    if not feed['articles']:
        print("No articles to notify")
        return
    
    # Get latest article
    latest = feed['articles'][0]
    
    # Prepare notification
    notification = {
        "title": latest['title'][:80],  # Max 80 chars
        "body": latest['description'][:200],
        "article_id": latest['id'],
        "image": latest['image']['url'],
        "sent_at": datetime.now().isoformat()
    }
    
    print(f"Notification prepared: {notification['title']}")
    print(f"This would send to Firebase Cloud Messaging subscribers")
    
    # In production, use firebase-admin:
    # import firebase_admin
    # from firebase_admin import messaging
    # 
    # message = messaging.MulticastMessage(
    #     notification=messaging.Notification(
    #         title=notification['title'],
    #         body=notification['body']
    #     ),
    #     webpush=messaging.WebpushConfig(
    #         data={'article_id': notification['article_id']}
    #     ),
    # )
    # response = messaging.send_multicast(message)

if __name__ == '__main__':
    send_notifications()
```

### Step 4: Test the Workflow

1. Create a test article:
```bash
mkdir -p content/articles
cat > content/articles/2026-02-13-test.md << 'EOF'
---
title: "Test Article"
description: "Testing the workflow"
image: "assets/test.jpg"
date: "2026-02-13"
author: "Tester"
category: "Tech"
blog_url: "https://yourblog.com/test"
---

This is a test article.
EOF
```

2. Push to GitHub:
```bash
git add .
git commit -m "Add test article"
git push
```

3. Watch the workflow:
   - Go to **Actions** tab
   - Click **Generate News Feed**
   - Watch progress

4. Check output:
   - Go to **releases** tab
   - Look for `dist/feed.json`
   - Or access raw content URL

## Accessing Your Feed

### Raw JSON URL
```
https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json
```

### GitHub Pages URL (if enabled)
```
https://YOUR_USERNAME.github.io/SarvadarshiTarang/dist/feed.json
```

## Debugging Workflows

### View Logs
1. Go to **Actions** tab
2. Click the workflow run
3. Click the job name
4. Expand step details

### Common Issues

**Workflow doesn't trigger**
- Check branch name is `main`
- Verify paths in `on:` section
- Check file was actually modified

**Feed not generated**
- Check Python dependencies are installed
- Verify article format is correct
- Look for validation errors in logs

**Images not loading**
- Confirm image file exists in `content/assets/`
- Check image path in frontmatter
- Verify file is committed to Git

## Advanced: Scheduling Posts

Add cron trigger for scheduled publishing:

```yaml
on:
  schedule:
    - cron: '0 9 * * *'  # Daily at 9 AM UTC
  workflow_dispatch:
```

Then modify `generate_feed.py` to check `scheduled_publish` date.

## Monitoring

Check workflow statistics:
- **Actions** → **All workflows**
- See execution time and success rate
- Monitor usage (free tier: 2000 min/month)

---

**Next**: Setup mobile app in [MOBILE_SETUP.md](MOBILE_SETUP.md)

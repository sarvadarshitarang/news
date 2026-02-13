# 🚀 GitHub Setup & Deployment Guide

Complete guide to deploy SarvadarshiTarang on GitHub Pages with automated content updates.

## 📋 Prerequisites

- GitHub account (free)
- Git installed on your computer
- Your Flutter app (already built!)

---

## Part 1: Create GitHub Repository

### Step 1: Create New Repository

1. Go to https://github.com/new
2. Repository name: `SarvadarshiTarang`
3. Description: "Free serverless news app powered by GitHub"
4. **✓ Public** (required for free GitHub Pages)
5. **Don't** initialize with README (you already have files)
6. Click **Create repository**

### Step 2: Push Your Code

Open PowerShell in `D:\repos\SarvadarshiTarang` and run:

```powershell
# Initialize git (if not already)
git init

# Add all files
git add .

# Create first commit
git commit -m "Initial commit: SarvadarshiTarang news app"

# Add remote (replace YOUR_USERNAME)
git remote add origin https://github.com/YOUR_USERNAME/SarvadarshiTarang.git

# Set main branch
git branch -M main

# Push to GitHub
git push -u origin main
```

---

## Part 2: Enable GitHub Pages

### Step 1: Configure Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Click **Pages** in left sidebar
4. Under "Build and deployment":
   - Source: **GitHub Actions**
5. Save

### Step 2: Update Workflow File

Edit `.github/workflows/deploy-pages.yml`:

```yaml
run: flutter build web --release --base-href /SarvadarshiTarang/
```

Change `/SarvadarshiTarang/` to `/YOUR_REPO_NAME/`

### Step 3: Commit and Push

```powershell
git add .github/workflows/deploy-pages.yml
git commit -m "Update base href for GitHub Pages"
git push
```

### Step 4: Wait for Deployment

1. Go to **Actions** tab in your repository
2. Watch "Deploy to GitHub Pages" workflow run
3. Wait 2-3 minutes for completion
4. Your app will be live at: `https://YOUR_USERNAME.github.io/SarvadarshiTarang/`

---

## Part 3: Content Management Setup

### Understanding the Content Flow

```
Write Article          Convert to JSON       App Updates
(Markdown)      →      (GitHub Actions)  →   (Automatically)

content/articles/      scripts/             feed/
  2026-02-13-news.md   convert_articles.py  news-feed.json
```

### Article Format

Create files in `content/articles/` with this format:

**Filename:** `YYYY-MM-DD-article-title.md`

**Content:**
```markdown
---
title: "Your Article Title"
description: "Brief summary of the article (2-3 sentences)"
author: "Author Name"
category: "Tech"  # Tech, Business, Sports, Politics, Entertainment, Science, Health
image_url: "https://example.com/image.jpg"
image_alt: "Image description"
blog_url: "https://yourblog.com/full-article"
read_time: 5  # Optional, will be auto-calculated
---

Your article content here in **Markdown** format.

## Headings work great

- Bullet points
- More points

**Bold** and *italic* text supported.
```

### Step 1: Test Locally (Optional)

```powershell
# Install Python dependencies
pip install pyyaml

# Run conversion script
python scripts/convert_articles.py content/articles feed/news-feed.json

# Check the generated feed
cat feed/news-feed.json
```

### Step 2: Create Your First Article

1. Create new file: `content/articles/2026-02-14-my-first-post.md`
2. Add frontmatter and content
3. Commit and push:

```powershell
git add content/articles/2026-02-14-my-first-post.md
git commit -m "Add my first article"
git push
```

### Step 3: Watch Automation

1. Go to **Actions** tab
2. "Generate News Feed" workflow runs automatically
3. `feed/news-feed.json` updates automatically
4. Your app fetches new content!

---

## Part 4: Configure App to Use GitHub Feed

### Update API Service

Edit `test_news_app/lib/services/api_service.dart`:

```dart
class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  // UPDATE THIS URL with your GitHub username and repo
  static const String _baseUrl = 
    'https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/feed/news-feed.json';

  Future<Feed> fetchFeed() async {
    try {
      final response = await http.get(Uri.parse(_baseUrl));
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        return Feed.fromJson(jsonData);
      }
      
      // Fallback to mock data if GitHub is unavailable
      return _getMockFeed();
    } catch (e) {
      print('Error fetching feed: $e');
      return _getMockFeed();
    }
  }
  
  // ... rest of the code
}
```

### Rebuild and Redeploy

```powershell
# Rebuild web version
cd test_news_app
C:\flutter\bin\flutter.bat build web --release

# Commit changes
git add .
git commit -m "Connect app to GitHub feed"
git push
```

---

## Part 5: Team Collaboration Workflow

### Adding Team Members

1. Go to repository **Settings** → **Collaborators**
2. Click **Add people**
3. Enter their GitHub username
4. They'll receive invitation email

### Article Submission Process

**For Team Members:**

1. Clone repository: `git clone https://github.com/YOUR_USERNAME/SarvadarshiTarang.git`
2. Create new branch: `git checkout -b add-article-feb14`
3. Add article in `content/articles/`
4. Commit: `git commit -m "Add article about XYZ"`
5. Push: `git push origin add-article-feb14`
6. Create Pull Request on GitHub
7. Wait for review and approval

**For Reviewers (You):**

1. Go to **Pull Requests** tab
2. Review the article content
3. Add comments if changes needed
4. Click **Merge pull request** when ready
5. Automation publishes it immediately!

---

## Part 6: Using Free Blog Space

### Where to Host Full Articles

Your app shows summaries. For full articles, use free blog platforms:

#### Option A: GitHub Pages Blog (Jekyll)

Create `blog/` folder in your repo with Jekyll blog.

**URL:** `https://YOUR_USERNAME.github.io/SarvadarshiTarang/blog/article-name`

#### Option B: Medium

1. Create Medium account
2. Write full articles there
3. Use Medium URL in `blog_url` field

**Example:** `https://medium.com/@yourname/article-title`

#### Option C: Blogger (Google)

1. Create free Blogger blog: https://www.blogger.com
2. Get custom domain or use: `yourname.blogspot.com`
3. Write articles there
4. Link in app

#### Option D: Hashnode

1. Create account: https://hashnode.com
2. Free subdomain: `yourname.hashnode.dev`
3. Great for tech articles

### Recommendation

**Start with Medium** - it's easiest:
- No setup required
- Built-in audience
- Good SEO
- Professional look

---

## 📱 Part 7: Mobile App Distribution

### For Testing (Now)

Share your GitHub Pages URL:
`https://YOUR_USERNAME.github.io/SarvadarshiTarang/`

Works on all mobile browsers!

### For Production (Later)

**Android (Google Play):**
1. Install Android Studio (includes SDK)
2. Build: `flutter build appbundle --release`
3. Upload to Play Console ($25 one-time)

**iOS (App Store):**
1. Need Mac computer
2. Apple Developer account ($99/year)
3. Build: `flutter build ios --release`

---

## 🎯 Summary Checklist

- [ ] Create GitHub repository
- [ ] Push all code
- [ ] Enable GitHub Pages
- [ ] Update base-href in workflow
- [ ] Wait for deployment
- [ ] Update API URL in app
- [ ] Create first article
- [ ] Test feed generation
- [ ] Choose blog platform for full articles
- [ ] Share app URL with team
- [ ] Set up team collaboration
- [ ] Add team members (optional)

---

## 🔗 Important URLs (Save These!)

```
Repository: https://github.com/YOUR_USERNAME/SarvadarshiTarang
Live App:   https://YOUR_USERNAME.github.io/SarvadarshiTarang/
Feed JSON:  https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/feed/news-feed.json
Actions:    https://github.com/YOUR_USERNAME/SarvadarshiTarang/actions
```

---

## 🆘 Troubleshooting

### App shows "No articles"
- Check if `feed/news-feed.json` exists in repository
- Verify GitHub Actions ran successfully
- Ensure API URL in app is correct

### Articles not updating
- Check "Generate News Feed" workflow in Actions
- Verify markdown files have correct frontmatter
- Push to main/master branch triggers automation

### Pages deployment fails
- Verify Pages is enabled in Settings
- Check that repository is **Public**
- Ensure workflow file syntax is correct

---

## 🎉 You're Done!

Your app is now live and accessible worldwide:
- **Free** hosting forever
- **Automatic** content updates
- **Collaborative** article submission
- **Zero** maintenance costs

**Next Steps:**
1. Share your app URL
2. Start publishing articles
3. Invite team members
4. Promote your news platform!

Need help? Check GitHub Issues or Actions logs for debugging.

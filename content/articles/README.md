# 📰 Content Articles

This folder contains all your news articles in Markdown format.

## 📝 How to Add Articles

### 1. Create New File

Filename format: `YYYY-MM-DD-article-title.md`

Example: `2026-02-14-breaking-news.md`

### 2. Article Template

```markdown
---
title: "Your Article Title Here"
description: "Brief 2-3 sentence summary that appears in the feed"
author: "Author Name"
category: "Tech"
image_url: "https://images.unsplash.com/photo-xxxxx?w=800"
image_alt: "Description of image"
blog_url: "https://yourblog.com/full-article-url"
read_time: 5
---

Your full article content here in **Markdown**.

## You can use headings

- Bullet points
- Lists
- **Bold text**
- *Italic text*

Add as much content as you want!
```

### 3. Categories

Choose one:
- `Tech` - Technology news
- `Business` - Business & finance
- `Sports` - Sports news
- `Politics` - Political news
- `Entertainment` - Movies, music, culture
- `Science` - Science & research
- `Health` - Health & wellness

### 4. Finding Images

**Free image sources:**
- [Unsplash](https://unsplash.com) - Use direct image URLs
- [Pexels](https://pexels.com)
- [Pixabay](https://pixabay.com)

**Format:** Use `?w=800&h=400&fit=crop` for optimal size

### 5. Blog URL

This is where readers go for the full article. Options:

- **Medium:** `https://medium.com/@yourname/article`
- **Blogger:** `https://yourname.blogspot.com/article`
- **Hashnode:** `https://yourname.hashnode.dev/article`
- **Your website:** Any URL you own

## 🤖 Automatic Processing

When you commit and push:

1. ✓ GitHub Actions runs automatically
2. ✓ Converts markdown to JSON
3. ✓ Updates `feed/news-feed.json`
4. ✓ App fetches new content

**No manual steps needed!**

## 📁 Folder Structure

```
content/articles/
├── 2026-02-13-welcome.md              ← Newest first
├── 2026-02-12-collaboration.md
├── 2026-02-11-mobile-first.md
└── 2026-02-10-older-article.md        ← Older articles
```

Files are automatically sorted by date (newest first in the app).

## ✏️ Editing Articles

To update an existing article:

1. Edit the `.md` file
2. Commit and push
3. Wait 1 minute for automation
4. Article updates in app!

## 🗑️ Deleting Articles

To remove an article:

1. Delete the `.md` file
2. Commit and push
3. Article disappears from feed

## 👥 Team Workflow

### For Team Members:

```bash
# 1. Create branch
git checkout -b add-my-article

# 2. Add your article file
# (create 2026-XX-XX-title.md)

# 3. Commit
git add content/articles/2026-XX-XX-title.md
git commit -m "Add article: Your Title"

# 4. Push
git push origin add-my-article

# 5. Create Pull Request on GitHub
# 6. Wait for review and approval
```

### For Reviewers:

1. Check Pull Requests tab
2. Review article content
3. Request changes if needed
4. Merge when ready → auto-publishes!

## 🎯 Best Practices

### Article Length
- **Teaser:** 100-200 words in markdown
- **Full article:** Link to blog for complete content

### Images
- **Required:** Good quality image
- **Size:** Minimum 800x400px
- **Format:** JPG or PNG
- **Source:** Free stock photos

### Writing Style
- Clear, concise headlines
- Engaging descriptions
- Proper grammar and spelling
- Fact-check before publishing

### SEO Tips
- Use relevant keywords in title
- Write compelling descriptions
- Add alt text for images
- Link to authoritative sources

## 📊 Example Articles

Check the existing `.md` files in this folder for examples!

## ❓ Need Help?

- Check [GITHUB_SETUP.md](../GITHUB_SETUP.md) for detailed guide
- See [CONTENT_GUIDE.md](../docs/CONTENT_GUIDE.md) for writing tips
- Review [QUICKSTART.md](../QUICKSTART.md) for quick reference

---

**Ready to publish?** Create your first article and push to GitHub! 🚀

# Content Creation Guide

## Writing Articles

### File Structure

Store all articles in `content/articles/` directory:

```
content/articles/
├── 2026-02-13-breaking-news.md
├── 2026-02-12-tech-update.md
└── 2026-02-11-world-news.md
```

**Naming Convention**: `YYYY-MM-DD-slug.md`
- Use date prefix for automatic sorting
- Use lowercase with hyphens in slug
- Keep slugs descriptive but short

### Article Format

Every article must include a YAML frontmatter section:

```markdown
---
title: "Breaking News: New Tech Released"
description: "A short one-liner summary (max 100 chars)"
image: "assets/breaking-news.jpg"
date: "2026-02-13"
author: "John Doe"
category: "Technology"
blog_url: "https://yourblog.com/full-article"
read_time: 5
---

# Article Title

Your article content starts here. You can use **bold**, *italic*, 
[links](https://example.com), and `code`.

## Section Header

More content...

---

[Read full story on our blog](https://yourblog.com/full-article)
```

### Frontmatter Fields Explained

| Field | Required | Format | Example |
|-------|----------|--------|---------|
| `title` | Yes | String | "Breaking News Title" |
| `description` | Yes | String (max 100 chars) | "Short summary" |
| `image` | Yes | Path to image | "assets/news-image.jpg" |
| `date` | Yes | YYYY-MM-DD | "2026-02-13" |
| `author` | Yes | String | "Reporter Name" |
| `category` | Yes | String | "Politics", "Tech", "Sports" |
| `blog_url` | Yes | Full URL | "https://yourblog.com/..." |
| `read_time` | Optional | Number (minutes) | 5 |

### Content Best Practices

#### Title Guidelines
- Keep under 70 characters
- Use active voice
- Create urgency if breaking news
- Examples:
  - ✅ "New AI Model Breaks Records"
  - ❌ "Artificial Intelligence Updates"

#### Description/Summary
- Maximum 100 characters
- Entice users to open
- Should appear in news feed
- Examples:
  - ✅ "Game-changing technology announced today"
  - ❌ "This article discusses technology"

#### Image Guidelines
- **Size**: 800x600px (or 16:9 aspect ratio)
- **Format**: JPEG or PNG
- **File Size**: Under 300KB
- **Path**: Always relative to `content/` folder
- **Storage**: Place in `content/assets/`

#### Content Writing
- Keep paragraphs short (3-4 lines max)
- Use subheadings to break up content
- First 2-3 sentences should summarize news
- Mobile-friendly formatting
- Avoid tables (use bullet points instead)
- Link to full article on your blog

### Complete Article Example

```markdown
---
title: "India Launches New Space Initiative"
description: "Historic moment as India announces groundbreaking space program"
image: "assets/space-initiative.jpg"
date: "2026-02-13"
author: "Tech Reporter"
category: "Space"
blog_url: "https://yourblog.com/india-space-2026"
read_time: 4
---

# India Launches Ambitious New Space Initiative

India made headlines today with an unprecedented commitment to space exploration.

## The Announcement

Officials announced a $500 million program focused on:
- Satellite communications
- Moon exploration
- Space infrastructure

## What This Means

This is the most significant investment in decades. Experts believe it will:

1. Create 1000+ jobs
2. Boost tech sector
3. Enable new discoveries

## Expert Opinion

"This could change everything," said Dr. Sharma, space analyst.

---

[Read the full analysis on our blog →](https://yourblog.com/india-space-2026)
```

## Image Management

### Adding Images

1. Create image file (JPEG/PNG)
2. Optimize size (use TinyPNG or similar)
3. Save to `content/assets/YYYY-MM-DD-name.jpg`
4. Reference in article: `assets/YYYY-MM-DD-name.jpg`

### Image Optimization

Use free tools:
- **TinyPNG.com** - Compress images
- **Pixlr.com** - Quick edits
- **Canva.com** - Design graphics

### Naming Images
```
content/assets/
├── 2026-02-13-breaking-news.jpg
├── 2026-02-13-breaking-news-thumbnail.jpg
└── 2026-02-12-tech-update.jpg
```

## Creating Pull Requests

### Step 1: Create Feature Branch
```bash
git checkout -b feature/news-article-feb-13
```

### Step 2: Add Your Article
```bash
# Create article
nano content/articles/2026-02-13-breaking-news.md

# Add image
cp ~/Downloads/image.jpg content/assets/2026-02-13-breaking-news.jpg
```

### Step 3: Commit Changes
```bash
git add content/
git commit -m "Add article: Breaking News Title"
```

### Step 4: Push and Create PR
```bash
git push origin feature/news-article-feb-13
```

Then create PR via GitHub web interface.

### Step 5: PR Description Template

```markdown
## Article Details

**Title:** Breaking News Title
**Category:** Technology
**Author:** Your Name

## Summary
One paragraph about the news.

## Links
- Blog Article: https://yourblog.com/...
- Source: https://source.com/...

## Checklist
- [ ] Image optimized (< 300KB)
- [ ] Description under 100 chars
- [ ] Blog URL included
- [ ] No typos or broken links
```

## Content Categories

Use these standard categories:

- **Tech** - Technology, gadgets, startups
- **Business** - Markets, economy, companies
- **Politics** - Government, elections, policy
- **Sports** - Games, athletes, events
- **Entertainment** - Movies, music, celebrities
- **Science** - Research, discoveries, space
- **Health** - Medicine, wellness, lifestyle
- **World** - International news
- **Local** - Community news
- **Opinion** - Analysis, columns

## Scheduling Content (Advanced)

For scheduled publishing, add to frontmatter:

```yaml
---
title: "Scheduled Article"
scheduled_publish: "2026-02-20T09:00:00Z"
---
```

Then create a GitHub Actions workflow to check `scheduled_publish` time.

## Troubleshooting

### Image Not Showing?
- Check file exists in `content/assets/`
- Verify path in markdown is correct
- Ensure image is under 5MB

### Article Not Appearing?
- Check YAML frontmatter syntax (colon spacing)
- Verify all required fields present
- Look for GitHub Actions error in workflow logs

### PR Rejected?
- Check article format against this guide
- Verify spelling and links
- Ask for specific feedback in comments

## Tools for Writing

### Web-based Options
- **HackMD.io** - Write with live preview
- **StackEdit.io** - Full markdown editor
- **Dillinger.io** - Simple markdown editor

### Desktop Options
- **VS Code** - With markdown preview
- **Typora** - Minimal markdown editor
- **iA Writer** - Distraction-free writing

## Tips for Regular Content

1. **Create a Schedule**: Decide when new articles go live
2. **Template Your Articles**: Copy the structure above
3. **Batch Process**: Write multiple articles at once
4. **Use Checklists**: Check all fields before PR
5. **Set Reminders**: Publish consistently
6. **Engage Readers**: Use your blog links strategically

---

**Happy writing!** 📝

Questions? Check the main README or create an issue.

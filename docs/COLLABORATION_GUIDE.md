# Collaboration & Team Workflow Guide

SarvadarshiTarang is designed for team collaboration. Multiple people can contribute news articles, and you control what gets published.

## Workflow Overview

```
Contributor → Feature Branch → PR → You Review → Merge → Auto-Deploy

✓ Content never pushed directly to main
✓ All changes reviewed before publication
✓ Automatic feedback & validation
✓ Full git history of who wrote what
```

## Setting Up Team Access

### 1. Add Collaborators to Repository

1. Go to repository **Settings**
2. Click **Collaborators** (left sidebar)
3. Click **Add people**
4. Enter GitHub username
5. Choose role:
   - **Pull access**: Read only
   - **Push access**: Can commit (use with caution)
   - **Maintain**: Can manage + merge
   - **Admin**: Full control

**Recommended Setup**:
- **Contributors**: `Pull access` (submit via PRs)
- **Editors**: `Maintain` (can review & merge)
- **You**: `Admin` (full control)

### 2. Configure Branch Protection

Prevent accidental direct pushes to main:

1. Go to **Settings** → **Branches**
2. Click **Add rule** (next to "Branch protection rules")
3. Pattern name: `main`
4. Check:
   - ✓ Require a pull request before merging
   - ✓ Require approvals (1+ reviews)
   - ✓ Require status checks to pass
   - ✓ Require branches to be up to date
5. Click **Create**

### 3. Setup PR Templates

Create `.github/pull_request_template.md`:

```markdown
## Article Submission

### Details
- **Title**: [Article Title]
- **Category**: [Tech/Politics/Sports/etc]
- **Author**: [Your Name]

### Summary
[2-3 sentence summary of the news]

### Verification Checklist
- [ ] Article title is clear and compelling
- [ ] Description is under 100 characters
- [ ] Image is optimized (< 300KB)
- [ ] All frontmatter fields complete
- [ ] Links to blog article included
- [ ] No broken links or typos
- [ ] Image has proper alt text
- [ ] Date field is correctly formatted

### Related Links
- Blog article: [link]
- Source: [link]

---

*By submitting this PR, I confirm the content is original and accurate.*
```

## Contributor Workflow

### For Contributors (Team Members)

#### Step 1: Setup Local Repository

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/SarvadarshiTarang.git
cd SarvadarshiTarang

# Create feature branch (change name!)
git checkout -b feature/article-feb-13

# Or create from issue
git checkout -b article/202-breaking-news
```

#### Step 2: Write Article

```bash
# Add article
nano content/articles/2026-02-13-breaking-news.md

# Add image
cp ~/Downloads/image.jpg content/assets/2026-02-13-breaking-news.jpg

# Verify format
git status
```

#### Step 3: Commit Changes

```bash
# Stage changes
git add content/

# Commit with descriptive message
git commit -m "feat: add breaking news article

- Topic: Breaking Tech News
- Author: John Doe
- Sources: [list sources]"

# View your changes
git log --oneline -n 3
```

#### Step 4: Push and Create PR

```bash
# Push to GitHub
git push origin feature/article-feb-13

# GitHub will show a link to create PR
```

Then on GitHub:

1. Click **Compare & pull request**
2. Fill PR title: "Add: Breaking News Article"
3. Use PR template for description
4. Click **Create pull request**
5. Wait for feedback

#### Step 5: Address Feedback

If reviewer requests changes:

```bash
# Make edits locally
nano content/articles/2026-02-13-breaking-news.md

# Commit changes
git add .
git commit -m "fix: address reviewer feedback"

# Push (auto-updates PR)
git push origin feature/article-feb-13
```

#### Step 6: Merged! 🎉

Once approved and merged:
- Article auto-publishes to feed
- Push notification sent
- Article appears in news app
- Contributors get credit

### For Editors (Approvers)

#### Review Article

1. Go to **Pull Requests** tab
2. Click the PR
3. Review changes:
   - Click **Files changed**
   - Check article formatting
   - Verify image presence
   - Look for typos/accuracy

#### Approve or Request Changes

**To Approve**:
1. Click **Review changes**
2. Select **Approve**
3. Click **Submit review**
4. Click **Merge pull request**

**To Request Changes**:
1. Click **Review changes**
2. Select **Request changes**
3. Add comment with specific feedback
4. Click **Submit review**

#### Example Review Comments

```markdown
Great article! A few notes:

- [ ] Title could be more compelling
      "Breakthrough in AI\n Technology" → "AI Makes Historic Breakthrough"
      
- [ ] Image quality is low, please optimize
      Size: 2.5MB → target < 300KB (use TinyPNG)
      
- [ ] Blog link is broken: ...
      Updated link should be: https://yourblog.com/new-link
      
- [ ] Author name missing from frontmatter

After addressing these, happy to merge! 👍
```

## GitHub Issues for Planning

### Create Issue for News Ideas

1. Go to **Issues** tab
2. Click **New issue**
3. Title: "Article: [topic]"
4. Description:
```markdown
## Story Idea
Brief summary of the news

## Deadline
When should this be published?

## Sources
- Source 1: link
- Source 2: link

## Assigned To
@contributor-name
```

### Link Commits to Issues

When committing:

```bash
git commit -m "feat: write breaking news article

Closes #42"
```

Then PR automatically links to issue.

## Approval Workflow

### Flow Diagram

```
Author Creates Branch
        ↓
Author Commits Article
        ↓
Author Creates PR (with template)
        ↓
Author Requests Review
        ↓
GitHub Actions: Validate Format
        ↓
You Review Code Changes
        ↓
You Request Changes OR Approve
        ↓
(If Changes Needed:)
Author Updates + Pushes
(PR auto-updates)
        ↓
You Review Again
        ↓
Approve → Merge
        ↓
GitHub Actions Trigger:
  1. Generate JSON
  2. Publish to GitHub Pages
  3. Send Notifications
        ↓
Article Live in App! 🚀
```

## Setting Up Automated Checks

### Run Linting on PR

Add to `.github/workflows/lint.yml`:

```yaml
name: Validate Content

on:
  pull_request:
    paths:
      - 'content/**'

jobs:
  lint:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Validate articles
        run: |
          python scripts/validate_articles.py
```

**scripts/validate_articles.py**:

```python
import os
import yaml
from pathlib import Path

def validate_articles():
    """Validate all markdown files"""
    errors = 0
    
    for filepath in Path('content/articles').glob('*.md'):
        with open(filepath, 'r') as f:
            content = f.read()
        
        # Check frontmatter
        if not content.startswith('---'):
            print(f"✗ {filepath}: Missing frontmatter")
            errors += 1
            continue
        
        # Parse YAML
        try:
            parts = content.split('---')[1]
            frontmatter = yaml.safe_load(parts)
            
            # Check required fields
            required = ['title', 'date', 'author', 'category', 'blog_url']
            for field in required:
                if field not in frontmatter:
                    print(f"✗ {filepath}: Missing '{field}'")
                    errors += 1
            
            # Check constraints
            if len(frontmatter.get('description', '')) > 100:
                print(f"✗ {filepath}: Description too long")
                errors += 1
            
            if not frontmatter.get('description'):
                print(f"✗ {filepath}: Missing description")
                errors += 1
        
        except Exception as e:
            print(f"✗ {filepath}: Invalid YAML - {e}")
            errors += 1
    
    if errors > 0:
        exit(1)
    print("✓ All articles valid")

if __name__ == '__main__':
    validate_articles()
```

## Managing Permissions

### Access Levels

| Role | Can Commit | Can Review | Can Merge | Can Delete |
|------|-----------|----------|---------|-----------|
| **Pull** | ❌ | ❌ | ❌ | ❌ |
| **Triage** | ❌ | ✅ | ❌ | ❌ |
| **Push** | ✅ | ✅ | ❌ | ❌ |
| **Maintain** | ✅ | ✅ | ✅ | ❌ |
| **Admin** | ✅ | ✅ | ✅ | ✅ |

**Recommended**:
- Content contributors: `Pull` → Submit PRs
- Editors: `Maintain` → Can merge
- You: `Admin` → Full control

## Common Scenarios

### Scenario 1: Typo Found After Publishing

```bash
# Create hotfix branch
git checkout main
git pull
git checkout -b hotfix/typo-fix-article-123

# Make fix
nano content/articles/filename.md

# Commit
git add content/
git commit -m "fix: correct typo in article title"
git push origin hotfix/typo-fix-article-123

# Create PR (can be merged immediately)
# Feed auto-regenerates with fix
```

### Scenario 2: Contributor Not Responding

1. Go to **Pull Requests**
2. Search for stale PRs
3. Leave comment:
   ```markdown
   Hi @contributor, 
   It's been 7 days without response. 
   We'll close this PR if no update by [date].
   Feel free to reopen if you'd like to continue!
   ```
4. Close if needed

### Scenario 3: Multiple Contributors Same Day

Each creates own branch:
- `feature/article-feb13-elections`
- `feature/article-feb13-sports`
- `feature/article-feb13-tech`

All can be PRs simultaneously, you merge in order.

## Writing Contributing Guidelines

Create `CONTRIBUTING.md`:

```markdown
# Contributing to SarvadarshiTarang

Thank you for helping keep our news fresh! 📰

## How to Contribute

1. Fork the repository
2. Create feature branch: `git checkout -b feature/article-topic`
3. Write article in `content/articles/`
4. Add image to `content/assets/`
5. Commit: `git commit -m "feat: add article about topic"`
6. Push: `git push origin feature/article-topic`
7. Create Pull Request with template
8. Wait for review
9. Address feedback if needed
10. Once approved, we'll merge! 🎉

## Article Requirements

- Follow [Content Guide](docs/CONTENT_GUIDE.md)
- Include all frontmatter fields
- Image under 300KB
- Description under 100 characters
- Include link to full article

## Code of Conduct

- Be respectful
- No misinformation
- Cite credible sources
- No plagiarism
- Keep content newsworthy

## Questions?

Create an issue or contact @you

---

Happy contributing! 📝
```

## Team Communication

### Use GitHub Discussions for Chat

1. Go to **Discussions**
2. Create category: "Announcements"
3. Team members can discuss there
4. Link discussions to PRs

### Use Issues for Task Management

- Assign articles to contributors
- Track progress
- Set milestones: "Week of Feb 13"
- Use labels: "breaking-news", "urgent", "draft"

## Metrics to Track

Check **Insights** → **Contributors**:
- Who contributed what
- Contribution frequency
- Most active contributors

---

**Next**: Deploy guide in [DEPLOYMENT.md](DEPLOYMENT.md)

**Happy collaborating!** 🤝

#!/usr/bin/env python3
"""
Convert markdown articles to JSON feed for SarvadarshiTarang news app
Runs automatically via GitHub Actions on every push
"""

import os
import json
import yaml
import re
from datetime import datetime
from pathlib import Path

def extract_frontmatter(content):
    """Extract YAML frontmatter from markdown content"""
    pattern = r'^---\s*\n(.*?)\n---\s*\n(.*)'
    match = re.match(pattern, content, re.DOTALL)
    
    if match:
        frontmatter = yaml.safe_load(match.group(1))
        markdown_content = match.group(2)
        return frontmatter, markdown_content
    return {}, content

def markdown_to_html(markdown_text):
    """Convert markdown to simple HTML (basic conversion)"""
    # Basic conversions - for production, use markdown library
    html = markdown_text
    html = re.sub(r'\*\*(.+?)\*\*', r'<strong>\1</strong>', html)
    html = re.sub(r'\*(.+?)\*', r'<em>\1</em>', html)
    html = re.sub(r'\n\n', r'</p><p>', html)
    html = f'<p>{html}</p>'
    html = html.replace('<p></p>', '')
    return html

def calculate_read_time(content):
    """Calculate estimated read time in minutes"""
    words = len(content.split())
    minutes = max(1, round(words / 200))  # Assuming 200 words per minute
    return minutes

def process_article(file_path):
    """Process a single markdown article file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        frontmatter, markdown_content = extract_frontmatter(content)
        
        # Required fields validation
        required_fields = ['title', 'description', 'author', 'category', 'blog_url']
        for field in required_fields:
            if field not in frontmatter:
                print(f"Warning: Missing required field '{field}' in {file_path}")
                return None
        
        # Extract date from filename (YYYY-MM-DD-title.md) or use file date
        filename = os.path.basename(file_path)
        date_match = re.match(r'(\d{4}-\d{2}-\d{2})', filename)
        
        if date_match:
            date_str = date_match.group(1)
        elif 'date' in frontmatter:
            date_str = frontmatter.get('date')
        else:
            # Use file creation date as fallback
            file_stat = os.stat(file_path)
            date_str = datetime.fromtimestamp(file_stat.st_ctime).strftime('%Y-%m-%d')
        
        # Convert markdown to HTML
        html_content = markdown_to_html(markdown_content)
        
        # Calculate read time
        read_time = frontmatter.get('read_time') or calculate_read_time(markdown_content)
        
        # Build article object
        article = {
            'id': frontmatter.get('id') or filename.replace('.md', ''),
            'title': frontmatter['title'],
            'description': frontmatter['description'],
            'image': {
                'url': frontmatter.get('image_url', ''),
                'alt': frontmatter.get('image_alt', frontmatter['title'])
            },
            'date': date_str,
            'author': frontmatter['author'],
            'category': frontmatter['category'],
            'content': html_content,
            'blog_url': frontmatter['blog_url'],
            'read_time': read_time
        }
        
        return article
        
    except Exception as e:
        print(f"Error processing {file_path}: {str(e)}")
        return None

def generate_feed(articles_dir, output_file):
    """Generate JSON feed from all markdown articles"""
    articles = []
    
    # Find all .md files in articles directory
    articles_path = Path(articles_dir)
    if not articles_path.exists():
        print(f"Error: Articles directory not found: {articles_dir}")
        return False
    
    md_files = sorted(articles_path.glob('*.md'), reverse=True)
    
    for md_file in md_files:
        if md_file.name.startswith('_'):  # Skip files starting with _
            continue
            
        article = process_article(md_file)
        if article:
            articles.append(article)
            print(f"✓ Processed: {md_file.name}")
    
    if not articles:
        print("Warning: No articles found!")
        # Create a default article
        articles = [{
            'id': 'welcome',
            'title': 'Welcome to SarvadarshiTarang',
            'description': 'Your news app is ready! Start adding articles to the content/articles/ folder.',
            'image': {
                'url': 'https://images.unsplash.com/photo-1504711434969-e33886168f5c?w=800',
                'alt': 'Welcome'
            },
            'date': datetime.now().strftime('%Y-%m-%d'),
            'author': 'SarvadarshiTarang Team',
            'category': 'Tech',
            'content': '<p>Start publishing by adding markdown files to content/articles/</p>',
            'blog_url': 'https://github.com/yourusername/SarvadarshiTarang',
            'read_time': 1
        }]
    
    # Build complete feed
    feed = {
        'meta': {
            'title': 'SarvadarshiTarang News Feed',
            'description': 'Latest news and updates',
            'last_updated': datetime.now().isoformat(),
            'total_articles': len(articles),
            'version': '1.0'
        },
        'articles': articles
    }
    
    # Write JSON output
    output_path = Path(output_file)
    output_path.parent.mkdir(parents=True, exist_ok=True)
    
    with open(output_path, 'w', encoding='utf-8') as f:
        json.dump(feed, f, indent=2, ensure_ascii=False)
    
    print(f"\n✓ Generated feed with {len(articles)} articles")
    print(f"✓ Output: {output_file}")
    return True

if __name__ == '__main__':
    # Default paths
    articles_dir = 'content/articles'
    output_file = 'feed/news-feed.json'
    
    # Allow command line arguments
    import sys
    if len(sys.argv) > 1:
        articles_dir = sys.argv[1]
    if len(sys.argv) > 2:
        output_file = sys.argv[2]
    
    success = generate_feed(articles_dir, output_file)
    sys.exit(0 if success else 1)

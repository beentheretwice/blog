# WaqtSalat Blog - Content Rules

## Design Standards

- **Background:** White (#FAFAFA)
- **Text:** Black (#212121)
- **Primary Color:** Green (#2E7D32)
- **Fonts:** System fonts only (no web fonts)
- **Style:** Material Design with elevated cards

## Content Structure

Every blog post MUST include:

### 1. Front Matter
```yaml
---
title: "Post Title"
date: 2026-03-10
draft: false
description: "SEO description (160 chars max)"
tags: ["tag1", "tag2"]
cover: "/images/post-cover.png"
image: "/images/post-cover.png"
tldr: "Quick summary of the post"
author: "WaqtSalat Team"
---
```

### 2. Images
- **Cover image:** Required (referenced in front matter)
- **Section images:** One image per paragraph/section
- **Alt text:** Descriptive, includes context
- **Format:** PNG, 16:9 aspect ratio (1365×768)
- **Generation:** Use Nano Banana 2 (gemini-3.1-flash-image-preview)

Example:
```markdown
![Descriptive alt text explaining the image content](/images/filename.png "Optional title")
```

### 3. TL;DR Box
Always include at top of post (via `tldr` in front matter):
```yaml
tldr: "Quick 1-2 sentence summary of what the reader will learn"
```

### 4. FAQ Section
Add via front matter:
```yaml
faq:
  - question: "Question 1?"
    answer: "Answer with markdown support."
  - question: "Question 2?"
    answer: "Another answer."
```

### 5. Citations/References
Add via front matter:
```yaml
references:
  - title: "Source Title"
    url: "https://example.com/source"
  - title: "Another Source"
    url: "https://example.com/another"
```

### 6. Hashtags
Add at the end of posts for discoverability:
```markdown
---

#PrayerTimes #Morocco #IslamicApps #OfflineFirst #OpenSource
```

## SEO Requirements

### JSON-LD Schemas (auto-generated)
- Article schema (required)
- FAQPage schema (if FAQ section exists)
- HowTo schema (if steps defined)

### Meta Requirements
- Title: 50-60 characters
- Description: 150-160 characters
- Tags: 3-5 relevant tags
- Cover image: Required for social sharing

## Image Generation

Use the content-engine skill:
```bash
export GEMINI_API_KEY="your-key"
cd ~/.openclaw/workspace/skills/content-engine

node scripts/generate-image.js \
  --prompt "Description of image" \
  --website default \
  --output /path/to/blog/static/images/filename.png
```

### Image Prompts
- Be specific and descriptive
- Include context and setting
- Mention color scheme (green/white for brand consistency)
- Specify no text/labels

## Multi-language Support

Posts exist in 3 languages:
- `content/en/posts/` - English
- `content/fr/posts/` - French
- `content/ar/posts/` - Arabic

Use `translationKey` to link translations:
```yaml
translationKey: "welcome-post"
```

## Link Checking

Pre-commit hook runs automatically. To manually check:
```bash
./scripts/check-links.sh
```

## Publishing Workflow

1. Create/enhance post with full SEO structure
2. Generate images with Nano Banana 2
3. Run link checker locally
4. Commit and push to branch
5. Create PR to main
6. Merge after review

## Quality Checklist

Before publishing, verify:
- [ ] Cover image exists
- [ ] One image per section
- [ ] TL;DR present
- [ ] FAQ section with 3-5 questions
- [ ] Citations/references included
- [ ] Hashtags at end
- [ ] All images have alt text
- [ ] Meta description under 160 chars
- [ ] Link checker passes (0 errors)
- [ ] Post exists in all 3 languages (or translationKey set)

## Image URLs

- **Format:** `/images/filename.png` (with leading slash)
- **Hugo processes:** Automatically adds `/blog/` prefix via `relURL`
- **Generated:** `/blog/images/filename.png`
- **Markdown:** Use same format: `![alt](/images/filename.png)`
- **No absolute URLs** in markdown or front matter

This ensures correct paths in both local development (`http://localhost:13132/blog/`) and production (`https://waqtsalat.github.io/blog/`).

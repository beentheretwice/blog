# Contributing Guide

## Git Workflow

### Before ANY Push: Check PR Status

**This is mandatory. No exceptions.**

```bash
# Check if PR is still open
gh pr view <number> --repo waqtsalat/blog --json state,mergedAt

# If state is "MERGED" or "CLOSED", create NEW branch + NEW PR
# NEVER push to a merged PR branch
```

**Why?**
- Pushing to merged branches doesn't update anything
- Creates confusion with orphaned commits
- Wastes time and breaks the workflow

**Pattern to follow:**
1. Check PR status
2. If OPEN → Push to existing branch
3. If MERGED → Create new branch from upstream/main
4. Cherry-pick or reapply changes
5. Create NEW PR

### Branch Naming Convention

```
feat/description    # New features
fix/description     # Bug fixes
docs/description    # Documentation updates
refactor/description # Code refactoring
```

Examples:
- `feat/cta-block`
- `fix/cover-image-urls`
- `docs/api-reference`

### Commit Message Format

```
<type>: <subject>

[optional body]

[optional footer]
```

**Types:**
- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation
- `style:` Formatting (no code change)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

**Example:**
```
fix: correct image URLs on posts page

## Issue
Post thumbnails showed 404 errors because image paths
were missing /blog/ prefix

## Solution
Applied strings.TrimPrefix before relURL in list.html

## Files Changed
- layouts/_default/list.html

## Testing
✅ Hugo build successful
✅ All images return 200 OK
✅ Posts page displays correctly
```

## Common Mistakes to Avoid

### 1. ❌ Pushing to Merged PRs

**Wrong:**
```bash
# PR was merged 2 hours ago
git push origin merged-branch  # ❌ This does nothing useful
```

**Right:**
```bash
# Check status first
gh pr view 13 --repo waqtsalat/blog --json state
# {"state":"MERGED"} 

# Create new branch
git checkout -b fix/new-issue upstream/main
# Apply changes and create NEW PR
```

### 2. ❌ Assuming relURL Handles Absolute Paths

**Wrong:**
```markdown
![alt](images/file.png)  # Missing leading slash
```

**Right:**
```markdown
![alt](/images/file.png)  # Leading slash required
```

**In templates:**
```go
{{ .Params.image | relURL }}              # ❌ If path starts with /
{{ strings.TrimPrefix "/" .Params.image | relURL }}  # ✅ Correct
```

### 3. ❌ Hardcoding Text Instead of i18n

**Wrong:**
```html
<h3>Try WaqtSalat Today</h3>
```

**Right:**
```html
<h3>{{ i18n "ctaTitle" }}</h3>
```

### 4. ❌ Skipping Local Testing

**Wrong:**
```bash
git push  # Push without testing
```

**Right:**
```bash
hugo --minify --baseURL "http://localhost:13132/blog/"
# Check http://localhost:13132/blog/
# Verify images, links, translations
git push
```

## Pre-Push Checklist

Before pushing ANY commit:

- [ ] **Check PR status** (if updating existing PR)
  ```bash
  gh pr view <number> --repo <repo> --json state,mergedAt
  ```
- [ ] **Local build successful**
  ```bash
  hugo --minify --baseURL "http://localhost:13132/blog/"
  ```
- [ ] **Manual verification**
  - [ ] Images load correctly
  - [ ] Links work
  - [ ] Translations display
  - [ ] No console errors
- [ ] **Commit message follows format**
- [ ] **Branch name follows convention**

## Image Handling

### Image Paths

**Front matter:**
```yaml
cover: "/images/filename.png"  # With leading slash
image: "/images/filename.png"  # With leading slash
```

**Markdown:**
```markdown
![Description](/images/filename.png "Title")
```

**Why?**
- Hugo's `relURL` adds `/blog/` prefix
- Without leading slash, paths become `blog/images/` instead of `/blog/images/`
- Leading slash ensures correct path: `/blog/images/filename.png`

### Image Validation

Run before committing:
```bash
./scripts/check-images.sh
```

This checks:
- Cover images in front matter
- Images in markdown content
- Generated HTML paths

## Multilingual Content

### Translation Keys

Link translations across languages:
```yaml
---
title: "Welcome"
translationKey: "welcome-post"
---
```

### i18n Keys

Add to `i18n/*.yaml`:
```yaml
- id: ctaTitle
  translation: "Try WaqtSalat Today"
```

Use in templates:
```html
<h3>{{ i18n "ctaTitle" }}</h3>
```

## Hugo-Specific Rules

### relURL Behavior

`relURL` adds base URL prefix to paths:

| Input | Output |
|-------|--------|
| `/images/file.png` | `/blog/images/file.png` ✅ |
| `images/file.png` | `blog/images/file.png` ❌ (relative) |
| `https://example.com/file.png` | `https://example.com/file.png` (absolute, no change) |

**Best practice:** Always use leading slash for local paths.

### Template Image Handling

**In layouts:**
```go
{{ with .Params.cover }}
<img src="{{ strings.TrimPrefix "/" . | relURL }}" alt="Cover">
{{ end }}
```

**Why TrimPrefix?**
- Ensures consistent handling
- Works for both `/images/` and `images/` inputs
- Adds `/blog/` prefix correctly

## PR Workflow

### Creating PR

```bash
# 1. Create branch from upstream/main
git checkout -b feat/new-feature upstream/main

# 2. Make changes
# 3. Test locally
hugo --minify --baseURL "http://localhost:13132/blog/"

# 4. Commit
git add -A
git commit -m "feat: add new feature"

# 5. Push
git push origin feat/new-feature

# 6. Create PR
gh pr create --repo waqtsalat/blog \
  --title "feat: add new feature" \
  --body "Description of changes"
```

### Updating PR

```bash
# 1. CHECK STATUS FIRST
gh pr view <number> --repo waqtsalat/blog --json state,mergedAt

# 2. If OPEN, push to branch
git push origin feat/new-feature

# 3. If MERGED, create NEW branch + NEW PR
git checkout -b fix/additional-fix upstream/main
```

### After Merge

```bash
# Update local main
git fetch upstream
git checkout main
git merge upstream/main

# Delete local branch
git branch -d feat/new-feature

# Start fresh for next work
git checkout -b feat/next-feature upstream/main
```

## Emergency: When Things Go Wrong

### Pushed to Merged PR

**Symptoms:**
- Commits pushed but PR is closed/merged
- Changes not appearing in deployed site

**Fix:**
```bash
# 1. Check latest upstream
git fetch upstream

# 2. Create new branch from current upstream/main
git checkout -b fix/correct-branch upstream/main

# 3. Cherry-pick your commits
git cherry-pick <commit-hash>

# 4. Create new PR
git push origin fix/correct-branch
gh pr create --repo waqtsalat/blog --title "fix: ..."
```

### Images Not Loading

**Check:**
1. Path in front matter has leading slash
2. Image exists in `static/images/`
3. Template uses `strings.TrimPrefix "/" . | relURL`
4. Generated HTML has `/blog/images/` prefix

**Debug:**
```bash
# Build and check
hugo --minify --baseURL "http://localhost:13132/blog/"
grep -r 'src="/images/' public/  # Should find nothing
grep -r 'src="/blog/images/' public/  # Should find images
```

### Translations Not Showing

**Check:**
1. i18n key exists in all language files
2. Template uses `{{ i18n "key" }}`
3. Content has `translationKey` in front matter
4. Hugo build successful

## Testing

### Local Testing

```bash
# Build
hugo --minify --baseURL "http://localhost:13132/blog/"

# Serve
hugo server --buildDrafts --buildFuture

# Check in browser
open http://localhost:1313/blog/
```

### Validation Scripts

```bash
# Check images
./scripts/check-images.sh

# Check links
./scripts/check-links.sh

# Check SEO files
./scripts/check-seo.sh
```

## Islamic Cultural Guidelines

### Prayer Imagery

**❌ NEVER show:**
- People using phones/devices while in prayer position
- Mixed genders praying together
- People facing each other during prayer (should face Qibla)
- Incorrect prayer postures

**✅ DO show:**
- Empty mosque interiors
- People checking prayer times BEFORE prayer
- Prayer rugs arranged facing Qibla (no people)
- Abstract/geometric Islamic art

### Dress Code for People

**For Moroccan Audience:**
- Men: Djellaba (traditional robe), Takia (red fez with black tassel)
- Women: Hijab with modest clothing
- **NOT:** Keffiyeh/ghutra (Middle Eastern, not Moroccan)

**Always verify:**
- Head coverings match Moroccan culture (Takia, not keffiyeh)
- Clothing is modest and appropriate
- No bare heads for men in religious contexts

### Image Review Checklist

Before using any image with people:

- [ ] **Are people in prayer position?** If yes, NO devices/distractions
- [ ] **Are genders separated?** Men and women don't pray together
- [ ] **Is everyone facing Qibla?** Same direction, not each other
- [ ] **Is attire culturally correct?** Moroccan Takia, not Middle Eastern keffiyeh
- [ ] **Would this offend Muslim users?** When in doubt, use empty mosques

### Generation Prompt Template

**For mosque/community images:**
```
Empty Moroccan mosque interior, NO people visible. Traditional 
Moroccan architecture: zellige tiles, horseshoe arches, carved 
wood. Prayer rugs arranged facing mihrab (Qibla). Soft natural 
light. Warm earth tones with green and gold accents. Clean, 
modern illustration style.
```

**For people images:**
```
Moroccan [man/woman] wearing traditional djellaba and 
[red Takia/hijab], sitting casually (NOT praying). Holding 
smartphone. Atlas Mountains and Moroccan kasbah in background. 
Warm sunset lighting. Clean, modern illustration style.
```

## References

- [Hugo Documentation](https://gohugo.io/documentation/)
- [GitHub Flow](https://docs.github.com/en/get-started/quickstart/github-flow)
- [Conventional Commits](https://www.conventionalcommits.org/)
- Project: `/home/elias/.openclaw/workspace/coding/blog`
- Live Site: https://waqtsalat.github.io/blog/

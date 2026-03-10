#!/bin/bash
# Generate navigation.json for site discovery
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"
STATIC_DIR="$BLOG_DIR/static"

mkdir -p "$STATIC_DIR"

# Create navigation.json
cat > "$STATIC_DIR/navigation.json" << 'EOF'
{
  "$schema": "https://json.schemastore.org/navigation.json",
  "site": "WaqtSalat Blog",
  "url": "https://waqtsalat.github.io/blog/",
  "description": "Prayer times, Islamic content, and updates from WaqtSalat",
  "languages": ["en", "fr", "ar"],
  "sections": {
    "main": [
      {"title": "Home", "url": "/blog/"},
      {"title": "Posts", "url": "/blog/posts/"},
      {"title": "English", "url": "/blog/en/"},
      {"title": "Français", "url": "/blog/fr/"},
      {"title": "العربية", "url": "/blog/ar/"}
    ]
  }
}
EOF

echo "✅ navigation.json generated"

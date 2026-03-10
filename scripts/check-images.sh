#!/bin/bash
# Check for broken image URLs in markdown files and generated HTML

set -e

echo "🔍 Checking image URLs..."

# Get the directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"

cd "$BLOG_DIR"

# Check if Hugo is available
if ! command -v hugo &> /dev/null; then
    echo "⚠️  Hugo not found, skipping build check"
    HUGO_AVAILABLE=false
else
    HUGO_AVAILABLE=true
fi

# 1. Check if cover images exist in front matter
echo ""
echo "📄 Checking cover images in front matter..."
COVER_COUNT=0
MISSING_COUNT=0

while IFS= read -r line; do
    if [[ $line =~ ^cover:\ *\"(.*)\" ]]; then
        COVER_PATH="${BASH_REMATCH[1]}"
        # Remove leading slash
        COVER_PATH="${COVER_PATH#/}"
        
        # Check in static directory
        if [[ -f "static/$COVER_PATH" ]]; then
            ((COVER_COUNT++))
        else
            echo "❌ Missing cover image: $COVER_PATH (from ${line%%:*})"
            ((MISSING_COUNT++))
        fi
    fi
done < <(grep -r "^cover:" content/ 2>/dev/null || true)

echo "✓ Found $COVER_COUNT cover images"
if [[ $MISSING_COUNT -gt 0 ]]; then
    echo "❌ $MISSING_COUNT cover images missing"
    exit 1
fi

# 2. Check if image files referenced in markdown exist
echo ""
echo "🖼️  Checking images in markdown..."
IMAGE_COUNT=0
MD_MISSING=0

while IFS= read -r line; do
    if [[ $line =~ \!\[.*\]\((/.*)\) ]]; then
        IMG_PATH="${BASH_REMATCH[1]}"
        # Remove leading slash
        IMG_PATH="${IMG_PATH#/}"
        
        # Check in static directory
        if [[ -f "static/$IMG_PATH" ]]; then
            ((IMAGE_COUNT++))
        else
            FILE=$(echo "$line" | cut -d: -f1)
            echo "❌ Missing image: $IMG_PATH (from $FILE)"
            ((MD_MISSING++))
        fi
    fi
done < <(grep -rn '!\[.*\](/.*)' content/ 2>/dev/null || true)

echo "✓ Found $IMAGE_COUNT images in markdown"
if [[ $MD_MISSING -gt 0 ]]; then
    echo "❌ $MD_MISSING images missing"
    exit 1
fi

# 3. Build and check generated HTML (if Hugo available)
if [[ "$HUGO_AVAILABLE" == "true" ]]; then
    echo ""
    echo "🏗️  Building site..."
    hugo --minify --baseURL "http://localhost:13132/blog/" > /dev/null 2>&1
    
    echo ""
    echo "🌐 Checking generated HTML for image URLs..."
    
    # Check for images with wrong base URL (missing /blog/ prefix)
    WRONG_URL=$(grep -r 'src="/images/' public/ 2>/dev/null | wc -l || echo "0")
    
    if [[ "$WRONG_URL" -gt 0 ]]; then
        echo "❌ Found $WRONG_URL images with wrong URL (missing /blog/ prefix):"
        grep -r 'src="/images/' public/ 2>/dev/null | head -5
        echo ""
        echo "   Images should use relURL or start with /blog/"
        exit 1
    fi
    
    echo "✓ All generated image URLs have correct /blog/ prefix"
fi

echo ""
echo "✅ All image checks passed!"

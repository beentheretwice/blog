#!/bin/bash
# Pre-commit: Generate navigation, check images, build Hugo, check links
# Skip with: git commit --no-verify

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

echo "1. Generating navigation files..."
"$BLOG_DIR/scripts/generate-nav.sh" 2>&1 | tail -1

echo ""
echo "2. Checking image URLs..."
"$BLOG_DIR/scripts/check-images.sh"

echo ""
echo "3. Running link checker..."
"$BLOG_DIR/scripts/check-links.sh"

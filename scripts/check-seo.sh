#!/bin/bash
# Check SEO files exist and are valid
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"
STATIC_DIR="$BLOG_DIR/static"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

echo -e "${YELLOW}Checking SEO files...${NC}"

# Check robots.txt
if [ ! -f "$STATIC_DIR/robots.txt" ]; then
    echo -e "${RED}✗ robots.txt missing${NC}"
    echo "  Create: static/robots.txt"
    exit 1
fi

if ! grep -q "Sitemap:" "$STATIC_DIR/robots.txt"; then
    echo -e "${RED}✗ robots.txt missing sitemap references${NC}"
    exit 1
fi

# Check navigation.json
if [ ! -f "$STATIC_DIR/navigation.json" ]; then
    echo -e "${RED}✗ navigation.json missing${NC}"
    echo "  Create: static/navigation.json"
    exit 1
fi

# Verify valid JSON
if ! python3 -c "import json; json.load(open('$STATIC_DIR/navigation.json'))" 2>/dev/null; then
    echo -e "${RED}✗ navigation.json is invalid JSON${NC}"
    exit 1
fi

# Check LLM.txt
if [ ! -f "$STATIC_DIR/llm.txt" ]; then
    echo -e "${RED}✗ llm.txt missing${NC}"
    echo "  Create: static/llm.txt"
    exit 1
fi

echo -e "${GREEN}✓ All SEO files present and valid${NC}"

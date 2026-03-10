#!/bin/bash
# Pre-commit hook: Build Hugo, serve locally, check all links
# Exits 1 if any broken links found

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"
PUBLIC_DIR="$BLOG_DIR/public"
PORT=13132
BASE_URL="http://localhost:$PORT/blog/"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Building Hugo site...${NC}"
cd "$BLOG_DIR"
rm -rf "$PUBLIC_DIR"

# Find hugo binary
if command -v hugo &> /dev/null; then
    HUGO="hugo"
elif [ -x /tmp/hugo ]; then
    HUGO="/tmp/hugo"
else
    echo -e "${RED}Error: hugo not found. Install hugo or download to /tmp/hugo${NC}"
    exit 1
fi

$HUGO --minify --baseURL "$BASE_URL/blog/" 2>&1 | grep -v "^WARN.*layout file"

# Check if public directory was created
if [ ! -d "$PUBLIC_DIR" ]; then
    echo -e "${RED}Error: Hugo build failed - public/ not created${NC}"
    exit 1
fi

echo -e "${GREEN}Build complete.${NC}"
echo ""

# Create directory structure for /blog prefix
# We need to serve public/ at /blog/ path
SERVE_DIR=$(mktemp -d)
trap "rm -rf '$SERVE_DIR'" EXIT
ln -s "$PUBLIC_DIR" "$SERVE_DIR/blog"

# Start Python HTTP server in background
echo -e "${YELLOW}Starting local server on port $PORT...${NC}"
cd "$SERVE_DIR"
python3 -m http.server $PORT > /dev/null 2>&1 &
SERVER_PID=$!

# Wait for server to start
sleep 1

# Verify server is running
if ! kill -0 $SERVER_PID 2>/dev/null; then
    echo -e "${RED}Error: Failed to start HTTP server${NC}"
    exit 1
fi

# Cleanup function
cleanup() {
    kill $SERVER_PID 2>/dev/null || true
    wait $SERVER_PID 2>/dev/null || true
}
trap cleanup EXIT

echo -e "${YELLOW}Checking links at $BASE_URL/blog/...${NC}"
echo ""

# Run linkchecker
# --no-warnings: only show errors
# --check-extern: also check external links (optional, remove for internal only)
# --timeout: request timeout in seconds
# --threads: number of parallel threads
LINKCHECKER_OUTPUT=$(linkchecker \
    --no-warnings \
    --timeout 30 \
    --threads 4 \
    --check-extern \
    "$BASE_URL/blog/" 2>&1) || LINKCHECKER_EXIT=$?

echo "$LINKCHECKER_OUTPUT"

# Check for errors
if [ "${LINKCHECKER_EXIT:-0}" -ne 0 ]; then
    # Count errors from output
    ERROR_COUNT=$(echo "$LINKCHECKER_OUTPUT" | grep -c "Error:" || echo "0")
    echo ""
    echo -e "${RED}✗ Found $ERROR_COUNT broken link(s)${NC}"
    echo -e "${RED}Commit blocked. Fix the broken links before committing.${NC}"
    exit 1
fi

# Double-check: look for "errors found" in output
if echo "$LINKCHECKER_OUTPUT" | grep -q "[1-9] errors found"; then
    echo -e "${RED}✗ Broken links detected${NC}"
    exit 1
fi

echo -e "${GREEN}✓ All links valid${NC}"
exit 0

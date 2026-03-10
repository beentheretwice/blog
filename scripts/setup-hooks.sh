#!/bin/bash
# Setup git hooks for the blog repository
# Run this once after cloning

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$SCRIPT_DIR")"
HOOKS_DIR="$BLOG_DIR/.git/hooks"

# Create pre-commit hook
cat > "$HOOKS_DIR/pre-commit" << 'EOF'
#!/bin/bash
# Pre-commit: Build Hugo and check all links
# Skip with: git commit --no-verify

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BLOG_DIR="$(dirname "$(dirname "$SCRIPT_DIR")")"

# Run link checker
"$BLOG_DIR/scripts/check-links.sh"
EOF

chmod +x "$HOOKS_DIR/pre-commit"

echo "✓ Git hooks installed"
echo "  - pre-commit: Builds Hugo and checks all links"
echo ""
echo "To skip link checking: git commit --no-verify"

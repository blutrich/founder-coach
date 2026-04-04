#!/bin/bash
# Founder Coach — one-line installer
# curl -fsSL https://raw.githubusercontent.com/blutrich/founder-coach/main/install.sh | bash

set -e

INSTALL_DIR="$HOME/.claude/plugins/marketplaces/founder-coach"

echo ""
echo "  🎯 Installing Founder Coach..."
echo ""

# Check if already installed
if [ -d "$INSTALL_DIR" ]; then
  echo "  📦 Found existing install. Updating..."
  cd "$INSTALL_DIR"
  git pull --quiet
else
  echo "  📦 Cloning from GitHub..."
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --quiet https://github.com/blutrich/founder-coach.git "$INSTALL_DIR"
fi

echo ""
echo "  ✅ Founder Coach installed!"
echo ""
echo "  Next steps:"
echo "  1. Open Claude Code (CLI, Desktop, or VS Code)"
echo "  2. Run:  /plugin          (select founder-coach → Install)"
echo "  3. Run:  /founder-coach   (Day 1 starts)"
echo ""
echo "  GitHub: https://github.com/blutrich/founder-coach"
echo ""

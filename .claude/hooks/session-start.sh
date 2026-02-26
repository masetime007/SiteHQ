#!/bin/bash
set -euo pipefail

# Only run in remote Claude Code on the web environments
if [ "${CLAUDE_CODE_REMOTE:-}" != "true" ]; then
  exit 0
fi

cd "${CLAUDE_PROJECT_DIR:-.}"

# Install Node.js dependencies if package.json exists
if [ -f "package.json" ]; then
  echo "Installing Node.js dependencies..."
  npm install
fi

# Install Python dependencies if requirements.txt exists
if [ -f "requirements.txt" ]; then
  echo "Installing Python dependencies..."
  pip install -r requirements.txt
fi

# Install Python dependencies via pyproject.toml if it exists
if [ -f "pyproject.toml" ] && [ ! -f "requirements.txt" ]; then
  echo "Installing Python dependencies via pyproject.toml..."
  pip install -e ".[dev]" 2>/dev/null || pip install -e . 2>/dev/null || true
fi

echo "Session start hook completed."

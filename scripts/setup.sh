#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "dotfiles セットアップ開始: $REPO"

# --- Claude Code ---
mkdir -p ~/.claude
ln -sf "$REPO/claude/CLAUDE.md"     ~/.claude/CLAUDE.md
ln -sf "$REPO/claude/settings.json" ~/.claude/settings.json
echo "  [Claude Code] CLAUDE.md / settings.json -> ~/.claude/"

# --- Cursor ---
mkdir -p ~/.cursor
mkdir -p "$HOME/Library/Application Support/Cursor/User"
ln -sf "$REPO/cursor/rules"         ~/.cursor/rules
ln -sf "$REPO/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
echo "  [Cursor]      rules / settings.json"

# --- VS Code ---
mkdir -p "$HOME/Library/Application Support/Code/User"
ln -sf "$REPO/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
echo "  [VS Code]     settings.json"

echo ""
echo "セットアップ完了。シンボリックリンクの確認:"
ls -la ~/.claude/CLAUDE.md
ls -la ~/.claude/settings.json
ls -la ~/.cursor/rules
ls -la "$HOME/Library/Application Support/Cursor/User/settings.json"
ls -la "$HOME/Library/Application Support/Code/User/settings.json"

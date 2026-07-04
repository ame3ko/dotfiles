#!/usr/bin/env bash
set -euo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

echo "dotfiles セットアップ開始: $REPO"

# 既存の実ファイル（シンボリックリンクでない）を壊さないようにしつつリンクを張る。
# - リンク済み: そのまま張り直す（データ消失なし）
# - 実ファイルで内容が同じ: バックアップ不要でそのまま置き換え
# - 実ファイルで内容が異なる: タイムスタンプ付きでバックアップしてから置き換え
link_or_backup() {
  local src="$1" dest="$2"

  if [ -L "$dest" ]; then
    ln -sf "$src" "$dest"
    return
  fi

  if [ -e "$dest" ]; then
    if ! cmp -s "$src" "$dest" 2>/dev/null; then
      local backup="${dest}.bak.$(date +%Y%m%d%H%M%S)"
      echo "  [backup] 既存ファイルを退避: $dest -> $backup"
      mv "$dest" "$backup"
    fi
  fi

  ln -sf "$src" "$dest"
}

# --- Claude Code ---
mkdir -p ~/.claude
link_or_backup "$REPO/claude/CLAUDE.md"     ~/.claude/CLAUDE.md
link_or_backup "$REPO/claude/settings.json" ~/.claude/settings.json
echo "  [Claude Code] CLAUDE.md / settings.json -> ~/.claude/"

# --- Cursor ---
# rules は claude/CLAUDE.md を直接参照（内容を共有するため）
mkdir -p ~/.cursor
mkdir -p "$HOME/Library/Application Support/Cursor/User"
link_or_backup "$REPO/claude/CLAUDE.md"     ~/.cursor/rules
link_or_backup "$REPO/cursor/settings.json" "$HOME/Library/Application Support/Cursor/User/settings.json"
echo "  [Cursor]      rules -> claude/CLAUDE.md / settings.json"

# --- VS Code ---
mkdir -p "$HOME/Library/Application Support/Code/User"
link_or_backup "$REPO/vscode/settings.json" "$HOME/Library/Application Support/Code/User/settings.json"
echo "  [VS Code]     settings.json"

echo ""
echo "セットアップ完了。シンボリックリンクの確認:"
ls -la ~/.claude/CLAUDE.md
ls -la ~/.claude/settings.json
ls -la ~/.cursor/rules
ls -la "$HOME/Library/Application Support/Cursor/User/settings.json"
ls -la "$HOME/Library/Application Support/Code/User/settings.json"

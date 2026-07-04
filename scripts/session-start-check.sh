#!/usr/bin/env bash
# Claude CodeのSessionStart hookから呼ばれる。
# シンボリックリンクが正しく張られていなければ setup.sh を自動実行する。
set -uo pipefail

REPO="$(cd "$(dirname "$0")/.." && pwd)"

is_linked() {
  local link="$1" target="$2"
  [ -L "$link" ] && [ "$(readlink "$link")" = "$target" ]
}

needs_setup=0

is_linked ~/.claude/CLAUDE.md "$REPO/claude/CLAUDE.md"                                   || needs_setup=1
is_linked ~/.claude/settings.json "$REPO/claude/settings.json"                           || needs_setup=1
is_linked ~/.cursor/rules "$REPO/claude/CLAUDE.md"                                       || needs_setup=1
is_linked "$HOME/Library/Application Support/Cursor/User/settings.json" "$REPO/cursor/settings.json" || needs_setup=1
is_linked "$HOME/Library/Application Support/Code/User/settings.json" "$REPO/vscode/settings.json"   || needs_setup=1

if [ "$needs_setup" -eq 1 ]; then
  echo "dotfiles: シンボリックリンク未設定を検知。setup.sh を自動実行します。" >&2
  bash "$REPO/scripts/setup.sh" >&2
fi

exit 0

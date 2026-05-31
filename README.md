# dotfiles

Claude Code・Cursor・VS Code の設定ファイルを一元管理するリポジトリ。
シンボリックリンクにより、複数端末・複数アカウントへ同一設定を即座に展開できる。

---

## 管理対象ファイル

| ツール | リポジトリ内の実体 | 展開先（各ツールが読み込むパス） |
|--------|-------------------|-------------------------------|
| Claude Code | `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| Claude Code | `claude/settings.json` | `~/.claude/settings.json` |
| Cursor | `cursor/rules` | `~/.cursor/rules` |
| Cursor | `cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| VS Code | `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |

---

## ディレクトリ構成

```
dotfiles/
├── README.md
├── claude/
│   ├── CLAUDE.md        # Claude Code グローバル AI ルール
│   └── settings.json    # Claude Code エディタ設定（テーマ・権限）
├── cursor/
│   ├── rules            # Cursor グローバル AI ルール
│   └── settings.json    # Cursor エディタ設定
├── vscode/
│   └── settings.json    # VS Code エディタ設定
└── scripts/
    └── setup.sh         # シンボリックリンク作成スクリプト
```

---

## セットアップ（新しい端末への展開）

2 ステップで完了する。

```bash
# 1. リポジトリをクローン
git clone https://github.com/<your-username>/dotfiles.git ~/dotfiles

# 2. セットアップスクリプトを実行
bash ~/dotfiles/scripts/setup.sh
```

スクリプトが各ツールの設定ディレクトリを自動作成し、シンボリックリンクを張る。

---

## 日常の運用フロー

設定を変更する際は dotfiles のファイルを直接編集する（シンボリックリンク経由なので各ツールから編集しても実体は dotfiles 内のファイルに反映される）。

```bash
# 変更後、リポジトリに記録して push
cd ~/dotfiles
git add .
git commit -m "fix: update VS Code font size"
git push
```

他の端末では `git pull` するだけで設定が同期される。

```bash
cd ~/dotfiles
git pull
```

---

## 各ファイルの説明

### claude/CLAUDE.md
Claude Code に対するグローバル AI 指示ファイル。
言語設定・文章スタイル・git-flow ルール・コーディング規約などを記述する。
全プロジェクトで共通して適用される。プロジェクト固有のルールは各リポジトリの `CLAUDE.md` に記述する。

### claude/settings.json
Claude Code のアプリケーション設定（テーマ・権限モードなど）。
機密情報（API キー・トークン）は絶対に記述しない。

### cursor/rules
Cursor に対するグローバル AI 指示ファイル（`claude/CLAUDE.md` に相当）。
Cursor をインストールしたら、`claude/CLAUDE.md` の内容を参考に記述する。

### cursor/settings.json
Cursor のエディタ設定。Cursor インストール後に設定を記述する。

### vscode/settings.json
VS Code のエディタ設定（フォント・タブサイズ・拡張機能の設定など）。

---

## Cursor を新規インストールした場合

Cursor の設定ファイルは現在空の状態。インストール後に以下を実施する。

```bash
# 1. Cursor を起動して初期設定を済ませる
# 2. Cursor の既存設定を dotfiles に取り込む（必要な場合）
cp "$HOME/Library/Application Support/Cursor/User/settings.json" ~/dotfiles/cursor/settings.json
# ※ シンボリックリンクが既に張られているため、Cursor が生成した設定は
#    自動的に dotfiles/cursor/settings.json へ書き込まれる

# 3. cursor/rules に AI ルールを記述してコミット
```

---

## 注意事項

- このリポジトリは **public** のため、機密情報（API キー・パスワード・トークン）を含むファイルは絶対にコミットしない
- 各ツールが自動生成するキャッシュや一時ファイルはリポジトリに含めない
- `.gitignore` で除外対象を管理する

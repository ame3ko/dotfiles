# dotfiles

Claude Code・Cursor・VS Code の設定ファイルを一元管理するリポジトリ。
シンボリックリンクにより、複数端末・複数アカウントへ同一設定を即座に展開できる。

---

## 管理対象ファイル

| ツール | リポジトリ内の実体 | 展開先（各ツールが読み込むパス） |
|--------|-------------------|-------------------------------|
| Claude Code | `claude/CLAUDE.md` | `~/.claude/CLAUDE.md` |
| Claude Code | `claude/settings.json` | `~/.claude/settings.json` |
| Cursor | `claude/CLAUDE.md`（共有） | `~/.cursor/rules` |
| Cursor | `cursor/settings.json` | `~/Library/Application Support/Cursor/User/settings.json` |
| VS Code | `vscode/settings.json` | `~/Library/Application Support/Code/User/settings.json` |

---

## ディレクトリ構成

```
dotfiles/
├── README.md
├── claude/
│   ├── CLAUDE.md        # Claude Code / Cursor 共通 AI ルール
│   └── settings.json    # Claude Code 設定（テーマ・権限）
├── cursor/
│   └── settings.json    # Cursor エディタ設定
├── vscode/
│   └── settings.json    # VS Code エディタ設定
└── scripts/
    └── setup.sh         # シンボリックリンク作成スクリプト
```

---

## シンボリックリンクとは

**ファイルの「分身（ショートカット）」を作る仕組み。** 実体は dotfiles リポジトリ内の 1 箇所だけに置き、各ツールが読み込むパスにはその分身を置く。

```
【通常のファイル配置（問題あり）】
~/.claude/CLAUDE.md   ← Claude Code が読む実体
~/.cursor/rules       ← Cursor が読む実体（別ファイル → 二重管理になる）

【シンボリックリンクを使った配置（このリポジトリの方式）】
~/dotfiles/claude/CLAUDE.md   ← 実体（ここだけ編集すればよい）
        ↑                ↑
~/.claude/CLAUDE.md   ~/.cursor/rules   ← 両方ともリンク（分身）
```

**メリット:**
- 設定を編集する場所は dotfiles の 1 箇所だけ
- 各ツールは従来通りのパスからファイルを読む（ツール側の設定変更不要）
- git で変更履歴を管理できる

---

## scripts/setup.sh の仕組み

新しい端末で `setup.sh` を実行すると、以下の処理を自動で行う。

```
1. 設定ディレクトリの作成
   mkdir -p ~/.claude
   mkdir -p ~/.cursor
   mkdir -p ~/Library/Application Support/Code/User
   mkdir -p ~/Library/Application Support/Cursor/User

2. シンボリックリンクの作成（ln -sf コマンド）
   ln -sf ~/dotfiles/claude/CLAUDE.md     ~/.claude/CLAUDE.md
   ln -sf ~/dotfiles/claude/settings.json ~/.claude/settings.json
   ln -sf ~/dotfiles/claude/CLAUDE.md     ~/.cursor/rules        ← Cursor も同じ実体を参照
   ln -sf ~/dotfiles/cursor/settings.json ~/Library/.../Cursor/User/settings.json
   ln -sf ~/dotfiles/vscode/settings.json ~/Library/.../Code/User/settings.json
```

`ln -sf` コマンドの意味：

| オプション | 意味 |
|-----------|------|
| `ln` | リンクを作成するコマンド |
| `-s` | シンボリックリンク（symbolic）を作成する |
| `-f` | 既にファイルが存在していても強制上書き（force）する |

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
`claude/CLAUDE.md` を直接参照するシンボリックリンク。
Claude Code と Cursor が同一の AI ルールを共有するため、個別ファイルは持たない。
Cursor 固有のルールが必要になった場合は `cursor/rules` を独立したファイルに切り替える。

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

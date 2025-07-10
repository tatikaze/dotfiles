# Dotfiles Repository Context

このプロジェクトでは、ユーザのターミナル環境の設定ファイルを管理することを目的としています。

## Repository Structure

```
dotfiles/
├── CLAUDE.md           # このファイル - プロジェクトコンテキスト
├── init.sh            # zsh/tmux設定の初期化スクリプト（Preztoベース）
├── .editorconfig      # エディタ設定
├── mac/               # macOS用設定ファイル
│   ├── install.sh     # Homebrew、Fish、tmux等のインストールスクリプト
│   ├── confinit.sh    # 設定ファイルのシンボリックリンク作成
│   └── .config/       # 各種アプリケーション設定
│       ├── fish/      # Fish shell設定
│       ├── nvim/      # Neovim設定
│       ├── wezterm/   # WeztermTerminal設定
│       ├── fisher/    # Fish plugin manager設定
│       └── coc/       # CoC.nvim設定
└── src/               # レガシー設定ファイル（zsh/tmux用）
```

## Key Configuration Files

### Shell Environments
- **Fish Shell**: `mac/.config/fish/` - メインシェル環境
- **Zsh + Prezto**: `src/` - レガシーzsh設定（Preztoフレームワーク使用）

### Editors
- **Neovim**: `mac/.config/nvim/` - メインエディタ設定
- **CoC.nvim**: `mac/.config/coc/` - IDE機能拡張

### Terminal & Multiplexer
- **Wezterm**: `mac/.config/wezterm/` - ターミナルエミュレータ
- **tmux**: `mac/.tmux.conf` - ターミナルマルチプレクサ

### Package Managers
- **Homebrew**: macOS用パッケージマネージャ
- **Fisher**: Fish shell用プラグインマネージャ

## Key Scripts

### `init.sh`
- Prezto（zsh framework）のインストール
- zsh設定ファイルのシンボリックリンク作成
- tmux設定のリンク作成

### `mac/install.sh`
- Homebrewのインストール
- 必要なCLIツールの存在確認とインストール指示：
  - fish, tmux, eza, tig, ghq
- Fishプラグイン（fisher, oh-my-fish, bobthefish）の設定
- `confinit.sh`の実行

### `mac/confinit.sh`
- 各種設定ファイルのシンボリックリンク作成：
  - tmux, fish, nvim, wezterm設定の配置
- **nvim設定の特徴**：
  - 個別.luaファイルは個別にシンボリックリンク
  - `lua/plugins`ディレクトリは全体をシンボリックリンク（構造変更に対応）

## Neovim Configuration Structure

**注意**: 実際の~/.config/nvim構造に基づく（NEOVIM_CONFIG_OVERVIEW.md参照）

```
~/.config/nvim/ (実際の構造)
├── init.lua                # メイン設定ファイル
├── lazy-lock.json         # プラグインバージョンロック
└── lua/
    ├── completions.lua    # 補完システム設定（nvim-cmp）
    ├── format.lua         # フォーマッター設定
    ├── lazy_init.lua      # Lazy.nvimプラグインマネージャー初期化
    ├── lsp.lua            # LSP設定（TypeScript、Lua、Biome、Jsonnet）
    ├── styles.lua         # テーマとUI設定（iceberg）
    └── plugins/           # 個別プラグイン設定（35ファイル）
        ├── airline.lua    # ステータスライン
        ├── copilot.lua    # GitHub Copilot
        ├── ddc.lua        # 補完システム（重複）
        ├── formatter.lua  # フォーマッター
        ├── lsp.lua        # LSP個別設定
        ├── noice.lua      # 通知システム
        └── ... (その他30ファイル)

mac/.config/nvim/ (リポジトリ内 - 要同期)
├── init.lua
├── lua/
│   ├── *.lua (コアモジュール)
│   └── plugins/ (個別プラグイン設定)
└── lazy-lock.json (プラグインロック)
```

### 主要な違い
- **プラグインマネージャー**: Packer → Lazy.nvim
- **構造**: `plugin/`ディレクトリ → `lua/plugins/`ディレクトリ
- **ロックファイル**: `packer_compiled.lua` → `lazy-lock.json`

## Common Workflows

### 初回セットアップ（macOS）
```bash
# 1. Homebrewと基本ツールのインストール
cd mac && ./install.sh

# 2. 設定ファイルのシンボリックリンク作成
./confinit.sh
```

### レガシーzsh環境のセットアップ
```bash
# Prezto + zsh + tmux環境
./init.sh
```

### 個別設定の更新
```bash
# Fish設定のみ更新
ln -sf $PWD/mac/.config/fish/config.fish ~/.config/fish/config.fish

# Neovim設定のみ更新
ln -sf $PWD/mac/.config/nvim/init.lua ~/.config/nvim/init.lua

# luaコアファイルの更新
mkdir -p ~/.config/nvim/lua
for file in mac/.config/nvim/lua/*.lua; do
  if [ -f "$file" ]; then
    ln -sf "$PWD/$file" ~/.config/nvim/lua/
  fi
done

# pluginsディレクトリ全体の更新
rm -rf ~/.config/nvim/lua/plugins
ln -sf $PWD/mac/.config/nvim/lua/plugins ~/.config/nvim/lua/plugins

# Wezterm設定のみ更新
mkdir -p ~/.config/wezterm
for file in mac/.config/wezterm/*; do
  ln -sf "$PWD/$file" ~/.config/wezterm/
done
```

## Development Notes

### 設定管理の方針
- シンボリックリンクを使用してホームディレクトリに配置
- macOS環境に最適化（`mac/`ディレクトリ）
- レガシー環境との併用可能（`src/`ディレクトリ）
- **nvim設定の特徴**：
  - コア.luaファイルは個別シンボリックリンク
  - `lua/plugins`ディレクトリは全体シンボリックリンク
  - プラグイン追加/削除時の自動同期

### 主要な依存関係
- **macOS**: Homebrew経由でのパッケージ管理
- **Fish Shell**: モダンなシェル環境とプラグインエコシステム
- **Neovim**: 設定可能なエディタ環境
- **Wezterm**: GPU加速ターミナルエミュレータ

### ファイル構造の特徴
- 設定ファイルは直接編集可能
- リポジトリの変更が即座にシステムに反映
- 各ツールの設定が独立して管理可能
- **nvim plugins管理の効率性**：
  - ディレクトリシンボリックリンクにより構造変更に自動対応
  - 新しいプラグイン設定ファイルの追加/削除が自動反映

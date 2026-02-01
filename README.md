# dotfiles

macOS環境のdotfiles管理リポジトリ（chezmoi使用）

## 📦 管理対象

- **Fish Shell**: モダンなシェル環境とプラグイン
- **Neovim**: Lazy.nvimベースのエディタ設定
- **Wezterm**: GPU加速ターミナルエミュレータ
- **tmux**: ターミナルマルチプレクサ
- その他: `.editorconfig`など

## 🚀 セットアップ

### 初回インストール（新しいマシン）

```bash
# 1. chezmoiのインストール
brew install chezmoi

# 2. このリポジトリからdotfilesを適用
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git

# 3. 初回セットアップ時に名前とメールを設定
# ~/.config/chezmoi/chezmoi.toml に以下を追加：
[data]
    email = "your-email@example.com"
    name = "Your Name"

# 4. 設定を再適用
chezmoi apply
```

### 既存リポジトリから移行

```bash
# 1. chezmoiのインストール
brew install chezmoi

# 2. リポジトリをクローン
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.local/share/chezmoi

# 3. 設定を適用
chezmoi apply
```

## 🔧 日常的な使い方

### 設定ファイルの編集

```bash
# 設定ファイルを編集（エディタで開く）
chezmoi edit ~/.config/fish/config.fish

# または直接編集して追加
chezmoi add ~/.config/nvim/init.lua

# 変更を確認
chezmoi diff

# 変更を適用
chezmoi apply
```

### リポジトリへの反映

```bash
# 変更をコミット
chezmoi cd
git add .
git commit -m "Update config"
git push

# chezmoiディレクトリから戻る
exit
```

### 他のマシンで同期

```bash
# 最新の設定を取得して適用
chezmoi update
```

## 📁 ディレクトリ構造

```
~/.local/share/chezmoi/
├── home/                           # chezmoi管理下のファイル
│   ├── .chezmoi.toml.tmpl         # chezmoi設定（テンプレート）
│   ├── .chezmoiignore             # 除外ファイル設定
│   ├── .chezmoidata.toml          # テンプレート変数のデフォルト値
│   ├── .chezmoiscripts/           # 自動実行スクリプト
│   │   ├── run_once_before_install-packages.sh
│   │   ├── run_once_after_setup-fish.sh
│   │   └── run_onchange_after_setup-nvim.sh.tmpl
│   ├── dot_config/
│   │   ├── fish/
│   │   ├── nvim/
│   │   └── wezterm/
│   ├── dot_tmux.conf
│   └── dot_editorconfig
├── mac/                           # レガシー設定（参考用）
└── src/                           # レガシーzsh設定（参考用）
```

## 🔄 自動実行スクリプト

chezmoiは以下のスクリプトを自動実行します：

- **run_once_before_install-packages.sh**: Homebrewと必須パッケージのインストール（初回のみ）
- **run_once_after_setup-fish.sh**: Fishプラグインのセットアップ（初回のみ）
- **run_onchange_after_setup-nvim.sh.tmpl**: `lazy-lock.json`変更時にNeovimプラグインを同期

## 🎯 主要な機能

### テンプレート機能
マシン固有の設定を`~/.config/chezmoi/chezmoi.toml`で管理できます。

```toml
[data]
    email = "your-email@example.com"
    name = "Your Name"
```

### 暗号化サポート
機密情報は`chezmoi encrypt`で暗号化して管理できます。

```bash
# 暗号化してファイルを追加
chezmoi add --encrypt ~/.ssh/config
```

## 🛠️ インストールされるツール

- **fish**: モダンシェル
- **tmux**: ターミナルマルチプレクサ
- **neovim**: モダンなVimエディタ
- **eza**: 高機能なlsの代替
- **bat**: catの代替（シンタックスハイライト付き）
- **tig**: Gitインターフェース
- **ghq**: リポジトリ管理ツール

## 📝 手動セットアップが必要なもの

1. **Cicaフォント**: https://github.com/miiton/Cica からダウンロードしてインストール
2. **デフォルトシェルの変更**:
   ```bash
   echo "$(which fish)" | sudo tee -a /etc/shells
   chsh -s $(which fish)
   ```

## 🔗 関連リンク

- [chezmoi公式ドキュメント](https://www.chezmoi.io/)
- [Fish Shell](https://fishshell.com/)
- [Neovim](https://neovim.io/)
- [Wezterm](https://wezfurlong.org/wezterm/)

## ⚠️ 移行について

このリポジトリは従来のシンボリックリンク方式からchezmoiに移行しました。
レガシーな`mac/`と`src/`ディレクトリは参考用に残してありますが、現在は使用していません。

旧方式のスクリプト:
- ~~`mac/install.sh`~~ → `home/.chezmoiscripts/run_once_before_install-packages.sh`
- ~~`mac/confinit.sh`~~ → chezmoiが自動管理
- ~~`init.sh`~~ → 非推奨（zsh/Prezto環境）

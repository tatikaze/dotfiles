# chezmoi移行ガイド

## 移行の背景

このdotfilesリポジトリは、従来のシンボリックリンク方式からchezmoiベースの管理に移行しました。

### 移行前（旧方式）
- 手動でのシンボリックリンク管理（`mac/confinit.sh`）
- マシン固有設定の管理が困難
- 複数マシン間での同期が手作業

### 移行後（chezmoi）
- 宣言的な設定管理
- テンプレート機能でマシン固有設定に対応
- 自動スクリプト実行（run_once, run_onchange）
- 複数マシン間での簡単な同期

## 既存環境からの移行手順

### 1. バックアップ作成

```bash
# 現在の設定をバックアップ
cp -r ~/.config/fish ~/.config/fish.backup
cp -r ~/.config/nvim ~/.config/nvim.backup
cp -r ~/.config/wezterm ~/.config/wezterm.backup
cp ~/.tmux.conf ~/.tmux.conf.backup
```

### 2. 既存のシンボリックリンクを削除

```bash
# シンボリックリンクを確認
ls -la ~/.config/fish
ls -la ~/.config/nvim
ls -la ~/.config/wezterm
ls -la ~/.tmux.conf

# シンボリックリンクを削除（実ファイルは削除されません）
rm ~/.config/fish/config.fish
rm -rf ~/.config/nvim/lua
rm ~/.config/nvim/init.lua
rm -rf ~/.config/wezterm/*
rm ~/.tmux.conf
```

### 3. chezmoiのセットアップ

```bash
# chezmoiインストール（まだの場合）
brew install chezmoi

# このリポジトリから初期化（推奨）
chezmoi init https://github.com/YOUR_USERNAME/dotfiles.git

# または直接クローン
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/.local/share/chezmoi
```

**注意**: リポジトリルートがchezmoiのソースディレクトリになるよう設計されています。`home/`サブディレクトリは使用していません。

### 4. 設定変数の設定

```bash
# chezmoi設定ファイルを作成
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
    email = "your-email@example.com"
    name = "Your Name"
EOF
```

### 5. 変更内容を確認

```bash
# 適用される変更を確認（dry-run）
chezmoi diff

# 個別のファイルを確認
chezmoi diff ~/.config/fish/config.fish
```

### 6. 設定を適用

```bash
# すべての設定を適用
chezmoi apply -v

# または個別に適用
chezmoi apply ~/.config/fish
chezmoi apply ~/.config/nvim
```

### 7. 動作確認

```bash
# シェルを再起動
exec fish

# Neovimを起動してプラグインを確認
nvim

# tmuxを起動して設定を確認
tmux
```

## よくある問題と解決方法

### Q1: 既存のファイルが上書きされるか心配

```bash
# 常に`chezmoi diff`で確認してから適用
chezmoi diff
chezmoi apply -v
```

### Q2: 特定のファイルだけ移行したい

```bash
# 個別に適用
chezmoi apply ~/.config/fish/config.fish
```

### Q3: シンボリックリンクが残っている

```bash
# シンボリックリンクを確認
find ~/ -maxdepth 3 -type l -ls | grep -E '(fish|nvim|wezterm|tmux)'

# 不要なリンクを削除
rm <path-to-symlink>
```

### Q4: プラグインが正しくインストールされない

```bash
# Fishプラグインの再インストール
fish -c "fisher update"

# Neovimプラグインの再同期
nvim --headless "+Lazy! sync" +qa
```

## 移行後の作業フロー

### 設定を編集する

```bash
# 方法1: chezmoiエディタを使用
chezmoi edit ~/.config/fish/config.fish

# 方法2: 直接編集してから追加
vim ~/.config/fish/config.fish
chezmoi add ~/.config/fish/config.fish

# 変更を適用
chezmoi apply
```

### 変更をリポジトリに反映

```bash
# chezmoiディレクトリに移動
chezmoi cd

# 変更を確認
git status
git diff

# コミット
git add .
git commit -m "Update fish config"
git push

# 元のディレクトリに戻る
exit
```

### 他のマシンで同期

```bash
# 最新の設定を取得
chezmoi update

# または手動で
chezmoi cd
git pull
exit
chezmoi apply
```

## ロールバック方法

移行に問題があった場合：

```bash
# 1. バックアップから復元
cp -r ~/.config/fish.backup ~/.config/fish
cp -r ~/.config/nvim.backup ~/.config/nvim
cp -r ~/.config/wezterm.backup ~/.config/wezterm
cp ~/.tmux.conf.backup ~/.tmux.conf

# 2. 旧方式のシンボリックリンクを再作成
cd ~/dotfiles
./mac/confinit.sh

# 3. chezmoiをアンインストール（必要に応じて）
brew uninstall chezmoi
rm -rf ~/.local/share/chezmoi
rm -rf ~/.config/chezmoi
```

## レガシーファイルについて

以下のファイルは参考用に残していますが、現在は使用していません：

- `mac/install.sh` - パッケージインストールスクリプト
- `mac/confinit.sh` - シンボリックリンク作成スクリプト
- `init.sh` - zsh/Prezto環境セットアップ
- `src/` - レガシーzsh設定ファイル

これらは将来的に削除される可能性があります。

# Legacy Dotfiles

⚠️ **このディレクトリは非推奨です**

このディレクトリには、chezmoi移行前の古いdotfiles管理方式が保存されています。

## 内容

### `mac/`
- 旧方式のmacOS用設定ファイル
- シンボリックリンクベースの管理
- `install.sh`: Homebrewとパッケージのインストールスクリプト
- `confinit.sh`: シンボリックリンク作成スクリプト

### `src/`
- レガシーなzsh/Prezto設定
- `.zshrc`, `.zpreztorc`など

### `init.sh`
- Prezto（zsh framework）のインストールスクリプト
- 現在は使用していません

## 現在の推奨方式

このリポジトリは**chezmoi**を使用した管理に移行しました。

### セットアップ方法

```bash
# 初回セットアップ
chezmoi init --apply https://github.com/YOUR_USERNAME/dotfiles.git

# 設定
mkdir -p ~/.config/chezmoi
cat > ~/.config/chezmoi/chezmoi.toml <<EOF
[data]
    email = "your@email.com"
    name = "Your Name"
EOF

# 適用
chezmoi apply
```

詳細は[README.md](../README.md)を参照してください。

## なぜlegacyに移動したか

### 旧方式の問題点
- ✗ 手動でのシンボリックリンク管理が必要
- ✗ マシン固有設定の管理が困難
- ✗ 複数OS対応が複雑
- ✗ スクリプトの重複実行リスク

### chezmoi方式の利点
- ✓ 宣言的な設定管理
- ✓ テンプレート機能でマシン固有設定に対応
- ✓ クロスプラットフォーム対応（macOS/Linux/Windows）
- ✓ 自動スクリプト実行（run_once, run_onchange）
- ✓ 暗号化機能で機密情報を安全に管理

## このディレクトリを削除しても良いか？

**削除しても問題ありません**。

ただし、以下の場合は参考用に残しておくと良いでしょう：
- 旧方式の設定を参照したい場合
- 移行が完了していない一部の設定がある場合
- バックアップとして保持したい場合

Gitの履歴には残っているため、必要になれば過去のコミットから復元できます。

## 移行履歴

- 2026-02-01: chezmoiに移行、このディレクトリにlegacyファイルを移動
- それ以前: シンボリックリンク方式で管理

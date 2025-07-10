# Neovim設定ファイル構造とコンテキスト

## 📁 ファイル構造

```
/Users/astify/.config/nvim/
├── init.lua                # メイン設定ファイル
├── lazy-lock.json         # プラグインバージョンロック
└── lua/
    ├── completions.lua    # 補完システム設定
    ├── format.lua         # フォーマッター設定
    ├── lazy_init.lua      # Lazyプラグインマネージャー初期化
    ├── lsp.lua            # LSP設定（ddc、noiceも含む）
    ├── styles.lua         # テーマとUI設定
    └── plugins/           # 個別プラグイン設定
        ├── airline.lua
        ├── base.lua
        ├── copilot.lua
        ├── ddc-nvim-lsp.lua
        ├── ddc.lua
        ├── denops.lua
        ├── formatter.lua
        ├── fuzzy_finder.lua
        ├── highlight.lua
        ├── iceberg.lua
        ├── linter.lua
        ├── lsp.lua
        ├── noice.lua
        ├── null.lua
        ├── nvim-lspconfig.lua
        ├── one.lua
        ├── prettier.lua    # （pretiter.luaから修正済み）
        ├── quickfix.lua
        └── stylua.lua
```

## 🔧 メインファイル設定

### init.lua
- **基本設定**: 行番号表示、クリップボード設定、UTF-8エンコード、テキスト折り返し
- **診断設定**: カーソル停止時の自動エラー表示（250ms後）
- **モジュール読み込み**: lazy_init、lsp、styles、completions、format
- **グローバルキーマッピング**:
  - `<C-f>`: フォーマット実行
  - `<C-p>`: 定義ジャンプ（split表示）

### lazy_init.lua
- lazy.nvimプラグインマネージャーのブートストラップ
- リーダーキー設定（`<leader>` = スペース）
- pluginsディレクトリからの自動インポート設定

## 📦 使用プラグイン

### プラグインマネージャー
- **lazy.nvim**: メインプラグインマネージャー

### 補完システム
- **nvim-cmp**: メイン補完エンジン
- **cmp-buffer**, **cmp-path**, **cmp-cmdline**: 補完ソース
- **cmp-nvim-lsp**, **cmp-nvim-lua**: LSP補完
- **lspkind.nvim**: 補完アイコン
- **ddc.vim**: 代替補完システム（⚠️ 重複）

### LSP関連
- **nvim-lspconfig**: LSP設定
- **TypeScript LSP**: TypeScript/JavaScript対応
- **Lua LSP**: Lua言語対応
- **Biome**: 高速リンター/フォーマッター
- **Jsonnet**: Jsonnet言語対応

### フォーマッター/リンター
- **formatter.nvim**: メインフォーマッター
- **none-ls.nvim**: null-ls後継（⚠️ 重複設定）
- **stylua.nvim**: Luaフォーマッター

### AI支援
- **copilot.lua**: GitHub Copilot（新版）
- **copilot.vim**: GitHub Copilot（旧版、⚠️ 重複）
- **copilot-cmp**: Copilot補完統合
- **CopilotChat.nvim**: AIチャット機能

### UI/UX
- **lualine.nvim**: ステータスライン
- **noice.nvim**: 通知システム
- **nvim-notify**: 通知表示
- **iceberg.vim**: カラースキーム
- **nvim-web-devicons**: アイコン表示

### ユーティリティ
- **fzf-lua**: ファジーファインダー
- **plenary.nvim**: 便利関数ライブラリ
- **denops.vim**: Denoランタイム

## ⚙️ 設定モジュール詳細

### completions.lua
```lua
-- nvim-cmp設定
-- カスタムアイコンマッピング
-- 補完ソース: Copilot、LSP、パス、vsnip
-- キーマッピング: Tab、Ctrl+n、Ctrl+p
```

### format.lua
```lua
-- 言語別フォーマッター設定
-- Lua: stylua
-- JS/TS: biome（優先）→ prettier（fallback）
-- Terraform、Prisma、Markdown対応
-- biome.json検出による自動選択
```

### lsp.lua
```lua
-- LSPクライアント設定
-- TypeScript、Lua、Biome、Jsonnet
-- ddc.vim設定（重複）
-- noice.nvim設定
-- LSPキーマッピング
```

### styles.lua
```lua
-- icebergカラースキーム
-- 背景透明化
-- lualineステータスバー（ayu_darkテーマ）
```

## 🎯 キーマッピング

### グローバル
| キー | 機能 | 定義場所 |
|------|------|----------|
| `<C-f>` | フォーマット実行 | init.lua |
| `<C-p>` | 定義ジャンプ（split） | init.lua |

### LSP
| キー | 機能 | 定義場所 |
|------|------|----------|
| `<leader>d` | 定義ジャンプ | lsp.lua |
| `gr` | 参照検索 | lsp.lua |
| `gi` | 実装ジャンプ | lsp.lua |
| `<leader>D` | 型定義ジャンプ | lsp.lua |

### 補完
| キー | 機能 | 定義場所 |
|------|------|----------|
| `<Tab>` | 候補確定 | completions.lua |
| `<C-n>` | 次の候補 | completions.lua |
| `<C-p>` | 前の候補 | completions.lua |

### Copilot
| キー | 機能 | 定義場所 |
|------|------|----------|
| `<C-\>` | チャット切り替え | copilot.lua |
| `<C-y>` | 受け入れ | copilot.lua |
| `<C-c>` | 閉じる | copilot.lua |

## ⚠️ 問題点と改善提案

### 1. 補完システムの重複
- **問題**: nvim-cmpとddc.vimが同時設定
- **影響**: 予期しない動作、パフォーマンス低下
- **提案**: どちらか一方に統一（nvim-cmp推奨）

### 2. キーマッピングの競合
- **問題**: `<C-p>`が複数機能で使用
  - init.lua: 定義ジャンプ
  - completions.lua: 前の候補
- **提案**: キーマッピングの整理と統一

### 3. LSP設定の重複
- **問題**: TypeScript LSPが複数回設定（lsp.lua:7, 33行目）
- **提案**: 設定の統合と重複削除

### 4. フォーマッター設定の重複
- **問題**: formatter.nvimとnone-ls.nvimで同じ機能を設定
- **提案**: 一つのフォーマッターシステムに統一

### 5. Copilotプラグインの重複
- **問題**: copilot.luaとcopilot.vimの併用
- **提案**: 新しいcopilot.luaに統一

## 🔄 推奨する統合案

### LSP設定統合
```
lsp.lua (統合後)
├── TypeScript LSP設定（重複削除）
├── Lua LSP設定
├── Biome設定
└── Jsonnet設定

削除対象:
- lua/plugins/nvim-lspconfig.lua（内容をlsp.luaに統合）
```

### フォーマッター統合
```
formatting.lua (新規作成)
├── none-ls.nvim設定（メイン）
├── 言語別フォーマッター設定
└── biome/prettier自動選択ロジック

削除対象:
- formatter.lua（内容を統合）
- lua/plugins/formatter.lua
- lua/plugins/stylua.lua
- lua/plugins/null.lua
```

### 補完システム統一
```
completions.lua (整理後)
├── nvim-cmp設定（メイン）
├── 補完ソース設定
└── キーマッピング設定

削除対象:
- ddc関連設定すべて
- lua/plugins/ddc.lua
- lua/plugins/ddc-nvim-lsp.lua
```

## 📈 最適化後の期待効果

1. **設定の明確化**: 機能ごとの責任分離
2. **パフォーマンス向上**: 重複プラグインの削除
3. **保守性向上**: 設定の一元管理
4. **競合解消**: キーマッピングと機能の整理
5. **可読性向上**: ファイル構造の最適化

## 🚀 次のステップ

1. 重複設定の削除
2. キーマッピングの整理
3. 機能別ファイル統合
4. 設定テストと動作確認
5. ドキュメントの更新

---

*最終更新: 2025-07-10*  
*設定場所: `/Users/astify/.config/nvim/`*
-- プロジェクト別スクラッチノート
-- 保存先: ~/.local/state/nvim/scratch/<git-root-as-key>/
-- 運用: WIPのみ。完成したら :ScratchPromote で repo に移してscratchは消す。

local M = {}

local function state_root()
  return vim.fn.stdpath("state") .. "/scratch"
end

local function project_root()
  local out = vim.fn.systemlist({ "git", "rev-parse", "--show-toplevel" })
  if vim.v.shell_error == 0 and out[1] and out[1] ~= "" then
    return out[1]
  end
  return vim.fn.getcwd()
end

local function project_dir()
  local key = project_root():gsub("/", "%%")
  local dir = state_root() .. "/" .. key
  vim.fn.mkdir(dir, "p", tonumber("700", 8))
  return dir
end

local function chmod_600(path)
  local uv = vim.uv or vim.loop
  uv.fs_chmod(path, tonumber("600", 8))
end

local function open_scratch(path)
  local uv = vim.uv or vim.loop
  -- シークレットを含み得るため、defaultのumaskで作成されないよう
  -- 先に0600で空ファイルを作ってから開く
  if not uv.fs_stat(path) then
    local fd = uv.fs_open(path, "w", tonumber("600", 8))
    if fd then uv.fs_close(fd) end
  end
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  -- 書き込み前後でchmod (BufWritePreは新規バッファでも発火するためdefense in depth)
  vim.api.nvim_create_autocmd({ "BufWritePre", "BufWritePost" }, {
    buffer = 0,
    callback = function() chmod_600(path) end,
  })
end

function M.pick()
  local ok, fzf = pcall(require, "fzf-lua")
  if not ok then
    vim.notify("fzf-lua not available", vim.log.levels.ERROR)
    return
  end
  fzf.files({ cwd = project_dir(), prompt = "Scratch> " })
end

function M.new(slug)
  if not slug or slug == "" then
    slug = vim.fn.input("Scratch slug: ")
    if slug == "" then return end
  end
  -- パストラバーサル防止: slugは単一ファイル名のみ受け付ける
  if slug:find("/") or slug:find("\\") or slug:find("%.%.") then
    vim.notify("Invalid slug: must not contain '/', '\\', or '..'", vim.log.levels.ERROR)
    return
  end
  if not slug:match("%.") then
    slug = slug .. ".md"
  end
  open_scratch(project_dir() .. "/" .. slug)
end

function M.promote(repo_path)
  local current = vim.api.nvim_buf_get_name(0)
  if not current:find(state_root(), 1, true) then
    vim.notify("Current buffer is not a scratch file", vim.log.levels.ERROR)
    return
  end
  if not repo_path or repo_path == "" then
    repo_path = vim.fn.input("Promote to (repo-relative): ", "docs/")
    if repo_path == "" then return end
  end

  -- リポジトリ外への書き出しを防ぐ: 解決済みパスがリポジトリroot配下にあるか検証
  local root = vim.fs.normalize(project_root())
  local dest = vim.fs.normalize(root .. "/" .. repo_path)
  if dest:sub(1, #root + 1) ~= root .. "/" then
    vim.notify("Destination escapes repo root: " .. dest, vim.log.levels.ERROR)
    return
  end

  vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  -- 未保存scratchを保護するため新規タブで開く
  vim.cmd("tabnew " .. vim.fn.fnameescape(dest))
  vim.api.nvim_buf_set_lines(0, 0, -1, false, content)
  vim.notify("Sanitize secrets, then :w to commit-ready file.", vim.log.levels.WARN)
  local scratch_path = current
  vim.api.nvim_create_autocmd("BufWritePost", {
    buffer = 0,
    once = true,
    callback = function()
      vim.schedule(function()
        local choice = vim.fn.confirm("Delete scratch file?\n" .. scratch_path, "&Yes\n&No", 2)
        if choice == 1 then
          vim.fn.delete(scratch_path)
          vim.notify("Deleted: " .. scratch_path)
        end
      end)
    end,
  })
end

vim.api.nvim_create_user_command("Scratch", function() M.pick() end, {})
vim.api.nvim_create_user_command("ScratchNew", function(opts) M.new(opts.args) end, { nargs = "?" })
vim.api.nvim_create_user_command("ScratchPromote", function(opts) M.promote(opts.args) end,
  { nargs = "?", complete = "file" })

return M

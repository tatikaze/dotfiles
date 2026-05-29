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
  vim.cmd("edit " .. vim.fn.fnameescape(path))
  vim.api.nvim_create_autocmd("BufWritePost", {
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
  local dest = project_root() .. "/" .. repo_path
  vim.fn.mkdir(vim.fn.fnamemodify(dest, ":h"), "p")
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  vim.cmd("edit " .. vim.fn.fnameescape(dest))
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

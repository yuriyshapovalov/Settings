local group = vim.api.nvim_create_augroup("user_config", { clear = true })
local autocmd = vim.api.nvim_create_autocmd

-- Flash the yanked region
autocmd("TextYankPost", {
  group = group,
  callback = function() vim.hl.on_yank({ timeout = 150 }) end,
})

-- Pick up edits made outside Neovim (Claude, Codex, git checkout, formatters).
-- 'autoread' alone only acts when Neovim checks; these events trigger the check.
autocmd({ "FocusGained", "BufEnter", "CursorHold", "TermLeave" }, {
  group = group,
  callback = function()
    if vim.fn.mode() ~= "c" and vim.bo.buftype == "" then
      vim.cmd.checktime()
    end
  end,
})

autocmd("FileChangedShellPost", {
  group = group,
  callback = function(ev)
    vim.notify("Reloaded from disk: " .. vim.fn.fnamemodify(ev.file, ":~:."), vim.log.levels.INFO)
  end,
})

-- Return to the last cursor position when reopening a file (from the 2015 vimrc)
autocmd("BufReadPost", {
  group = group,
  callback = function(ev)
    local ft = vim.bo[ev.buf].filetype
    if ft == "gitcommit" or ft == "gitrebase" then return end
    local mark = vim.api.nvim_buf_get_mark(ev.buf, '"')
    local lines = vim.api.nvim_buf_line_count(ev.buf)
    if mark[1] > 1 and mark[1] <= lines then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Keep splits balanced when the terminal is resized (moving between monitors)
autocmd("VimResized", {
  group = group,
  callback = function() vim.cmd("tabdo wincmd =") end,
})

-- Two-space indentation where it is the convention
autocmd("FileType", {
  group = group,
  pattern = { "lua", "javascript", "typescript", "javascriptreact", "typescriptreact",
              "json", "jsonc", "yaml", "html", "css", "scss", "terraform", "hcl", "markdown" },
  callback = function()
    vim.opt_local.shiftwidth = 2
    vim.opt_local.tabstop = 2
    vim.opt_local.softtabstop = 2
  end,
})

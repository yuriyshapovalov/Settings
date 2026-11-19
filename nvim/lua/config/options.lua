local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true      -- makes 5j / 12k style motions trivial
opt.cursorline = true
opt.signcolumn = "yes"         -- no text jumping when diagnostics/git signs appear
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.wrap = false
opt.breakindent = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.winborder = "rounded"      -- borders for floating windows (LSP hover etc.)
opt.showmode = false           -- statusline will show the mode later
opt.laststatus = 3             -- one global statusline across splits
opt.splitright = true
opt.splitbelow = true
opt.mouse = "a"

-- Editing
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.confirm = true             -- ask instead of failing on :q with unsaved changes
opt.virtualedit = "block"      -- free cursor in visual-block mode

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "split"       -- live preview of :s substitutions

-- Files: persistent undo instead of the old `set backup`
opt.undofile = true
opt.undolevels = 10000
opt.swapfile = false           -- agents edit files on disk; swap files just cause prompts
opt.autoread = true            -- pick up changes made by agents (see autocmds.lua)

-- Responsiveness
opt.updatetime = 250
opt.timeoutlen = 400

-- System clipboard (deferred: the clipboard provider can slow startup)
vim.schedule(function()
  opt.clipboard = "unnamedplus"
end)

-- Russian layout, carried over from the 2015 vimrc:
--  * keymap: type Russian in insert mode with <C-^> while the OS stays on English
--  * langmap: normal-mode commands still work if the OS layout is Russian
opt.keymap = "russian-jcukenwin"
opt.iminsert = 0
opt.imsearch = 0
opt.langmap = "ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,"
  .. "фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz"

-- Remote-plugin hosts: no plugin here needs them; disabling skips their startup probes
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-- Diagnostics display (used by LSP from step 3)
vim.diagnostic.config({
  severity_sort = true,
  virtual_text = { spacing = 2, source = "if_many" },
  float = { source = "if_many" },
  underline = true,
})

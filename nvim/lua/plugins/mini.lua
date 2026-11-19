-- mini.nvim: one repo of small independent modules; only the ones set up below are active
vim.pack.add({ "https://github.com/nvim-mini/mini.nvim" })

-- Icons for oil, fzf-lua, which-key and the statusline (replaces nvim-web-devicons)
require("mini.icons").setup()

-- More text objects: a/i + q (quotes), b (brackets), f (call), a (argument), t (tag); add n/l for next/last (cinq)
require("mini.ai").setup()

-- Add/delete/replace surroundings (quotes, brackets, tags). `gs` prefix because flash owns `s`.
require("mini.surround").setup({
  mappings = {
    add = "gsa",
    delete = "gsd",
    find = "gsf",
    find_left = "gsF",
    highlight = "gsh",
    replace = "gsr",
  },
})

-- Auto-close brackets and quotes
require("mini.pairs").setup()

-- Statusline: mode, git, diagnostics, file info (one global line, see 'laststatus')
require("mini.statusline").setup()

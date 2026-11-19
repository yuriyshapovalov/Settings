-- fzf-lua: fast on big repos (fzf + rg + fd), with git and LSP pickers that suit reviewing agent changes
vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")
fzf.setup({})
fzf.register_ui_select() -- route vim.ui.select (LSP code actions etc.) through fzf

local map = vim.keymap.set
map("n", "<leader><space>", fzf.files, { desc = "Find files" })
map("n", "<leader>/", fzf.live_grep, { desc = "Grep" })
map("n", "<leader>,", fzf.buffers, { desc = "Buffers" })

map("n", "<leader>ff", fzf.files, { desc = "Files" })
map("n", "<leader>fr", fzf.oldfiles, { desc = "Recent files" })
map("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
map("n", "<leader>fg", fzf.git_status, { desc = "Changed files (git status)" })
map("n", "<leader>fw", fzf.grep_cword, { desc = "Grep word under cursor" })
map("x", "<leader>fw", fzf.grep_visual, { desc = "Grep selection" })
map("n", "<leader>fh", fzf.helptags, { desc = "Help" })
map("n", "<leader>fk", fzf.keymaps, { desc = "Keymaps" })
map("n", "<leader>fq", fzf.quickfix, { desc = "Quickfix list" })
map("n", "<leader>f.", fzf.resume, { desc = "Resume last picker" })

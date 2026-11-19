-- oil.nvim: edit directories as buffers (rename/move/delete with normal edits); replaces netrw
vim.pack.add({ "https://github.com/stevearc/oil.nvim" })

require("oil").setup({
  watch_for_changes = true, -- refresh listings when agents create or delete files
  view_options = { show_hidden = true }, -- dotfiles matter in these repos; toggle with g.
})

vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })

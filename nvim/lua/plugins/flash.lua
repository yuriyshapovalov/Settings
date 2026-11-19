-- flash.nvim: jump to any visible spot by typing a few chars plus a label; f/t also highlight and cross lines
vim.pack.add({ "https://github.com/folke/flash.nvim" })

local flash = require("flash")
flash.setup({})

local map = vim.keymap.set
map({ "n", "x", "o" }, "s", flash.jump, { desc = "Flash jump" })
map({ "n", "x", "o" }, "S", flash.treesitter, { desc = "Flash Treesitter select" })
map("o", "r", flash.remote, { desc = "Remote flash" })
map({ "o", "x" }, "R", flash.treesitter_search, { desc = "Treesitter search" })
map("c", "<C-s>", flash.toggle, { desc = "Toggle flash in / search" })

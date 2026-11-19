-- which-key: pops up the possible next keys after a prefix, so mappings stay discoverable
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")
wk.setup({})

-- Names for prefixes; the mappings themselves live next to their plugins
wk.add({
  { "<leader>f", group = "find" },
  { "gs", group = "surround", mode = { "n", "x" } },
})

vim.keymap.set("n", "<leader>?", function() wk.show({ global = false }) end, { desc = "Buffer-local keymaps" })

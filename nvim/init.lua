-- Entry point. Keep this file tiny: it only wires modules together.
-- Step 1 (core, no plugins): options, keymaps, autocmds.

if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("This config targets Neovim 0.12+. Run ./install.sh to upgrade.", vim.log.levels.WARN)
end

-- Leader must be set before any mapping is defined.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("config.options")
require("config.keymaps")
require("config.autocmds")

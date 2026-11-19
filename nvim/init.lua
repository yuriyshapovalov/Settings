-- Entry point. Keep this file tiny: it only wires modules together.

if vim.fn.has("nvim-0.12") == 0 then
  vim.notify("This config targets Neovim 0.12+. Run ./install.sh to upgrade.", vim.log.levels.WARN)
end

-- Leader must be set before any mapping is defined.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Core: no plugins
require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.pack")

-- Plugins: installed by vim.pack, pinned in nvim-pack-lock.json.
-- Colourscheme first so everything after it picks up its highlights.
require("plugins.colourscheme")
require("plugins.mini")
require("plugins.picker")
require("plugins.oil")
require("plugins.which-key")
require("plugins.flash")

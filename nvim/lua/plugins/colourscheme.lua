-- Catppuccin: the most actively maintained popular theme, with highlight integrations for every plugin here
vim.pack.add({ { src = "https://github.com/catppuccin/nvim", name = "catppuccin" } })

require("catppuccin").setup({
  flavour = "auto", -- follows 'background': mocha when dark, latte when light
  background = { light = "latte", dark = "mocha" },
  -- Listed explicitly: auto-detected integrations are not part of Catppuccin's compile cache,
  -- so a newly added plugin would stay unthemed until a manual :CatppuccinCompile.
  auto_integrations = false,
  integrations = {
    flash = true,
    fzf = true,
    mini = { enabled = true },
    which_key = true,
  },
})

vim.cmd.colorscheme("catppuccin")

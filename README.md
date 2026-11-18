# Settings

Personal dotfiles: a hand-built Neovim IDE plus the terminal tooling around it,
designed for working alongside coding agents (Claude Code, Codex) across three monitors.

The pre-2015 Vim config is preserved under the tag [`legacy-2015`](../../tree/legacy-2015).

## Install

```sh
git clone https://github.com/yuriyshapovalov/Settings.git ~/Settings
cd ~/Settings
./install.sh
```

`install.sh` is idempotent. It installs Neovim (latest stable, 0.12+), ripgrep, fd, fzf,
tmux, lazygit, the tree-sitter CLI and the JetBrainsMono Nerd Font, then symlinks each config
directory into `~/.config`. An existing real config is moved to `*.bak.<timestamp>` first.

Supported: macOS (Homebrew) and Debian/Ubuntu, including WSL. On other systems, install the
packages above by hand and run `ln -s ~/Settings/nvim ~/.config/nvim`.

## Layout

```
nvim/                    -> ~/.config/nvim
  init.lua               entry point, only requires modules
  lua/config/options.lua editor options, Russian layout (keymap + langmap), diagnostics
  lua/config/keymaps.lua core mappings (leader = Space)
  lua/config/autocmds.lua auto-reload of files changed by agents, cursor restore, indents
```

## Roadmap

| Step | Scope | Status |
|------|-------|--------|
| 0 | Install script, dependencies, repo layout | done |
| 1 | Core options, keymaps, autocmds — no plugins | done |
| 2 | `vim.pack`, theme, picker (fzf-lua), oil.nvim, which-key, flash, mini.nvim | |
| 3 | LSP, mason, blink.cmp, conform, linters | |
| 4 | Git review: gitsigns, diffview, fugitive / lazygit | |
| 5 | Agents: tmux config, git worktrees (workmux), sidekick.nvim / claudecode.nvim | |
| 6 | Debugging (nvim-dap) and tests (neotest), as needed | |

## Key mappings (step 1)

| Keys | Action |
|------|--------|
| `<Space>w` / `<Space>q` | write / quit |
| `<C-h/j/k/l>` | move between splits |
| `<S-h>` / `<S-l>` | previous / next buffer |
| `]q` / `[q` | next / previous quickfix entry |
| `]d` / `[d`, `<Space>d` | next / previous diagnostic, show message |
| `-` | file explorer in the current directory |
| `<Space>r` | reload all buffers changed on disk |
| `<C-^>` (insert mode) | toggle Russian input without changing the OS layout |
| `J` / `K` (visual) | move selected lines |
| `<Esc><Esc>` (terminal) | leave terminal mode |

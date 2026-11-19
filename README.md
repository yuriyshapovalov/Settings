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
Finally it clones the Neovim plugins at the revisions pinned in `nvim/nvim-pack-lock.json`.
On Debian/Ubuntu, fzf and lazygit come from their GitHub releases (apt's fzf is too old,
lazygit is not packaged); the rest comes from apt.

Supported: macOS (Homebrew) and Debian/Ubuntu, including WSL. On other systems, install the
packages above by hand and run `ln -s ~/Settings/nvim ~/.config/nvim`.

## Layout

```
nvim/                       -> ~/.config/nvim
  init.lua                  entry point, only requires modules
  nvim-pack-lock.json       plugin revisions pinned by vim.pack (committed)
  lua/config/options.lua    editor options, Russian layout (keymap + langmap), diagnostics
  lua/config/keymaps.lua    core mappings (leader = Space)
  lua/config/autocmds.lua   auto-reload of files changed by agents, cursor restore, indents
  lua/config/pack.lua       :PackUpdate and :PackClean around the built-in vim.pack
  lua/plugins/              one file per plugin (or tight group): vim.pack.add + setup + keys
    colourscheme.lua        Catppuccin
    mini.lua                mini.icons, mini.ai, mini.surround, mini.pairs, mini.statusline
    picker.lua              fzf-lua
    oil.lua                 oil.nvim
    which-key.lua           which-key.nvim
    flash.lua               flash.nvim
```

## Plugins

Managed by the built-in `vim.pack` (Neovim 0.12). The first start installs anything missing
from the lockfile after one confirmation.

- `:PackUpdate` fetches updates and opens a review buffer: `:write` applies, `:quit` discards.
  Commit the changed `nvim-pack-lock.json` afterwards.
- To remove a plugin, delete its file and its `require` in `init.lua`, restart, then `:PackClean`.

## Roadmap

| Step | Scope | Status |
|------|-------|--------|
| 0 | Install script, dependencies, repo layout | done |
| 1 | Core options, keymaps, autocmds — no plugins | done |
| 2 | `vim.pack`, theme (Catppuccin), picker (fzf-lua), oil.nvim, which-key, flash, mini.nvim | done |
| 3 | LSP, mason, blink.cmp, conform, linters — Python, TS/JS, Terraform, Go, C++ | next |
| 4 | Git review: gitsigns, diffview, fugitive / lazygit | |
| 5 | Terminal and agents: Ghostty, tmux config, git worktrees (workmux), sidekick.nvim / claudecode.nvim | |
| 6 | Debugging (nvim-dap) and tests (neotest), as needed | |

## Key mappings

Press `<Space>` and wait: which-key lists what comes next.

### Core

| Keys | Action |
|------|--------|
| `<Space>w` / `<Space>q` | write / quit |
| `<C-h/j/k/l>` | move between splits |
| `<S-h>` / `<S-l>` | previous / next buffer |
| `]q` / `[q` | next / previous quickfix entry |
| `]d` / `[d`, `<Space>d` | next / previous diagnostic, show message |
| `<Space>r` | reload all buffers changed on disk |
| `<Space>p` (visual) | paste over selection without yanking it |
| `<C-^>` (insert mode) | toggle Russian input without changing the OS layout |
| `J` / `K` (visual) | move selected lines |
| `<Esc><Esc>` (terminal) | leave terminal mode |

### Find (fzf-lua)

| Keys | Action |
|------|--------|
| `<Space><Space>` / `<Space>ff` | files |
| `<Space>/` | live grep |
| `<Space>,` / `<Space>fb` | buffers |
| `<Space>fr` | recent files |
| `<Space>fg` | changed files (git status, with diff preview) |
| `<Space>fw` | grep word under cursor / selection |
| `<Space>fh` / `<Space>fk` | help tags / keymaps |
| `<Space>fq` | quickfix list |
| `<Space>f.` | resume the last picker |

Inside a picker: `<C-j>/<C-k>` move, `<Enter>` open, `<C-s>` / `<C-v>` / `<C-t>` open in
split / vsplit / tab, `<Tab>` multi-select, `<A-q>` send selection to quickfix, `<F1>` help.
In `<Space>fg`: `<Left>` stages, `<Right>` unstages, `<C-x>` **discards** the file's changes.

### Files (oil.nvim)

| Keys | Action |
|------|--------|
| `-` | open the parent directory (again inside oil: go up) |
| `<Enter>` | open file / directory |
| edit lines + `:w` | create, rename, move or delete files (confirms before applying) |
| `g.` | toggle hidden files (shown by default) |
| `g?` | all oil mappings |

### Motion and editing

| Keys | Action |
|------|--------|
| `s` + chars + label | flash: jump anywhere on screen; also a motion, e.g. `ds` + jump deletes up to the target |
| `S` | flash: select a Treesitter node |
| `r` (after operator) | flash remote: e.g. `yr` + jump + motion yanks there and comes back |
| `f` `t` `F` `T` | flash char mode: highlight matches and **search past the current line**; repeat with `;` `,` or the same key |
| `<C-s>` (in `/` search) | toggle flash labels for the search |
| `gsa{motion}{char}` | add surrounding, e.g. `gsaiw"` wraps a word in quotes |
| `gsd{char}` / `gsr{old}{new}` | delete / replace surrounding |
| `a` / `i` + `q` `b` `f` `a` `t` | text objects: quotes, brackets, function call, argument, tag (mini.ai) |
| `<Space>?` | buffer-local keymaps |

### Plugin management

| Command | Action |
|---------|--------|
| `:PackUpdate` | review and apply plugin updates |
| `:PackClean` | delete plugins no longer configured |

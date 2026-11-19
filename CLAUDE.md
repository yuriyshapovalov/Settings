# CLAUDE.md

Context for coding agents working in this repo. Read fully before changing anything.

## What this is

Yuriy's personal dotfiles: a hand-built Neovim IDE plus the terminal tooling around it.
Built step by step together with an AI assistant; each step is used for a day or two before the next.

- Owner: senior engineer / solution architect, ~20 years. Skip beginner explanations.
- He writes to agents in **Russian**: answer in Russian. Code, comments, commit messages and
  README stay in **English** (British spelling).
- Languages to support (confirmed): Python, TypeScript/JavaScript (Next.js), Terraform/HCL, Go, C++;
  plus Lua, Bash, JSON/YAML, Markdown, Dockerfile.
- Works with coding agents in parallel on **three monitors**: Claude Code and Codex **equally**.
- Main machine: Ubuntu 24.04, GNOME on X11. Terminal: **Ghostty** (chosen, not yet installed;
  gnome-terminal until step 5).
- Commits: authored by the owner only, GPG-signed (global `commit.gpgsign`). No Claude
  `Co-Authored-By` / session trailers. If signing fails, ask the owner to unlock the key; never bypass.

## Decisions already made (do not relitigate without a reason)

| Decision | Rationale |
|---|---|
| Neovim 0.12+ only, not Vim | Native LSP, Treesitter, `vim.pack`; every agent integration targets Neovim |
| Own config, no distro (LazyVim, NvChad…) | Owner wants to understand every line; ~20–25 plugins max |
| `vim.pack` (built-in), not lazy.nvim | Fewer moving parts; startup is fine at this plugin count. Commit `nvim-pack-lock.json` |
| Plain `ln -s` in `install.sh`, not GNU stow | stow 2.3.1 (Ubuntu) crashes on absolute symlinks in `$HOME` |
| Agents run **outside** Neovim, one tmux window per git worktree | Survive editor restarts; one task = one branch = one worktree = one agent |
| Neovim is the **review hub** | Bottleneck is reviewing agent diffs, so invest in git/diff tooling over in-editor chat |
| `swapfile` off, `autoread` + `checktime` autocmds | Agents edit files on disk; avoid swap prompts, auto-reload buffers |
| Russian layout: `keymap=russian-jcukenwin` + `langmap` | Carried over from the 2015 vimrc; `<C-^>` toggles Russian in insert mode |
| Leader = Space, local leader = `\` | |
| Picker: fzf-lua, not snacks.picker / mini.pick | Most active (daily commits), fastest on big repos, git_status with diff preview and stage/unstage; snacks.nvim slowed down (no commits since 2026-05) |
| Theme: Catppuccin with integrations listed explicitly | Owner's pick. `auto_integrations` is off because detected plugins are not in its compile-cache hash: **add each new plugin to `integrations`** |
| Icons: mini.icons, no nvim-web-devicons | fzf-lua, oil and which-key support it natively. Call `MiniIcons.mock_nvim_web_devicons()` only if a plugin needs devicons (diffview in step 4) |
| flash owns `s`/`S`; mini.surround uses `gs` prefix (`gsa`/`gsd`/`gsr`) | Avoids `s`-prefix overlaps; the 2015 vimrc had no surround plugin, so no muscle memory to keep |
| One `vim.pack.add` per plugin file, default `confirm = true` | Matches "one file per plugin". With the lockfile present, the first call installs everything in one batch after one prompt |
| Unused providers (node, perl, python3, ruby) disabled | No remote plugins; silences checkhealth and skips startup probes |

## Layout

```
install.sh               idempotent bootstrap: deps + symlinks into ~/.config (macOS brew, Debian/Ubuntu/WSL)
nvim/                    -> ~/.config/nvim (symlink, so `git pull` updates the live config)
  init.lua               only requires modules
  nvim-pack-lock.json    written by vim.pack through the symlink; commit it with plugin changes
  lua/config/            options.lua, keymaps.lua, autocmds.lua, pack.lua (core, no plugins)
  lua/plugins/           one file per plugin or tight group: vim.pack.add + setup + keymaps,
                         required explicitly from init.lua (colourscheme first)
README.md                install, layout, roadmap table, key mappings table
```

New tools get their own top-level dir (e.g. `tmux/`, `ghostty/`) and an entry in `PACKAGES` in `install.sh`.

## Roadmap

| Step | Scope | Status |
|---|---|---|
| 0 | install.sh, deps, repo layout | done |
| 1 | Core options/keymaps/autocmds, no plugins | done |
| 2 | `vim.pack`, Catppuccin, fzf-lua, oil.nvim, which-key, flash.nvim, mini.nvim (ai, surround, pairs, statusline, icons) | done |
| 3 | Native LSP (`vim.lsp.config`/`enable`) + nvim-lspconfig defaults, mason (+ tool installer), blink.cmp, conform.nvim, nvim-lint, Treesitter — for the languages above | next |
| 4 | gitsigns, diffview.nvim, fugitive and/or lazygit integration | |
| 5 | Ghostty config (`ghostty/`), tmux config (+ seamless nvim/tmux navigation), workmux for worktrees, sidekick.nvim (both agents) and claudecode.nvim (decide here: Claude Code is an equal primary), AGENTS.md/CLAUDE.md templates for projects | |
| 6 | nvim-dap, neotest — only if needed | |

Planned monitor layout: centre = Neovim on the repo/worktree under review; second = tmux session
`agents` (window per worktree); third = browser/app, logs, test watcher, docs.

## How to work on a step

1. Check the environment first (`uname -a`, `nvim --version`, which tools exist). Do not assume OS.
2. Check that plugins you pick are still maintained and compatible with the installed Neovim
   (search, read the README). The ecosystem moves fast.
3. Keep each plugin justified: a one-line comment saying why it exists.
4. Verify before committing:
   - `nvim --headless "+qa"` prints nothing (no errors)
   - `nvim --headless "+checkhealth" "+w! /tmp/health.txt" "+qa"` and read the warnings
   - `nvim --startuptime /tmp/st.log +qa` stays well under ~100 ms
5. Update README (roadmap status, key mappings table) and this file if a decision changes.
6. Small commits, imperative subject line. Ask before pushing.
7. End by telling the owner what to try and what to report back.

## Known caveats

- nvim-treesitter was archived in April 2026 after its 0.12-only rewrite; the latest commit reportedly
  works on 0.12. Re-check status and alternatives (e.g. tree-sitter-manager.nvim) before step 3.
- `:checktime` inside an autocmd is deferred until Neovim next waits for input — tests that read the
  buffer immediately will look like a failure; it works in real use.
- macOS branch of `install.sh` is untested on a Mac. Formula names (incl. `tree-sitter-cli`) and the
  font cask were checked against Homebrew in Nov 2026.
- `install.sh` needs an interactive `sudo` (apt, `/opt`): agents cannot run it; ask the owner to.
  To test a config without it, unpack the Neovim tarball into a scratch dir and point
  `XDG_CONFIG_HOME/DATA/STATE/CACHE` at scratch dirs, with `XDG_CONFIG_HOME/nvim` symlinked to `nvim/`.
- `langmap` only translates built-in Normal-mode commands. It does **not** apply to user mappings
  (leader keys, flash `s`, mini.surround `gs…`), not even with `--clean`, nor to keys plugins read
  with `getchar()`. Russian works as designed only via `<C-^>` in insert mode with the OS on English.
  If the owner wants mappings to work with the OS layout on Russian: langmapper.nvim (active, Nov 2026).
- which-key.nvim has had no commits since 2025-10 (no open 0.12 issues). If it breaks on a new
  Neovim, the drop-in fallback is `mini.clue` from the already installed mini.nvim.
- Headless tests: `:qa!` hangs while an fzf-lua terminal job is open; end such tests with `os.exit()`.
  In headless mode the vim.pack install prompt is auto-accepted.

## Open questions for the owner

- None right now. Ghostty install method (snap vs .deb) is decided in step 5.

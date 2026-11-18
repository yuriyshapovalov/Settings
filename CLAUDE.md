# CLAUDE.md

Context for coding agents working in this repo. Read fully before changing anything.

## What this is

Yuriy's personal dotfiles: a hand-built Neovim IDE plus the terminal tooling around it.
Built step by step together with an AI assistant; each step is used for a day or two before the next.

- Owner: senior engineer / solution architect, ~20 years. Skip beginner explanations.
- He writes to agents in **Russian**: answer in Russian. Code, comments, commit messages and
  README stay in **English** (British spelling).
- Primary stack (unconfirmed, ask): Python/FastAPI, TypeScript/Next.js, Terraform.
- Works with coding agents (Claude Code, Codex) in parallel on **three monitors**.

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

## Layout

```
install.sh               idempotent bootstrap: deps + symlinks into ~/.config (macOS brew, Debian/Ubuntu/WSL)
nvim/                    -> ~/.config/nvim (symlink, so `git pull` updates the live config)
  init.lua               only requires modules
  lua/config/            options.lua, keymaps.lua, autocmds.lua (core, no plugins)
  lua/plugins/           (step 2+) one file per plugin or tight group: vim.pack.add + setup
README.md                install, layout, roadmap table, key mappings table
```

New tools get their own top-level dir (e.g. `tmux/`, `ghostty/`) and an entry in `PACKAGES` in `install.sh`.

## Roadmap

| Step | Scope | Status |
|---|---|---|
| 0 | install.sh, deps, repo layout | done |
| 1 | Core options/keymaps/autocmds, no plugins | done |
| 2 | `vim.pack`, colourscheme, fzf-lua (or snacks.picker), oil.nvim, which-key, flash.nvim, mini.nvim (ai, surround, pairs, statusline, icons) | next |
| 3 | Native LSP (`vim.lsp.config`/`enable`) + nvim-lspconfig defaults, mason (+ tool installer), blink.cmp, conform.nvim, nvim-lint, Treesitter | |
| 4 | gitsigns, diffview.nvim, fugitive and/or lazygit integration | |
| 5 | tmux config (+ seamless nvim/tmux navigation), workmux for worktrees, sidekick.nvim (multi-vendor) and optionally claudecode.nvim, AGENTS.md/CLAUDE.md templates for projects | |
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
- macOS branch of `install.sh` is untested; Homebrew formula `tree-sitter-cli` may need to be `tree-sitter`.
- The `legacy-2015` tag (old Vim config, commit 0ddd68d) may not be pushed yet: `git ls-remote --tags origin`.

## Open questions for the owner

- OS of the main three-monitor machine (macOS / Linux / WSL) and terminal emulator (Ghostty/Kitty/WezTerm).
- Exact languages to support in step 3.
- Primary agent: Claude Code, Codex, or both equally (decides whether to add claudecode.nvim).

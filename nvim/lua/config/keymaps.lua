local map = vim.keymap.set

-- Clear search highlight
map("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Save / quit
map("n", "<leader>w", "<cmd>write<CR>", { desc = "Write file" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "Quit window" })

-- Window navigation (tmux-aware navigation replaces this in step 5)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Move selected lines and keep the selection
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down", silent = true })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up", silent = true })

-- Keep selection when indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- Paste over a selection without losing the yanked text
map("x", "<leader>p", [["_dP]], { desc = "Paste without yanking" })

-- Buffers
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })

-- Quickfix (agents, grep and LSP all feed it)
map("n", "]q", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
map("n", "[q", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })

-- Diagnostics: ]d / [d are built in; this opens the full message
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- Temporary file explorer (built-in netrw); replaced by oil.nvim in step 2
map("n", "-", "<cmd>Explore<CR>", { desc = "Open parent directory" })

-- Leave terminal mode with a double Esc (single Esc goes to the program)
map("t", "<Esc><Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })

-- Reload every buffer from disk, e.g. after an agent finished a batch of edits
map("n", "<leader>r", "<cmd>checktime<CR>", { desc = "Reload changed files" })

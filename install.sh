#!/usr/bin/env bash
# Bootstrap: installs Neovim 0.12+ and CLI dependencies, then symlinks configs into ~/.config.
# Supported: macOS (Homebrew), Debian/Ubuntu (incl. WSL). Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PACKAGES=(nvim)               # repo dirs linked to ~/.config/<name>; more in later steps
LOCAL_BIN="$HOME/.local/bin"

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
warn() { printf '\033[1;33m!!\033[0m  %s\n' "$*"; }
has()  { command -v "$1" >/dev/null 2>&1; }

install_macos() {
  has brew || { warn "Homebrew is required: https://brew.sh"; exit 1; }
  log "Installing packages with Homebrew"
  brew install neovim git ripgrep fd fzf tmux lazygit tree-sitter-cli
  brew install --cask font-jetbrains-mono-nerd-font
}

# Print this CPU as a release asset spells it: arch_name <x86_64 spelling> <arm64 spelling>
arch_name() {
  case "$(uname -m)" in
    x86_64) echo "$1" ;;
    aarch64|arm64) echo "$2" ;;
    *) warn "Unsupported CPU: $(uname -m)"; return 1 ;;
  esac
}

# Latest release tag (e.g. v0.75.0) via the /releases/latest redirect, so no API rate limit
latest_tag() {
  curl -fsSLI -o /dev/null -w '%{url_effective}' "https://github.com/$1/releases/latest" | sed 's#.*/tag/##'
}

install_neovim_linux() {
  local arch; arch="$(arch_name x86_64 arm64)"
  log "Installing latest stable Neovim (nvim-linux-$arch) to /opt"
  local tmp; tmp="$(mktemp -d)"
  curl -fsSL "https://github.com/neovim/neovim/releases/latest/download/nvim-linux-${arch}.tar.gz" -o "$tmp/nvim.tar.gz"
  sudo rm -rf "/opt/nvim-linux-${arch}"
  sudo tar -C /opt -xzf "$tmp/nvim.tar.gz"
  sudo ln -sf "/opt/nvim-linux-${arch}/bin/nvim" /usr/local/bin/nvim
  rm -rf "$tmp"
}

install_tree_sitter_linux() {
  local arch; arch="$(arch_name x64 arm64)"
  log "Installing tree-sitter CLI to $LOCAL_BIN"
  curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/latest/download/tree-sitter-linux-${arch}.gz" \
    | gunzip > "$LOCAL_BIN/tree-sitter"
  chmod +x "$LOCAL_BIN/tree-sitter"
}

# apt on Ubuntu 24.04 ships fzf 0.44; fzf-lua uses features from 0.53+
install_fzf_linux() {
  local arch tag; arch="$(arch_name amd64 arm64)"; tag="$(latest_tag junegunn/fzf)"
  log "Installing fzf $tag to $LOCAL_BIN"
  curl -fsSL "https://github.com/junegunn/fzf/releases/download/${tag}/fzf-${tag#v}-linux_${arch}.tar.gz" \
    | tar -xz -C "$LOCAL_BIN" fzf
}

# Not packaged in Ubuntu 24.04 apt
install_lazygit_linux() {
  local arch tag; arch="$(arch_name x86_64 arm64)"; tag="$(latest_tag jesseduffield/lazygit)"
  log "Installing lazygit $tag to $LOCAL_BIN"
  curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/${tag}/lazygit_${tag#v}_linux_${arch}.tar.gz" \
    | tar -xz -C "$LOCAL_BIN" lazygit
}

install_font_linux() {
  local dir="$HOME/.local/share/fonts/JetBrainsMonoNerd"
  if [[ -d "$dir" ]]; then return; fi
  log "Installing JetBrainsMono Nerd Font"
  mkdir -p "$dir"
  curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.tar.xz" \
    | tar -xJ -C "$dir"
  has fc-cache && fc-cache -f "$dir" >/dev/null
}

install_debian() {
  log "Installing packages with apt"
  sudo apt-get update -qq
  sudo apt-get install -y -qq git curl unzip tar gzip xz-utils build-essential \
    ripgrep fd-find tmux fontconfig xclip wl-clipboard
  # Debian ships fd as `fdfind`
  if ! has fd && has fdfind; then ln -sf "$(command -v fdfind)" "$LOCAL_BIN/fd"; fi
  install_neovim_linux
  install_tree_sitter_linux
  install_fzf_linux
  install_lazygit_linux
  if grep -qi microsoft /proc/version 2>/dev/null; then
    warn "WSL detected: install a Nerd Font in Windows, not here (https://www.nerdfonts.com)"
  else
    install_font_linux
  fi
}

link_configs() {
  mkdir -p "$HOME/.config"
  for pkg in "${PACKAGES[@]}"; do
    local src="$DOTFILES/$pkg" target="$HOME/.config/$pkg"
    if [[ -L "$target" && "$(readlink "$target")" == "$src" ]]; then
      log "$pkg already linked"; continue
    fi
    if [[ -e "$target" || -L "$target" ]]; then
      local backup="$target.bak.$(date +%Y%m%d%H%M%S)"
      warn "Backing up existing $target -> $backup"
      mv "$target" "$backup"
    fi
    ln -s "$src" "$target"
    log "Linked $target -> $src"
  done
}

main() {
  mkdir -p "$LOCAL_BIN"
  case "$(uname -s)" in
    Darwin) install_macos ;;
    Linux)
      if has apt-get; then install_debian
      else warn "Only apt-based Linux is automated. Install the packages listed in README.md manually."; exit 1
      fi ;;
    *) warn "Unsupported OS: $(uname -s)"; exit 1 ;;
  esac

  link_configs

  # Clone plugins at the revisions in nvim-pack-lock.json now, so the first real start is instant
  log "Installing Neovim plugins from nvim-pack-lock.json"
  nvim --headless "+qa" </dev/null

  log "Versions"
  nvim --version | head -1
  for tool in rg fd fzf tmux lazygit tree-sitter; do
    if has "$tool"; then printf '  %-12s ok\n' "$tool"; else printf '  %-12s MISSING\n' "$tool"; fi
  done
  case ":$PATH:" in *":$LOCAL_BIN:"*) ;; *) warn "Add $LOCAL_BIN to PATH in your shell rc";; esac
  has node || warn "Node.js not found: needed for several language servers in step 3 (install via fnm or mise)"
  log "Done. Start with: nvim"
}

main "$@"

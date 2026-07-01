#!/bin/sh
# One-shot setup for a fresh machine.
#
# Usage (after cloning this repo to ~/.config/dotfiles):
#   ~/.config/dotfiles/bootstrap.sh
set -eu

export XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
export XDG_CACHE_HOME="${XDG_CACHE_HOME:-$HOME/.cache}"
export XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"
export XDG_STATE_HOME="${XDG_STATE_HOME:-$HOME/.local/state}"

DOTFILES_DIR="$(cd "$(dirname "$0")" && pwd)"

if [ "$DOTFILES_DIR" != "$XDG_CONFIG_HOME/dotfiles" ]; then
    echo "Warning: this repo is expected at \$XDG_CONFIG_HOME/dotfiles ($XDG_CONFIG_HOME/dotfiles)," >&2
    echo "but is running from $DOTFILES_DIR. Symlinks below assume the former." >&2
fi

echo "==> Linking dotfiles"
sh "$DOTFILES_DIR/setup/ln.sh"

echo "==> Installing Homebrew + packages"
sh "$DOTFILES_DIR/setup/brew.sh"

echo "==> Generating shell completions"
sh "$DOTFILES_DIR/setup/comp.sh"

echo "==> Syncing Neovim plugins"
nvim --headless "+Lazy! sync" +qa

echo "==> Done. Start a new shell to pick up the config."

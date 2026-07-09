#!/bin/sh
set -eu

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
DOTFILES="$XDG_CONFIG_HOME/dotfiles"

link() {
    src="$1"
    dst="$2"
    if [ -L "$dst" ] && [ "$(readlink "$dst")" = "$src" ]; then
        return 0
    fi
    if [ -e "$dst" ] || [ -L "$dst" ]; then
        backup="$dst.bak.$(date +%Y%m%d%H%M%S)"
        echo "Backing up existing $dst -> $backup"
        mv "$dst" "$backup"
    fi
    mkdir -p "$(dirname "$dst")"
    ln -s "$src" "$dst"
    echo "Linked $dst -> $src"
}

link "$DOTFILES/.zshrc"    "$HOME/.zshrc"
link "$DOTFILES/.zshenv"   "$HOME/.zshenv"
link "$DOTFILES/.zprofile" "$HOME/.zprofile"
link "$DOTFILES/nvim"     "$XDG_CONFIG_HOME/nvim"
link "$DOTFILES/kitty"    "$XDG_CONFIG_HOME/kitty"
link "$DOTFILES/ghostty"  "$XDG_CONFIG_HOME/ghostty"
link "$DOTFILES/zellij"   "$XDG_CONFIG_HOME/zellij"
link "$DOTFILES/k9s"      "$XDG_CONFIG_HOME/k9s"
link "$DOTFILES/jj/config.toml" "$XDG_CONFIG_HOME/jj/config.toml"

# ~/.gitconfig stays a real file (not a symlink) so machine-local additions
# (work includeif, diff.external, etc.) can live above the shared config.
if [ ! -f "$HOME/.gitconfig" ]; then
    printf '[include]\n    path = %s/.gitconfig\n' "$DOTFILES" > "$HOME/.gitconfig"
    echo "Created $HOME/.gitconfig including $DOTFILES/.gitconfig"
fi

if [ ! -f "$DOTFILES/.secrets" ]; then
    echo "# Local secrets — not tracked in git. Fill in as needed." > "$DOTFILES/.secrets"
    echo "Created empty $DOTFILES/.secrets (was missing — .zshenv sources it unconditionally)"
fi

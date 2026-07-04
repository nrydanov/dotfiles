#!/bin/sh
set -eu

# Homebrew's own Linux installer needs these already present — it can't
# bootstrap itself with them missing. Debian/Ubuntu only; on any other
# distro (or without apt-get) install them manually first:
# https://docs.brew.sh/Homebrew-on-Linux#requirements
if [ "$(uname)" = "Linux" ] && { ! command -v curl >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; }; then
    if command -v apt-get >/dev/null 2>&1; then
        echo "Installing Homebrew's Linux prerequisites (curl, git, build-essential, procps, file)..."
        sudo apt-get update
        sudo apt-get install -y build-essential procps curl file git
    else
        echo "Error: curl/git missing and apt-get not found. Install Homebrew's Linux prerequisites manually: https://docs.brew.sh/Homebrew-on-Linux#requirements" >&2
        exit 1
    fi
fi

if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [ "$(uname)" = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ "$(uname)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

brew bundle --file="$XDG_CONFIG_HOME/dotfiles/Brewfile"

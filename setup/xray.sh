#!/bin/sh
# Configures xray from PROXY_SUBSCRIPTION_LINK (set it in .secrets) and starts
# it as a background service. No-op on machines without that secret set.
set -eu

if [ -z "${PROXY_SUBSCRIPTION_LINK:-}" ]; then
    exit 0
fi

if ! command -v brew >/dev/null 2>&1; then
    if [ -x /opt/homebrew/bin/brew ]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi
fi

if ! command -v xray >/dev/null 2>&1; then
    echo "PROXY_SUBSCRIPTION_LINK is set but xray isn't installed — check 'brew bundle' output" >&2
    exit 1
fi

if ! command -v python3 >/dev/null 2>&1; then
    echo "xray config generation needs python3, which isn't installed" >&2
    exit 1
fi

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
CONFIG_DIR="$(brew --prefix)/etc/xray"
mkdir -p "$CONFIG_DIR"

curl -fsSL "$PROXY_SUBSCRIPTION_LINK" \
    | python3 "$DOTFILES_DIR/setup/xray_config.py" \
    > "$CONFIG_DIR/config.json"

brew services restart xray

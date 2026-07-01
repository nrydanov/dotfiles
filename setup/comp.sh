#!/bin/sh
set -eu

ZSH_COMPLETIONS_DIR="${XDG_DATA_HOME}/zsh/completions"
mkdir -p "$ZSH_COMPLETIONS_DIR"

gen() {
    tool="$1"
    shift
    if command -v "$tool" >/dev/null 2>&1; then
        "$@" > "$ZSH_COMPLETIONS_DIR/_$tool"
    fi
}

gen kubectl kubectl completion zsh
gen just    just --completions zsh
gen docker  docker completion zsh
gen zellij  zellij setup --generate-completion zsh
gen rustup  rustup completions zsh

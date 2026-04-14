. ~/.config/dotfiles/.secrets

export LANG="en_US.UTF-8"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export HOMEBREW_NO_AUTO_UPDATE=1

typeset -U path
path=(
    $HOME/.local/bin
    $HOME/bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $path
)


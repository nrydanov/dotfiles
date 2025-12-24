export LANG="en_US.UTF-8"
export SHELL="/bin/zsh"
export EDITOR="nvim"
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"
export HOMEBREW_PREFIX="/opt/homebrew"

. ~/.config/dotfiles/.secrets


typeset -U path
path=(
    $HOME/bin
    $HOME/go/bin
    $HOME/.cargo/bin
    $path
)

if [ "$(uname)" = "Darwin" ]; then
    export HOMEBREW="/opt/homebrew"
    path=(
        $HOMEBREW_PREFIX/bin
        $HOMEBREW_PREFIX/Cellar/millet/0.14.7/bin
        $HOMEBREW_PREFIX/bison/bin
        $HOMEBREW_PREFIX/llvm/bin
        $HOMEBREW_PREFIX/ruby/bin
        $path
    )
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

export LANG="en_US.UTF-8"
export SHELL="/bin/zsh"
export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"

# Centralized PATH management
typeset -U path
path=(
    /usr/local/smlnj/bin
    $HOME/bin
    $HOME/.local/bin/miktex-dist
    $HOME/.modular/pkg/packages.modular.com_mojo/bin
    $HOME/go/bin
    $path
)

# MacOS specific exports
if [ "$(uname)" = "Darwin" ]; then
    export HOMEBREW="/opt/homebrew"
    path=(
        $HOMEBREW/bin
        $HOMEBREW/Cellar/millet/0.14.7/bin
        $HOMEBREW/bison/bin
        $HOMEBREW/llvm/bin
        $HOMEBREW/ruby/bin
        $path
    )
    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [ "$(uname)" = "Linux" ]; then
    path=(
        $HOME/.local/bin
        /opt/nvim
        $path
    )
fi

# Homes
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
export GPG_TTY=$(tty)
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'
export ZELLIJ_SCROLLBACK=2000

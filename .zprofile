
export LANG="en_US.UTF-8"
export SHELL="/bin/zsh"
export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


export PATH="/usr/local/smlnj/bin:$PATH"
export PATH="$HOMEBREW/bison/bin:$PATH"
export PATH="$HOMEBREW/llvm/bin:$PATH"
export PATH="$HOMEBREW/ruby/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin/miktex-dist:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"

if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then
    export PATH="/opt/homebrew/bin:$PATH"
    export HOMEBREW="/opt/homebrew"
fi

# Homes
export MODULAR_HOME="$HOME/.modular"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home

export GPG_TTY=$(tty)

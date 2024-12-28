export LANG="en_US.UTF-8"
export SHELL="/bin/zsh"
export EDITOR="nvim"

export XDG_CONFIG_HOME="$HOME/.config"
export XDG_CACHE_HOME="$HOME/.cache"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_STATE_HOME="$HOME/.local/state"


export PATH="/usr/local/smlnj/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin/miktex-dist:$PATH"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export PATH="$HOME/go/bin:$PATH"


# MacOS specific exports
if [ "$(uname)" = "Darwin" ]; then
    export HOMEBREW="/opt/homebrew"
    export PATH="$HOMEBREW/bin:$PATH"
    export PATH="$HOMEBREW/Cellar/millet/0.14.7/bin:$PATH"
    export PATH="$HOMEBREW/bison/bin:$PATH"
    export PATH="$HOMEBREW/llvm/bin:$PATH"
    export PATH="$HOMEBREW/ruby/bin:$PATH"


    export HOMEBREW_NO_AUTO_UPDATE=1
fi

if [ "$(uname)" = "Linux" ]; then
    export PATH="$HOME/.local/bin:$PATH"
    export PATH="/opt/nvim:$PATH"
fi

# Homes
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home
export GPG_TTY=$(tty)
export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# export NVM_DIR="$HOME/.nvm"
# [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

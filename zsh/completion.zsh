# Additional completions
if [ ! -d ${XDG_DATA_HOME}/zsh/completions ]; then
    mkdir -p ${XDG_DATA_HOME}/zsh/completions
    kubectl completion zsh > ${XDG_DATA_HOME}/zsh/completions/_kubectl
    just --completions zsh > ${XDG_DATA_HOME}/zsh/completions/_just
    docker completion zsh > ${XDG_DATA_HOME}/zsh/completions/_docker
    minikube completion zsh > ${XDG_DATA_HOME}/zsh/completions/_minikube
    zellij setup --generate-completion zsh > ${XDG_DATA_HOME}/zsh/completions/_zellij
    rustup completions zsh > ${XDG_DATA_HOME}/zsh/completions/_rustup
fi

fpath+=${XDG_DATA_HOME}/zsh/completions

if [ "$(uname)" = "Darwin" ]; then
    fpath+=$(brew --prefix)/share/zsh/site-functions
fi

LISTMAX=-1
# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

zstyle ':completion:*:default' list-colors "${LS_COLORS}"
zstyle ':autocomplete:*' min-delay 1.0  # float
zstyle ':autocomplete:*' min-input 3
zstyle ':autocomplete:async' enabled no

# 1. Load the menu module
zmodload zsh/complist

# 2. Enable the menu
zstyle ':completion:*' menu select

# 3. Essential: Adds the slash after the directory name
setopt AUTO_PARAM_SLASH

# 4. The Fix for Enter:
# 'send-break' exits the menu immediately and drops you back to the prompt.
# It prevents the "auto-dive" behavior you are seeing.
bindkey -M menuselect '^M' accept-search

# 5. Tab behavior:
# Just moves the highlight to the next item without entering it.
bindkey -M menuselect '^I' menu-complete
bindkey -M menuselect '^[[Z' reverse-menu-complete

# History settings
HISTFILE="$HOME/.zhistory"
SAVEHIST=10000
HISTSIZE=9999

setopt SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST PROMPT_SUBST HIST_IGNORE_ALL_DUPS
unsetopt pathdirs

# Zsh autosuggestions configuration (if using the plugin)
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

autoload -Uz compinit
compinit

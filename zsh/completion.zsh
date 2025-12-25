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

zmodload -i zsh/complist

bindkey              '^I' menu-select
bindkey -M menuselect              '^I'         menu-complete
bindkey -M menuselect "$terminfo[kcbt]" reverse-menu-complete
bindkey -M menuselect  '^[[D' .backward-char  '^[OD' .backward-char
bindkey -M menuselect  '^[[C'  .forward-char  '^[OC'  .forward-char


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

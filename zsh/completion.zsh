# --- Tool completions (generated per-file) ---
mkdir -p ${XDG_DATA_HOME}/zsh/completions
_comp_dir=${XDG_DATA_HOME}/zsh/completions
[ ! -f $_comp_dir/_kubectl  ] && kubectl completion zsh                      > $_comp_dir/_kubectl
[ ! -f $_comp_dir/_just     ] && just --completions zsh                      > $_comp_dir/_just
[ ! -f $_comp_dir/_docker   ] && docker completion zsh                       > $_comp_dir/_docker
[ ! -f $_comp_dir/_minikube ] && minikube completion zsh                     > $_comp_dir/_minikube
[ ! -f $_comp_dir/_zellij   ] && zellij setup --generate-completion zsh      > $_comp_dir/_zellij
[ ! -f $_comp_dir/_rustup   ] && rustup completions zsh                      > $_comp_dir/_rustup
unset _comp_dir

fpath+=${XDG_DATA_HOME}/zsh/completions
[[ "$(uname)" == "Darwin" ]] && fpath+=$(brew --prefix)/share/zsh/site-functions

# --- Load complist before compinit (required for menuselect) ---
zmodload zsh/complist

autoload -Uz compinit
compinit

# --- Completion behavior ---
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' menu select
zstyle ':completion:*:default' list-colors "${LS_COLORS}"

setopt AUTO_PARAM_SLASH
LISTMAX=0

# --- Menuselect keybindings ---
bindkey -M menuselect '^I'    menu-complete          # Tab: next candidate
bindkey -M menuselect '^[[Z'  reverse-menu-complete  # Shift-Tab: prev candidate
bindkey -M menuselect '^M'    accept-line            # Enter: accept
bindkey -M menuselect '^[[D'  send-break             # Left: exit menu
bindkey -M menuselect '^[[C'  send-break             # Right: exit menu

# --- History ---
HISTFILE="$HOME/.zhistory"
SAVEHIST=10000
HISTSIZE=9999
setopt SHARE_HISTORY HIST_EXPIRE_DUPS_FIRST PROMPT_SUBST HIST_IGNORE_ALL_DUPS
unsetopt pathdirs

# --- Autosuggestions ---
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)

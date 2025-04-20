
LISTMAX=-1
# Enable completion caching
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path "$XDG_CACHE_HOME/zsh/.zcompcache"

# Configure completion display and menu selection
zstyle ':completion:*' menu select
zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
zstyle ':completion:*:corrections' format '%F{yellow}!- %d (errors: %e) -!%f'
zstyle ':completion:*:messages' format '%F{purple}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'
zstyle ':completion:*:default' list-colors "${LS_COLORS}"
zstyle ':autocomplete:*' min-delay 1.0  # float
zstyle ':autocomplete:*' min-input 3
zstyle ':completion:*' list-prompt   ''
zstyle ':completion:*' select-prompt ''


bindkey              '^I' menu-select
bindkey "$terminfo[kcbt]" menu-select
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

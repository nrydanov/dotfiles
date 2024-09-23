HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
COLORS_FILE=~/.config/.nvimcolors

LSCOLORS=excxcxdxBxgxexabagacad
LS_COLORS="di=34:ln=32:so=32:pi=33:ex=1;31:bd=36:cd=34:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Bindings
if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then

    alias ls='ls --color=always'
    alias gcc='gcc -fdiagnostics-color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cargo='cargo --color=always'
    alias cargo-clippy='cargo-clippy --color=always'

fi

if [ "$(uname)" = "Darwin" ]; then
    source $HOMEBREW/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
    fpath=($(brew --prefix)/share/zsh/site-functions $fpath)
else
    source ~/.config/dotfiles/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Soeviy terminal
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Aliases
## Vim
alias vim=nvim
## Kitty SSH
alias ssh="kitten ssh"
## Kubernetes
alias k="kubectl"

# Sync vim colorscheme with terminal.
# Note: TermcolorsShow plugin is required for this to work

if [ ! -f $COLORS_FILE ]; then
    nvim -c "TermcolorsShow" -c ":w! $COLORS_FILE" -c "q"
    cat $COLORS_FILE >> ~/.config/kitty/kitty.conf
fi

if [ "$(uname)" = "Darwin" ]; then
    USER_COLOR=color3
    USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    VCS_COLOR=color4
    VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
    HOST_COLOR=color3
    HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    BACKGROUND_COLOR=inactive_tab_background
    BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)
else
    USER_COLOR=color2
    USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    VCS_COLOR=color4
    VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
    HOST_COLOR=color2
    HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    BACKGROUND_COLOR=inactive_tab_background
    BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)
fi

# Changing iTerm2 background with special escape sequence
echo -e "\033]Ph$BACKGROUND_COLOR_CODE\033\\"

# Homebrew
export HOMEBREW_NO_AUTO_UPDATE=1
# VCS display
autoload -Uz vcs_info
autoload -Uz add-zsh-hook
autoload -U colors && colors

zstyle ':vcs_info:*' enable git
precmd() { vcs_info }
zstyle ':vcs_info:git:*' formats '(%b) '

add-zsh-hook precmd precmd

# Additional completions
fpath=(~/.just/completions $fpath)
fpath=(~/.docker/completions \\$fpath)

skip_global_compinit=1

export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source <(kubectl completion zsh)
source "$HOME/.rye/env"
source ~/.config/dotfiles/completion.zsh

export WORDCHARS='*?_-.[]~&;!#$%^(){}<>'

# History tweaking
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt PROMPT_SUBST

# Prompt format string
PROMPT=$'%F{#$USER_COLOR_CODE}%n%f%F{#$HOST_COLOR_CODE}@%m %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '

bindkey '^[[1;3D' backward-word  # alt-left
bindkey '^[[1;3C' forward-word   # alt-right
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

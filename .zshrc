# Bindings
if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then
    alias ls='ls --color=auto'
    alias gcc='gcc -fdiagnostics-color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cargo='cargo --color=always'
    alias cargo-clippy='cargo-clippy --color=always'
fi

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

# Paths

export PATH="$HOME/.local/bin:$PATH"
export MODULAR_HOME="$HOME/.modular"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export TMPDIR=/tmp
export MODULAR_HOME="$HOME/.modular"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-21.jdk/Contents/Home

# Aliases
## Vim
alias vim=nvim
## Kitty SSH
alias s="kitten ssh"
## Kubernetes
alias k="kubectl"
set rtp+= $HOMEBREW/fzf
set rtp+=/opt/homebrew/opt/fzf

# Sync vim colorscheme with terminal. 
# Note: TermcolorsShow plugin is required for this to work
COLORS_FILE=~/.config/.nvimcolors

if [ ! -f $COLORS_FILE ]; then
    nvim -c "TermcolorsShow" -c ":w! $COLORS_FILE" -c "q"
    cat $COLORS_FILE >> ~/.config/kitty/kitty.conf
fi

USER_COLOR=color1
USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
VCS_COLOR=color4
VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
HOST_COLOR=color1
HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
BACKGROUND_COLOR=inactive_tab_background
BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)

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

autoload compinit && compinit
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source <(kubectl completion zsh)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME/.rye/env"

zstyle ':completion:*' menu select
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes 
# Prompt format string
setopt PROMPT_SUBST
export GPG_TTY=$(tty)
PROMPT=$'%F{#$USER_COLOR_CODE}no.art.in.living%f%F{#$HOST_COLOR_CODE}@ubuntu %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '
source "$HOME/.rye/env" 

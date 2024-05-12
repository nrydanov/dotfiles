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

HOMEBREW="/opt/homebrew/opt/"

export PATH="/usr/local/smlnj/bin:$PATH"
export PATH="$HOMEBREW/bison/bin:$PATH"
export PATH="$HOMEBREW/llvm/bin:$PATH"
export PATH="$HOMEBREW/ruby/bin:$PATH"
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin/miktex-dist:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.modular/pkg/packages.modular.com_mojo/bin:$PATH"
export TMPDIR=/tmp
export MODULAR_HOME="$HOME/.modular"
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk-14.0.2.jdk/Contents/Home
# Vim
alias vim=nvim
# alias rm=trash
set rtp+= $HOMEBREW/fzf

# Sync vim colorscheme with terminal. 
# Note: TermcolorsShow plugin is required for this to work
COLORS_FILE=~/.config/.nvimcolors

if [ ! -f $COLORS_FILE ]; then
    nvim -c "TermcolorsShow" -c ":w! $COLORS_FILE" -c "q"
    cat $COLORS_FILE >> ~/.config/kitty/kitty.conf
fi

USER_COLOR=color3
USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
VCS_COLOR=color4
VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
HOST_COLOR=color3
HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
BACKGROUND_COLOR=inactive_tab_background
BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)


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

autoload compinit && compinit
export ZSH_AUTOSUGGEST_STRATEGY=(completion history)
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source "$HOME/.rye/env"

zstyle ':completion:*' menu select
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes 
# Prompt format string
setopt PROMPT_SUBST
PROMPT=$'%F{#$USER_COLOR_CODE}%n%f%F{#$HOST_COLOR_CODE}@macbook %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '

export GPG_TTY=$(tty)

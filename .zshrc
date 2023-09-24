# Bindings

bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search

USERNAME="find.art.in.living"
# Paths

export PATH=/usr/local/smlnj/bin:"$PATH"
export PATH="/opt/homebrew/opt/bison/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export PATH="/opt/pypy3.9/bin:$PATH"
export PATH="/Users/$USERNAME/bin:$PATH"
export PATH="/Users/$USERNAME/.local/bin/miktex-dist:$PATH"
export PATH="/Users/$USERNAME/.cargo/bin:$PATH"
export TMPDIR=/tmp
# Vim
alias vim=nvim
set rtp+=/opt/homebrew/opt/fzf

# Sync vim colorscheme with terminal. 
# Note: TermcolorsShow plugin is required for this to work
COLORS_FILE=~/.config/.nvimcolors

if [ ! -f $COLORS_FILE ]; then
    nvim -c "TermcolorsShow" -c ":w! $COLORS_FILE" -c "q"
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
export NO_COLOR=1
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
source ~/.config/zsh/zsh-autosuggestions.zsh

zstyle ':completion:*' menu select
zstyle ':autocomplete:*complete*:*' insert-unambiguous yes 
# Prompt format string
setopt PROMPT_SUBST
PROMPT=$'%F{#$USER_COLOR_CODE}%n%f%F{#$HOST_COLOR_CODE}@macbook %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '
export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
export BAT_THEME="TwoDark"

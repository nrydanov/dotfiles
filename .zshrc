
source "$XDG_CONFIG_HOME"/dotfiles/zsh/zinit.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/aliases.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/bindkeys.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/history.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/git.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/completion.zsh
[ -x "$XDG_CONFIG_HOME/dotfiles/addons/advices.sh" ] && \
    "$XDG_CONFIG_HOME/dotfiles/addons/advices.sh" "$XDG_CONFIG_HOME/dotfiles/.advices"

# Prompt colors are ANSI slot numbers, so they follow the terminal's palette
# in both light and dark themes
setopt PROMPT_SUBST
if [ "$(uname)" = "Darwin" ]; then
    PROMPT_USER_HOST_COLOR=3
else
    PROMPT_USER_HOST_COLOR=2
fi
PROMPT_VCS_COLOR=4
LSCOLORS=excxcxdxBxgxexabagacad
LS_COLORS="di=34:ln=32:so=32:pi=33:ex=1;31:bd=36:cd=34:su=30;41:sg=30;46:tw=30;42:ow=30;43"

# Prompt format string
PROMPT=$'%F{$PROMPT_USER_HOST_COLOR}%n%f%F{$PROMPT_USER_HOST_COLOR}@%m %f%1~ %F{$PROMPT_VCS_COLOR}${vcs_info_msg_0_}%f$ '

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"


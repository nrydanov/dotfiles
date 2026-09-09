
source "$XDG_CONFIG_HOME"/dotfiles/zsh/zinit.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/aliases.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/bindkeys.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/colorscheme.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/history.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/git.zsh
source "$XDG_CONFIG_HOME"/dotfiles/zsh/completion.zsh
[ -x "$XDG_CONFIG_HOME/dotfiles/addons/advices.sh" ] && \
    "$XDG_CONFIG_HOME/dotfiles/addons/advices.sh" "$XDG_CONFIG_HOME/dotfiles/.advices"

# Prompt format string
PROMPT=$'%F{$PROMPT_USER_HOST_COLOR}%n%f%F{$PROMPT_USER_HOST_COLOR}@%m %f%1~ %F{$PROMPT_VCS_COLOR}${vcs_info_msg_0_}%f$ '

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"


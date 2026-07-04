
source ~/.config/dotfiles/zsh/zinit.zsh
source ~/.config/dotfiles/zsh/aliases.zsh
source ~/.config/dotfiles/zsh/bindkeys.zsh
source ~/.config/dotfiles/zsh/colorscheme.zsh
source ~/.config/dotfiles/zsh/history.zsh
source ~/.config/dotfiles/zsh/git.zsh
source ~/.config/dotfiles/zsh/completion.zsh
~/.config/dotfiles/addons/advices.sh ~/.config/dotfiles/.advices

# Prompt format string
PROMPT=$'%F{$PROMPT_USER_HOST_COLOR}%n%f%F{$PROMPT_USER_HOST_COLOR}@%m %f%1~ %F{$PROMPT_VCS_COLOR}${vcs_info_msg_0_}%f$ '

# bun completions
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"

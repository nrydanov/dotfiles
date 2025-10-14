source ~/.config/dotfiles/zsh/zinit.zsh
source ~/.config/dotfiles/zsh/aliases.zsh
source ~/.config/dotfiles/zsh/bindkeys.zsh
source ~/.config/dotfiles/zsh/colorscheme.zsh
source ~/.config/dotfiles/zsh/tweaks.zsh
source ~/.config/dotfiles/zsh/git.zsh
source ~/.config/dotfiles/zsh/completion.zsh
~/.config/dotfiles/addons/advices.sh ~/.config/dotfiles/.advices

# Prompt format string
PROMPT=$'%F{#$USER_COLOR_CODE}%n%f%F{#$HOST_COLOR_CODE}@%m %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '

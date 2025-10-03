source ~/.config/dotfiles/zsh/zinit.zsh
source ~/.config/dotfiles/zsh/aliases.zsh
source ~/.config/dotfiles/zsh/bindkeys.zsh
source ~/.config/dotfiles/zsh/colorscheme.zsh
source ~/.config/dotfiles/zsh/tweaks.zsh
source ~/.config/dotfiles/zsh/git.zsh
source ~/.config/dotfiles/zsh/completion.zsh
~/.config/dotfiles/addons/advices.sh ~/.config/dotfiles/.advices

set -a
# Prompt format string
PROMPT=$'%F{#$USER_COLOR_CODE}%n%f%F{#$HOST_COLOR_CODE}@%m %f%1~ %F{#$VCS_COLOR_CODE}${vcs_info_msg_0_}%f$ '

alias sbcl="rlwrap sbcl"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

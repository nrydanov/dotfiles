autoload -Uz vcs_info
autoload -U colors && colors
autoload -Uz add-zsh-hook

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b) '

add-zsh-hook precmd vcs_info

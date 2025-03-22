autoload -Uz vcs_info
autoload -U colors && colors

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '(%b) '

# Just define precmd without hooking it again
precmd() {
  vcs_info
}

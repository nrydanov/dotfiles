## Vim
alias vim=nvim
## Kubernetes
alias k="kubectl"
## SML/NJ (line editing, history, completions from ~/.sml_completions)
## -b: word-break chars without ".", so that List.map completes as one word
sml() {
    command rlwrap -r -b $' \t\n\r(){}[],+-=&^%$#@";|\\' -H ~/.sml_history sml "$@"
}

alias venv="source .venv/bin/activate"

## Color output
if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then
    alias ls='ls --color=auto'
    alias gcc='gcc -fdiagnostics-color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cargo='cargo --color=always'
    alias cargo-clippy='cargo-clippy --color=always'
fi

## Work timer (zjstatus bar, zellij/scripts/worktime.sh)
alias worktime="~/.config/zellij/scripts/worktime.sh show; echo"
alias worktime-pause="~/.config/zellij/scripts/worktime.sh pause; echo"
alias worktime-resume="~/.config/zellij/scripts/worktime.sh resume; echo"
alias worktime-reset="~/.config/zellij/scripts/worktime.sh reset; echo"
zellij() {
    case "$1" in
        ""|a|attach) ~/.config/zellij/scripts/worktime.sh attach >/dev/null ;;
    esac
    command zellij "$@"
}

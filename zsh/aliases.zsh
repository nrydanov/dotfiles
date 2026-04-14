## Claude via proxy
alias claude='https_proxy=http://127.0.0.1:8001 claude'

## Vim
alias vim=nvim
## Kubernetes
alias k="kubectl"

alias venv="source .venv/bin/activate"

## Color output
if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then
    alias ls='ls --color=always'
    alias gcc='gcc -fdiagnostics-color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cargo='cargo --color=always'
    alias cargo-clippy='cargo-clippy --color=always'
fi

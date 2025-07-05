# Bindings
if [ -x /usr/bin/dircolors ] || [ "$(uname)" = "Darwin" ]; then

    alias ls='ls --color=always'
    alias gcc='gcc -fdiagnostics-color=always'
    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
    alias cargo='cargo --color=always'
    alias cargo-clippy='cargo-clippy --color=always'

fi

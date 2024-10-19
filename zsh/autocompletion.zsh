if [ "$(uname)" = "Darwin" ]; then
    source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
    source $HOMEBREW/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh
else
    source ~/.config/dotfiles/zsh-autocomplete/zsh-autocomplete.plugin.zsh
fi

# Additional completions
if [ ! -d ${XDG_DATA_HOME}/zsh/completions ]; then
    mkdir -p ${XDG_DATA_HOME}/zsh/completions
    kubectl completion zsh > ${XDG_DATA_HOME}/zsh/completions/_kubectl
    just --completions zsh > ${XDG_DATA_HOME}/zsh/completions/_just
    docker completion zsh > ${XDG_DATA_HOME}/zsh/completions/_docker
    minikube completion zsh > ${XDG_DATA_HOME}/zsh/completions/_minikube
    zellij setup --completion zsh > ${XDG_DATA_HOME}/zsh/completions/_zellij
fi

fpath+=${XDG_DATA_HOME}/zsh/completions

if [ "$(uname)" = "Darwin" ]; then
    fpath+=$(brew --prefix)/share/zsh/site-functions
fi

# Additional completions
zinit load MenkeTechnologies/zsh-cargo-completion

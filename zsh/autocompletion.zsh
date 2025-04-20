# Additional completions
if [ ! -d ${XDG_DATA_HOME}/zsh/completions ]; then
    mkdir -p ${XDG_DATA_HOME}/zsh/completions
    kubectl completion zsh > ${XDG_DATA_HOME}/zsh/completions/_kubectl
    just --completions zsh > ${XDG_DATA_HOME}/zsh/completions/_just
    docker completion zsh > ${XDG_DATA_HOME}/zsh/completions/_docker
    minikube completion zsh > ${XDG_DATA_HOME}/zsh/completions/_minikube
    zellij setup --generate-completion zsh > ${XDG_DATA_HOME}/zsh/completions/_zellij
    rustup completions zsh > ${XDG_DATA_HOME}/zsh/completions/_rustup
fi

fpath+=${XDG_DATA_HOME}/zsh/completions

if [ "$(uname)" = "Darwin" ]; then
    fpath+=$(brew --prefix)/share/zsh/site-functions
fi

# Additional completions
zinit load MenkeTechnologies/zsh-cargo-completion

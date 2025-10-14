
ZSH_COMPLETIONS_DIR=${XDG_DATA_HOME}/zsh/completions

kubectl completion zsh > ${ZSH_COMPLETIONS_DIR}/_kubectl
just --completions zsh > ${ZSH_COMPLETIONS_DIR}/_just
docker completion zsh > ${ZSH_COMPLETIONS_DIR}/_docker
zellij setup --generate-completion zsh > ${ZSH_COMPLETIONS_DIR}/_zellij
rustup completions zsh > ${ZSH_COMPLETIONS_DIR}/_rustup

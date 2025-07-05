# Zinit Initialization File

# 1. Install Zinit if not already installed
if [[ ! -f "$HOME/.local/share/zinit/zinit.git/zinit.zsh" ]]; then
    print -P "%F{33}Installing %F{220}ZDHARMA-CONTINUUM Plugin Manager (zdharma-continuum/zinit)...%f"
    command mkdir -p "$HOME/.local/share/zinit" && command chmod g-rwX "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git" && \
        print -P "%F{33}Installation successful.%f" || \
        print -P "%F{160}The clone has failed.%f"
fi

# 2. Source Zinit
source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

zinit wait lucid light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust \
    joshskidmore/zsh-fzf-history-search \
    MenkeTechnologies/zsh-cargo-completion \
    marlonrichert/zsh-autocomplete \
    zsh-users/zsh-syntax-highlighting

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

# -------------------------------------------------
# 3. Load Annexes for Extended Functionality
#    (Using "light-mode" for minimal overhead)
# -------------------------------------------------
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

# -------------------------------------------------
# 4. Load Additional Plugins
#    Use "light-mode for" to load multiple repos
# -------------------------------------------------
zinit light-mode for zsh-users/zsh-syntax-highlighting


# zsh-fzf-history-search
zinit ice lucid wait '0'
zinit light joshskidmore/zsh-fzf-history-search
# -------------------------------------------------


# -------------------------------------------------
# End of Zinit configuration
# -------------------------------------------------

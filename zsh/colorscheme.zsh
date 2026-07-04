setopt PROMPT_SUBST

# Auto-detect the macOS system appearance as the default, so switching it in
# System Settings is picked up by any shell opened afterward — without this,
# $COLOR_MODE always silently defaulted to dark. Only used when $COLOR_MODE
# isn't already set explicitly (e.g. `COLOR_MODE=light zellij` still wins).
if [ -z "${COLOR_MODE:-}" ] && [ "$(uname)" = "Darwin" ]; then
    if [ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" = "Dark" ]; then
        COLOR_MODE=dark
    else
        COLOR_MODE=light
    fi
fi
export COLOR_MODE="${COLOR_MODE:-dark}"

# Prompt colors as ANSI slot numbers, not hex — the terminal's active palette
# (kitty dark.conf/light.conf, Ghostty's native theme switch) already maps
# these slots correctly for both color modes, so there's nothing to look up.
if [ "$(uname)" = "Darwin" ]; then
    PROMPT_USER_HOST_COLOR=3
else
    PROMPT_USER_HOST_COLOR=2
fi
PROMPT_VCS_COLOR=4

LSCOLORS=excxcxdxBxgxexabagacad
LS_COLORS="di=34:ln=32:so=32:pi=33:ex=1;31:bd=36:cd=34:su=30;41:sg=30;46:tw=30;42:ow=30;43"

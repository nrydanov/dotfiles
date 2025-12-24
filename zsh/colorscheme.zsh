setopt PROMPT_SUBST
COLOR_MODE="${COLOR_MODE:-dark}"
COLORS_FILE=~/.config/dotfiles/kitty/${COLOR_MODE}.conf

# Sync vim colorscheme with terminal.
# Note: TermcolorsShow plugin is required for this to work
if [ ! -f $COLORS_FILE ]; then
    nvim -c "TermcolorsShow" -c ":w! $COLORS_FILE" -c "q"
    cat $COLORS_FILE >> ~/.config/kitty/kitty.conf
fi

if [ "$(uname)" = "Darwin" ]; then
    if [ "${COLOR_MODE:-}" = "light" ]; then
        # Light
        USER_COLOR=color3
        USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
        VCS_COLOR=color4
        VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
        HOST_COLOR=color3
        HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
        BACKGROUND_COLOR=inactive_tab_background
        BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    else
        # Dark
        USER_COLOR=color3
        USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
        VCS_COLOR=color4
        VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
        HOST_COLOR=color3
        HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
        BACKGROUND_COLOR=inactive_tab_background
        BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    fi
else
    # Dark
    USER_COLOR=color2
    USER_COLOR_CODE=$(grep "$USER_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    VCS_COLOR=color4
    VCS_COLOR_CODE=$(grep "$VCS_COLOR" $COLORS_FILE | cut -d "#" -f 2)
    HOST_COLOR=color2
    HOST_COLOR_CODE=$(grep "$HOST_COLOR " $COLORS_FILE | cut -d "#" -f 2)
    BACKGROUND_COLOR=inactive_tab_background
    BACKGROUND_COLOR_CODE=$(grep "$BACKGROUND_COLOR " $COLORS_FILE | cut -d "#" -f 2)
fi

LSCOLORS=excxcxdxBxgxexabagacad
LS_COLORS="di=34:ln=32:so=32:pi=33:ex=1;31:bd=36:cd=34:su=30;41:sg=30;46:tw=30;42:ow=30;43"

#!/bin/zsh

ADVICE_FILE="$1"
STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}"
mkdir -p "$STATE_DIR"
STATE_FILE="$STATE_DIR/daily_advice"
CURRENT_DATE=$(date +"%Y-%m-%d")

if [[ ! -f "$STATE_FILE" ]] || [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "$CURRENT_DATE" ]]; then
    shuf -n 1 "$ADVICE_FILE" | cowsay
    echo "$CURRENT_DATE" > "$STATE_FILE"
fi


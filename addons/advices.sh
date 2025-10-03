#!/bin/zsh

ADVICE_FILE="$1"
STATE_FILE="/tmp/.daily_advice_$(whoami)"
CURRENT_DATE=$(date +"%Y-%m-%d")

if [[ ! -f "$STATE_FILE" ]] || [[ "$(cat "$STATE_FILE" 2>/dev/null)" != "$CURRENT_DATE" ]]; then
    shuf -n 1 "$ADVICE_FILE" | cowsay
    echo "$CURRENT_DATE" > "$STATE_FILE"
fi


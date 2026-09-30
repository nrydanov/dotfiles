#!/bin/sh
# Time worked today, for the zjstatus bar (zellij/layouts/default.kdl).
#
# Each tick records every minute that passed since the previous tick, so a late
# or skipped tick doesn't lose time — the counter can't drift behind the clock.
# A gap longer than $grace minutes counts as a break and isn't recorded, which
# is how time with zellij closed stays out of the total. zjstatus runs one
# instance per tab; the second tab of a minute finds nothing left to add.
#
# Usage:
#   worktime.sh          tick and print (what the status bar calls)
#   worktime.sh show     print without recording
#   worktime.sh pause    stop counting until resumed (a lunch break)
#   worktime.sh resume   start counting again
#   worktime.sh reset    forget today's time and start from zero
#   worktime.sh since 11:30   count today as unbroken work since that time
#   worktime.sh attach   reset on the first call of the day (zsh/aliases.zsh
#                        runs it on `zellij attach`: a session left open
#                        overnight keeps zjstatus ticking)
#
# Day files double as a log: `sort -u <file> | wc -l` = minutes worked.

grace=10

state_dir="${XDG_STATE_HOME:-$HOME/.local/state}/zellij-worktime"
file="$state_dir/$(date +%F)"
# Deliberately not per-day: a pause left on overnight stays on, and stays
# visible in the bar, instead of silently expiring at midnight.
paused="$state_dir/paused"

mkdir -p "$state_dir"

case "$1" in
    reset)
        : >"$file"
        ;;
    attach)
        if [ "$(cat "$state_dir/attached" 2>/dev/null)" != "$(date +%F)" ]; then
            : >"$file"
            date +%F >"$state_dir/attached"
        fi
        ;;
    pause)
        : >"$paused"
        ;;
    resume)
        rm -f "$paused"
        # Record the current minute so the next tick sees no gap and starts a
        # fresh stretch. Without this, a break shorter than $grace would be
        # backfilled by the tick below, undoing the pause.
        echo $(($(date +%s) / 60)) >>"$file"
        ;;
    since)
        start=$(date -j -f "%Y-%m-%d %H:%M:%S" "$(date +%F) $2:00" +%s 2>/dev/null) ||
            { echo "usage: $0 since HH:MM" >&2; exit 1; }
        minute=$((start / 60))
        now=$(($(date +%s) / 60))
        : >"$file"
        while [ "$minute" -le "$now" ]; do
            echo "$minute"
            minute=$((minute + 1))
        done >>"$file"
        ;;
    show)
        ;;
    *)
        if [ ! -e "$paused" ]; then
            now=$(($(date +%s) / 60))
            last=$(sort -n "$file" 2>/dev/null | tail -1)
            # No history, a break, or a clock jump: start a fresh stretch.
            if [ -z "$last" ] || [ "$((now - last))" -gt "$grace" ] || [ "$now" -lt "$last" ]; then
                last=$((now - 1))
            fi
            # A loop, not seq: BSD seq prints large numbers as 2.98e+07.
            minute=$((last + 1))
            while [ "$minute" -le "$now" ]; do
                echo "$minute"
                minute=$((minute + 1))
            done >>"$file"
        fi
        ;;
esac

minutes=$(sort -u "$file" 2>/dev/null | wc -l)
mark=''
[ -e "$paused" ] && mark='⏸ '
printf '%s%dh %02dm' "$mark" "$((minutes / 60))" "$((minutes % 60))"

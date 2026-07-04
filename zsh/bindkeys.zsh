# Soeviy terminal
bindkey '^[[A' up-line-or-search
bindkey '^[[B' down-line-or-search
bindkey '^[[1;3D' backward-word  # alt-left (kitty CSI encoding)
bindkey '^[[1;3C' forward-word   # alt-right (kitty CSI encoding)
bindkey '^[b' backward-word      # alt-left (Ghostty/Terminal.app meta encoding)
bindkey '^[f' forward-word       # alt-right (Ghostty/Terminal.app meta encoding)
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

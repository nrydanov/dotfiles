if [ "$(uname)" = "Darwin" ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

if [ "$(uname)" = "Linux" ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# llvm is keg-only, so brew never symlinks it into $HOMEBREW_PREFIX/bin.
# nvim's lsp.lua runs clangd as a bare `clangd`, so it needs to be on PATH.
# Must come after brew shellenv, which is what sets $HOMEBREW_PREFIX.
if [ -d "${HOMEBREW_PREFIX:-}/opt/llvm/bin" ]; then
    export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
fi

# Routes brew/git through the local xray SOCKS proxy (see setup/xray.sh) on
# machines where PROXY_SUBSCRIPTION_LINK is set in .secrets — a no-op
# everywhere else. Scoped to these two commands only, not the whole shell.
if [ -n "${PROXY_SUBSCRIPTION_LINK:-}" ]; then
    _dotfiles_proxy_url="socks5://127.0.0.1:1080"

    brew() {
        ALL_PROXY="$_dotfiles_proxy_url" HTTPS_PROXY="$_dotfiles_proxy_url" HTTP_PROXY="$_dotfiles_proxy_url" command brew "$@"
    }

    git() {
        ALL_PROXY="$_dotfiles_proxy_url" HTTPS_PROXY="$_dotfiles_proxy_url" HTTP_PROXY="$_dotfiles_proxy_url" command git "$@"
    }
fi

return {
    "williamboman/mason.nvim",
    opts = {
        ensure_installed = {
            "lua-language-server",
            "pyright",
        }
    },
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    }
}
